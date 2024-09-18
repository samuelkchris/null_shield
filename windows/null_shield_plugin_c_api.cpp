#include "include/null_shield/null_shield_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "null_shield_plugin.h"

void NullShieldPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  null_shield::NullShieldPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
