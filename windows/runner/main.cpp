#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>
#include <string>

#include <app_links/app_links_plugin_c_api.h>

#include "flutter_window.h"
#include "utils.h"

// Registers a custom URL protocol in HKCU\Software\Classes so deep links
// launch this executable without requiring admin rights.
void RegisterUrlProtocol(const wchar_t* protocol) {
  wchar_t exe_path[MAX_PATH];
  if (GetModuleFileNameW(nullptr, exe_path, MAX_PATH) == 0) {
    return;
  }

  std::wstring key_path = std::wstring(L"Software\\Classes\\") + protocol;
  HKEY hkey;
  if (RegCreateKeyExW(HKEY_CURRENT_USER, key_path.c_str(), 0, nullptr,
                      REG_OPTION_NON_VOLATILE, KEY_WRITE, nullptr, &hkey,
                      nullptr) == ERROR_SUCCESS) {
    std::wstring desc = std::wstring(L"URL:") + protocol + L" Protocol";
    RegSetValueExW(hkey, nullptr, 0, REG_SZ,
                   reinterpret_cast<const BYTE*>(desc.c_str()),
                   static_cast<DWORD>((desc.length() + 1) * sizeof(wchar_t)));
    RegSetValueExW(hkey, L"URL Protocol", 0, REG_SZ,
                   reinterpret_cast<const BYTE*>(L""),
                   static_cast<DWORD>(sizeof(wchar_t)));

    HKEY hcmd;
    std::wstring cmd_path = key_path + L"\\shell\\open\\command";
    if (RegCreateKeyExW(HKEY_CURRENT_USER, cmd_path.c_str(), 0, nullptr,
                        REG_OPTION_NON_VOLATILE, KEY_WRITE, nullptr, &hcmd,
                        nullptr) == ERROR_SUCCESS) {
      std::wstring command = std::wstring(L"\"") + exe_path + L"\" \"%1\"";
      RegSetValueExW(hcmd, nullptr, 0, REG_SZ,
                     reinterpret_cast<const BYTE*>(command.c_str()),
                     static_cast<DWORD>((command.length() + 1) * sizeof(wchar_t)));
      RegCloseKey(hcmd);
    }
    RegCloseKey(hkey);
  }
}

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command) {
  // If another instance is running and an app link was passed, forward it and exit.
  if (SendAppLinkToInstance()) {
    return EXIT_SUCCESS;
  }

  // Attach to console when present (e.g., 'flutter run') or create a
  // new console when running with a debugger.
  if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
    CreateAndAttachConsole();
  }

  // Initialize COM, so that it is available for use in the library and/or
  // plugins.
  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

  // Register custom URI schemes for Windows deep links
  RegisterUrlProtocol(L"m6loapp");
  RegisterUrlProtocol(L"discipulus");

  flutter::DartProject project(L"data");

  std::vector<std::string> command_line_arguments =
      GetCommandLineArguments();

  project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

  FlutterWindow window(project);
  Win32Window::Point origin(10, 10);
  Win32Window::Size size(1280, 720);
  if (!window.Create(L"Discipulus", origin, size)) {
    return EXIT_FAILURE;
  }
  window.SetQuitOnClose(true);

  ::MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  ::CoUninitialize();
  return EXIT_SUCCESS;
}
