#include "include/thermal_usb/thermal_usb_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "thermal_usb_plugin.h"

void ThermalUsbPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  thermal_usb::ThermalUsbPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
