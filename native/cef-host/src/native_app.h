#ifndef FLASH_SOURCE_MAP_NATIVE_APP_H_
#define FLASH_SOURCE_MAP_NATIVE_APP_H_

#include "include/cef_app.h"

class NativeApp : public CefApp, public CefBrowserProcessHandler {
 public:
  NativeApp();

  CefRefPtr<CefBrowserProcessHandler> GetBrowserProcessHandler() override;
  void OnBeforeCommandLineProcessing(const CefString& process_type, CefRefPtr<CefCommandLine> command_line) override;
  void OnContextInitialized() override;

 private:
  IMPLEMENT_REFCOUNTING(NativeApp);
  DISALLOW_COPY_AND_ASSIGN(NativeApp);
};

#endif  // FLASH_SOURCE_MAP_NATIVE_APP_H_
