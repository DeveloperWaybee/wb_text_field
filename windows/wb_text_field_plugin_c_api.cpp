#include "include/wb_text_field/wb_text_field_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "wb_text_field_plugin.h"

void WbTextFieldPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  wb_text_field::WbTextFieldPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
