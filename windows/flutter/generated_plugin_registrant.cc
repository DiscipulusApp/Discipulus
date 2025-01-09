//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <app_links/app_links_plugin_c_api.h>
#include <connectivity_plus/connectivity_plus_windows_plugin.h>
#include <desktop_webview_window/desktop_webview_window_plugin.h>
#include <dynamic_color/dynamic_color_plugin_c_api.h>
#include <irondash_engine_context/irondash_engine_context_plugin_c_api.h>
#include <isar_flutter_libs/isar_flutter_libs_plugin.h>
#include <permission_handler_windows/permission_handler_windows_plugin.h>
#include <share_plus/share_plus_windows_plugin_c_api.h>
#include <super_native_extensions/super_native_extensions_plugin_c_api.h>
#include <url_launcher_windows/url_launcher_windows.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  AppLinksPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("AppLinksPluginCApi"));
  ConnectivityPlusWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ConnectivityPlusWindowsPlugin"));
  DesktopWebviewWindowPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("DesktopWebviewWindowPlugin"));
  DynamicColorPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("DynamicColorPluginCApi"));
  IrondashEngineContextPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("IrondashEngineContextPluginCApi"));
  IsarFlutterLibsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("IsarFlutterLibsPlugin"));
  PermissionHandlerWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PermissionHandlerWindowsPlugin"));
  SharePlusWindowsPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SharePlusWindowsPluginCApi"));
  SuperNativeExtensionsPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SuperNativeExtensionsPluginCApi"));
  UrlLauncherWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UrlLauncherWindows"));
}
