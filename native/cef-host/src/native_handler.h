#ifndef FLASH_SOURCE_MAP_NATIVE_HANDLER_H_
#define FLASH_SOURCE_MAP_NATIVE_HANDLER_H_

#include <list>

#include "include/cef_client.h"

class NativeHandler : public CefClient,
                      public CefDisplayHandler,
                      public CefKeyboardHandler,
                      public CefLifeSpanHandler {
 public:
  NativeHandler();
  ~NativeHandler() override;

  static NativeHandler* GetInstance();

  CefRefPtr<CefDisplayHandler> GetDisplayHandler() override;
  CefRefPtr<CefKeyboardHandler> GetKeyboardHandler() override;
  CefRefPtr<CefLifeSpanHandler> GetLifeSpanHandler() override;

  void OnTitleChange(CefRefPtr<CefBrowser> browser, const CefString& title) override;
  void OnAfterCreated(CefRefPtr<CefBrowser> browser) override;
  bool DoClose(CefRefPtr<CefBrowser> browser) override;
  void OnBeforeClose(CefRefPtr<CefBrowser> browser) override;
  bool OnPreKeyEvent(
    CefRefPtr<CefBrowser> browser,
    const CefKeyEvent& event,
    CefEventHandle os_event,
    bool* is_keyboard_shortcut) override;

 private:
  std::list<CefRefPtr<CefBrowser>> browsers_;
  bool is_closing_ = false;

  IMPLEMENT_REFCOUNTING(NativeHandler);
  DISALLOW_COPY_AND_ASSIGN(NativeHandler);
};

#endif  // FLASH_SOURCE_MAP_NATIVE_HANDLER_H_
