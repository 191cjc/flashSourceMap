#include "native_app.h"

#include "include/cef_browser.h"
#include "include/cef_command_line.h"
#include "include/cef_parser.h"
#include "include/cef_request_context.h"
#include "include/cef_values.h"
#include "include/wrapper/cef_helpers.h"
#include "native_handler.h"

namespace {

constexpr const char* kDefaultUrl = "http://127.0.0.1:8787/native.html";

void AppendSwitchIfMissing(CefRefPtr<CefCommandLine> command_line, const char* name) {
  if (!command_line->HasSwitch(name)) {
    command_line->AppendSwitch(name);
  }
}

void AppendSwitchWithValueIfMissing(CefRefPtr<CefCommandLine> command_line, const char* name, const char* value) {
  if (!command_line->HasSwitch(name)) {
    command_line->AppendSwitchWithValue(name, value);
  }
}

CefString LaunchUrlFromCommandLine(CefRefPtr<CefCommandLine> command_line) {
  CefString url = command_line->GetSwitchValue("url");
  if (!url.empty()) {
    return url;
  }

  CefCommandLine::ArgumentList arguments;
  command_line->GetArguments(arguments);
  for (const auto& argument : arguments) {
    if (argument.ToString().find("://") != std::string::npos) {
      return argument;
    }
  }

  return kDefaultUrl;
}

void SetBooleanPreference(CefRefPtr<CefRequestContext> request_context, const char* name, bool preference) {
  CefRefPtr<CefValue> value = CefValue::Create();
  value->SetBool(preference);
  CefString error;
  request_context->SetPreference(name, value, error);
}

void SetIntegerPreference(CefRefPtr<CefRequestContext> request_context, const char* name, int preference) {
  CefRefPtr<CefValue> value = CefValue::Create();
  value->SetInt(preference);
  CefString error;
  request_context->SetPreference(name, value, error);
}

void AllowFlashPlugin(CefRefPtr<CefRequestContext> request_context) {
  SetIntegerPreference(request_context, "profile.default_content_setting_values.plugins", 1);
  SetIntegerPreference(request_context, "profile.managed_default_content_settings.plugins", 1);
  SetBooleanPreference(request_context, "plugins.run_all_flash_in_allow_mode", true);
  SetBooleanPreference(request_context, "plugins.always_authorize", true);
  SetBooleanPreference(request_context, "plugins.allow_outdated", true);
  SetBooleanPreference(request_context, "webkit.webprefs.plugins_enabled", true);
}

}  // namespace

NativeApp::NativeApp() = default;

CefRefPtr<CefBrowserProcessHandler> NativeApp::GetBrowserProcessHandler() {
  return this;
}

void NativeApp::OnBeforeCommandLineProcessing(const CefString& process_type, CefRefPtr<CefCommandLine> command_line) {
  if (!process_type.empty()) {
    return;
  }

  AppendSwitchIfMissing(command_line, "enable-system-flash");
  AppendSwitchIfMissing(command_line, "run-all-flash-in-allow-mode");
  AppendSwitchIfMissing(command_line, "allow-outdated-plugins");
  AppendSwitchIfMissing(command_line, "always-authorize-plugins");
  AppendSwitchIfMissing(command_line, "no-first-run");
  AppendSwitchIfMissing(command_line, "no-default-browser-check");
  AppendSwitchIfMissing(command_line, "no-sandbox");
  AppendSwitchWithValueIfMissing(command_line, "enable-features", "RunAllFlashInAllowMode");
  AppendSwitchWithValueIfMissing(command_line, "disable-features", "EphemeralFlashPermission");
}

void NativeApp::OnContextInitialized() {
  CEF_REQUIRE_UI_THREAD();

  CefRefPtr<CefCommandLine> command_line = CefCommandLine::GetGlobalCommandLine();
  CefWindowInfo window_info;
  window_info.SetAsPopup(nullptr, "FlashSourceMap Native Flash");

  CefBrowserSettings browser_settings;
  browser_settings.plugins = STATE_ENABLED;
  browser_settings.web_security = STATE_DISABLED;
  browser_settings.javascript = STATE_ENABLED;
  browser_settings.local_storage = STATE_ENABLED;

  CefRefPtr<CefRequestContext> request_context = CefRequestContext::GetGlobalContext();
  AllowFlashPlugin(request_context);

  CefBrowserHost::CreateBrowser(
    window_info,
    new NativeHandler(),
    LaunchUrlFromCommandLine(command_line),
    browser_settings,
    nullptr,
    request_context
  );
}
