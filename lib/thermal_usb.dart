import 'dart:async';
import 'thermal_usb_platform_interface.dart';

class ThermalUsb {
  StreamController<String> get connectionState =>
      ThermalUsbPlatform.instance.connectionState;

  Future<String?> getPlatformVersion() {
    return ThermalUsbPlatform.instance.getPlatformVersion();
  }

  Future<String?> getThermalStatus() {
    return ThermalUsbPlatform.instance.getThermalStatus();
  }

  Future<bool> print({List<int> data = const []}) {
    return ThermalUsbPlatform.instance.print(data: data);
  }

  Future<bool> pairDevice() {
    return ThermalUsbPlatform.instance.pairDevice();
  }
}
