#include <windows.h>

#include "include/cef_app.h"
#include "include/cef_command_line.h"
#include "native_app.h"

namespace {

std::wstring SwitchValueOrEmpty(CefRefPtr<CefCommandLine> command_line, const char* name) {
  CefString value = command_line->GetSwitchValue(name);
  return value.ToWString();
}

void ApplyStringSetting(cef_string_t* target, const std::wstring& value) {
  if (!value.empty()) {
    CefString(target).FromWString(value);
  }
}

}  // namespace

int APIENTRY wWinMain(HINSTANCE instance, HINSTANCE, wchar_t*, int) {
  CefEnableHighDPISupport();

  CefMainArgs main_args(instance);
  CefRefPtr<NativeApp> app(new NativeApp());

  const int exit_code = CefExecuteProcess(main_args, app, nullptr);
  if (exit_code >= 0) {
    return exit_code;
  }

  CefRefPtr<CefCommandLine> command_line = CefCommandLine::CreateCommandLine();
  command_line->InitFromString(::GetCommandLineW());

  CefSettings settings;
  settings.no_sandbox = true;
  settings.multi_threaded_message_loop = false;
  settings.persist_session_cookies = true;
  settings.persist_user_preferences = true;
  settings.remote_debugging_port = 9334;

  const std::wstring debug_port = SwitchValueOrEmpty(command_line, "remote-debugging-port");
  if (!debug_port.empty()) {
    settings.remote_debugging_port = _wtoi(debug_port.c_str());
  }

  ApplyStringSetting(&settings.cache_path, SwitchValueOrEmpty(command_line, "cache-path"));
  ApplyStringSetting(&settings.user_data_path, SwitchValueOrEmpty(command_line, "user-data-dir"));

  if (!CefInitialize(main_args, settings, app, nullptr)) {
    return 1;
  }

  CefRunMessageLoop();
  CefShutdown();
  return 0;
}
