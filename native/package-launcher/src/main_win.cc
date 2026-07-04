#include <windows.h>
#include <shlwapi.h>

#include <string>
#include <vector>

namespace {

std::wstring LastErrorMessage(const wchar_t* prefix) {
  DWORD error = GetLastError();
  wchar_t* message = nullptr;
  FormatMessageW(
      FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS,
      nullptr,
      error,
      MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
      reinterpret_cast<wchar_t*>(&message),
      0,
      nullptr);

  std::wstring result(prefix);
  result += L"\n\nError ";
  result += std::to_wstring(error);
  result += L": ";
  if (message) {
    result += message;
    LocalFree(message);
  }
  return result;
}

std::wstring ModulePath() {
  std::vector<wchar_t> buffer(MAX_PATH);
  while (true) {
    DWORD length = GetModuleFileNameW(nullptr, buffer.data(), static_cast<DWORD>(buffer.size()));
    if (length == 0) {
      return L"";
    }
    if (length < buffer.size() - 1) {
      return std::wstring(buffer.data(), length);
    }
    buffer.resize(buffer.size() * 2);
  }
}

std::wstring ParentPath(std::wstring path) {
  PathRemoveFileSpecW(&path[0]);
  path.resize(wcslen(path.c_str()));
  return path;
}

std::wstring JoinPath(const std::wstring& left, const std::wstring& right) {
  if (left.empty()) {
    return right;
  }
  if (left.back() == L'\\' || left.back() == L'/') {
    return left + right;
  }
  return left + L"\\" + right;
}

bool Exists(const std::wstring& path) {
  DWORD attributes = GetFileAttributesW(path.c_str());
  return attributes != INVALID_FILE_ATTRIBUTES;
}

void SetEnv(const wchar_t* name, const std::wstring& value) {
  SetEnvironmentVariableW(name, value.c_str());
}

std::wstring GetEnv(const wchar_t* name) {
  DWORD needed = GetEnvironmentVariableW(name, nullptr, 0);
  if (needed == 0) {
    return L"";
  }
  std::wstring value(needed, L'\0');
  DWORD written = GetEnvironmentVariableW(name, &value[0], needed);
  value.resize(written);
  return value;
}

std::wstring Quote(const std::wstring& value) {
  std::wstring result = L"\"";
  for (wchar_t ch : value) {
    if (ch == L'"') {
      result += L'\\';
    }
    result += ch;
  }
  result += L"\"";
  return result;
}

bool EnsureDirectory(const std::wstring& path) {
  if (Exists(path)) {
    return true;
  }
  return CreateDirectoryW(path.c_str(), nullptr) || GetLastError() == ERROR_ALREADY_EXISTS;
}

HANDLE OpenLauncherLog(const std::wstring& root) {
  std::wstring dataDir = JoinPath(root, L"data");
  EnsureDirectory(dataDir);

  SECURITY_ATTRIBUTES security = {};
  security.nLength = sizeof(security);
  security.bInheritHandle = TRUE;

  HANDLE log = CreateFileW(
      JoinPath(dataDir, L"launcher.log").c_str(),
      FILE_APPEND_DATA,
      FILE_SHARE_READ,
      &security,
      OPEN_ALWAYS,
      FILE_ATTRIBUTE_NORMAL,
      nullptr);
  if (log != INVALID_HANDLE_VALUE) {
    SetFilePointer(log, 0, nullptr, FILE_END);
  }
  return log;
}

void WriteLog(HANDLE log, const std::wstring& message) {
  if (log == INVALID_HANDLE_VALUE) {
    return;
  }
  SYSTEMTIME time = {};
  GetLocalTime(&time);
  wchar_t prefix[64] = {};
  swprintf_s(
      prefix,
      L"[%04u-%02u-%02u %02u:%02u:%02u] ",
      time.wYear,
      time.wMonth,
      time.wDay,
      time.wHour,
      time.wMinute,
      time.wSecond);
  std::wstring line = std::wstring(prefix) + message + L"\r\n";
  int bytesNeeded = WideCharToMultiByte(CP_UTF8, 0, line.c_str(), -1, nullptr, 0, nullptr, nullptr);
  if (bytesNeeded <= 1) {
    return;
  }
  std::string utf8(bytesNeeded - 1, '\0');
  WideCharToMultiByte(CP_UTF8, 0, line.c_str(), -1, &utf8[0], bytesNeeded, nullptr, nullptr);
  DWORD written = 0;
  WriteFile(log, utf8.data(), static_cast<DWORD>(utf8.size()), &written, nullptr);
}

void ConfigureEnvironment(const std::wstring& root) {
  std::wstring appRoot = JoinPath(root, L"app");
  std::wstring saveRoot = JoinPath(root, L"data\\saveData");
  std::wstring appData = GetEnv(L"APPDATA");
  std::wstring legacyDb = appData.empty()
      ? L""
      : JoinPath(appData, L"flash-source-map\\saveData\\local-save.db");
  std::wstring packageDb = JoinPath(saveRoot, L"local-save.db");
  std::wstring packageLegacySaves = JoinPath(root, L"data\\runtime-mock-saves.json");

  SetEnv(L"SAVE_DATA_PROJECT_ROOT", appRoot);
  SetEnv(L"SAVE_DATA_WORKSPACE_ROOT", saveRoot);
  if (!legacyDb.empty() && Exists(legacyDb)) {
    SetEnv(L"SAVE_DATA_DB", legacyDb);
    SetEnvironmentVariableW(L"SAVE_DATA_LEGACY_SAVES_FILE", nullptr);
  } else {
    SetEnv(L"SAVE_DATA_DB", packageDb);
    if (Exists(packageLegacySaves)) {
      SetEnv(L"SAVE_DATA_LEGACY_SAVES_FILE", packageLegacySaves);
    }
  }

  SetEnv(L"NATIVE_FLASH_BROWSER_PATH", JoinPath(root, L"cef\\Release\\flash-native-host.exe"));
  SetEnv(L"NATIVE_FLASH_PEPPER_PATH", JoinPath(root, L"cef\\Release\\pepflashplayer64.dll"));
  SetEnv(L"NATIVE_FLASH_USER_DATA_DIR", JoinPath(root, L"data\\cef-profile"));
  SetEnv(L"NATIVE_FLASH_AUTO_DOWNLOAD_CEF", L"0");
  SetEnv(L"NATIVE_FLASH_DISABLE_REFERENCE", L"1");
  SetEnv(L"SAVE_DATA_LOGS", L"0");
}

}  // namespace

int APIENTRY wWinMain(HINSTANCE, HINSTANCE, wchar_t*, int) {
  std::wstring module = ModulePath();
  if (module.empty()) {
    MessageBoxW(nullptr, LastErrorMessage(L"Cannot resolve launcher path.").c_str(), L"FlashSourceMap", MB_ICONERROR);
    return 1;
  }

  std::wstring root = ParentPath(module);
  ConfigureEnvironment(root);

  std::wstring node = JoinPath(root, L"node\\node.exe");
  std::wstring script = JoinPath(root, L"app\\tools\\launch-native-flash-mock.cjs");
  if (!Exists(node) || !Exists(script)) {
    MessageBoxW(nullptr, L"The package is incomplete. node.exe or launch script is missing.", L"FlashSourceMap", MB_ICONERROR);
    return 1;
  }

  HANDLE log = OpenLauncherLog(root);
  WriteLog(log, L"Launcher started.");
  STARTUPINFOW startup = {};
  startup.cb = sizeof(startup);
  startup.dwFlags = STARTF_USESHOWWINDOW;
  startup.wShowWindow = SW_HIDE;
  BOOL inheritHandles = FALSE;
  HANDLE input = INVALID_HANDLE_VALUE;
  if (log != INVALID_HANDLE_VALUE) {
    SECURITY_ATTRIBUTES security = {};
    security.nLength = sizeof(security);
    security.bInheritHandle = TRUE;
    input = CreateFileW(
        L"NUL",
        GENERIC_READ,
        FILE_SHARE_READ | FILE_SHARE_WRITE,
        &security,
        OPEN_EXISTING,
        FILE_ATTRIBUTE_NORMAL,
        nullptr);
    startup.dwFlags |= STARTF_USESTDHANDLES;
    startup.hStdInput = input == INVALID_HANDLE_VALUE ? nullptr : input;
    startup.hStdOutput = log;
    startup.hStdError = log;
    inheritHandles = TRUE;
  }

  std::wstring command = Quote(node) + L" " + Quote(script);
  WriteLog(log, L"Starting: " + command);
  PROCESS_INFORMATION process = {};
  BOOL started = CreateProcessW(
      nullptr,
      &command[0],
      nullptr,
      nullptr,
      inheritHandles,
      CREATE_NO_WINDOW,
      nullptr,
      root.c_str(),
      &startup,
      &process);

  if (!started) {
    WriteLog(log, LastErrorMessage(L"CreateProcess failed."));
    if (input != INVALID_HANDLE_VALUE) {
      CloseHandle(input);
    }
    if (log != INVALID_HANDLE_VALUE) {
      CloseHandle(log);
    }
    MessageBoxW(nullptr, LastErrorMessage(L"Cannot start FlashSourceMap.").c_str(), L"FlashSourceMap", MB_ICONERROR);
    return 1;
  }

  WriteLog(log, L"Node process started.");
  if (input != INVALID_HANDLE_VALUE) {
    CloseHandle(input);
  }
  if (log != INVALID_HANDLE_VALUE) {
    CloseHandle(log);
  }

  CloseHandle(process.hThread);
  CloseHandle(process.hProcess);
  return 0;
}
