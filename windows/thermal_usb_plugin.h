#ifndef FLUTTER_PLUGIN_THERMAL_USB_PLUGIN_H_
#define FLUTTER_PLUGIN_THERMAL_USB_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace thermal_usb {

class ThermalUsbPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  ThermalUsbPlugin();

  virtual ~ThermalUsbPlugin();

  // Disallow copy and assign.
  ThermalUsbPlugin(const ThermalUsbPlugin&) = delete;
  ThermalUsbPlugin& operator=(const ThermalUsbPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace thermal_usb

#endif  // FLUTTER_PLUGIN_THERMAL_USB_PLUGIN_H_
