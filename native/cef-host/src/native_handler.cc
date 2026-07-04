#include "native_handler.h"

#include <algorithm>

#include "include/cef_app.h"
#include "include/wrapper/cef_helpers.h"

namespace {

NativeHandler* g_instance = nullptr;

}  // namespace

NativeHandler::NativeHandler() {
  DCHECK(!g_instance);
  g_instance = this;
}

NativeHandler::~NativeHandler() {
  g_instance = nullptr;
}

NativeHandler* NativeHandler::GetInstance() {
  return g_instance;
}

CefRefPtr<CefDisplayHandler> NativeHandler::GetDisplayHandler() {
  return this;
}

CefRefPtr<CefKeyboardHandler> NativeHandler::GetKeyboardHandler() {
  return this;
}

CefRefPtr<CefLifeSpanHandler> NativeHandler::GetLifeSpanHandler() {
  return this;
}

void NativeHandler::OnTitleChange(CefRefPtr<CefBrowser> browser, const CefString& title) {
  CEF_REQUIRE_UI_THREAD();

  CefWindowHandle hwnd = browser->GetHost()->GetWindowHandle();
  if (hwnd) {
    ::SetWindowTextW(hwnd, title.ToWString().c_str());
  }
}

void NativeHandler::OnAfterCreated(CefRefPtr<CefBrowser> browser) {
  CEF_REQUIRE_UI_THREAD();
  browsers_.push_back(browser);
}

bool NativeHandler::DoClose(CefRefPtr<CefBrowser> browser) {
  CEF_REQUIRE_UI_THREAD();

  if (browsers_.size() == 1) {
    is_closing_ = true;
  }
  return false;
}

void NativeHandler::OnBeforeClose(CefRefPtr<CefBrowser> browser) {
  CEF_REQUIRE_UI_THREAD();

  auto it = std::find(browsers_.begin(), browsers_.end(), browser);
  if (it != browsers_.end()) {
    browsers_.erase(it);
  }

  if (browsers_.empty()) {
    CefQuitMessageLoop();
  }
}

bool NativeHandler::OnPreKeyEvent(
  CefRefPtr<CefBrowser>,
  const CefKeyEvent&,
  CefEventHandle,
  bool*) {
  // The official cefclient sample consumes Space here for a demo alert.
  // This runtime leaves keyboard input untouched so Pepper Flash receives it.
  return false;
}
