import 'thermal_usb_platform_interface.dart';

class ThermalUsb {
  Future<String?> getPlatformVersion() {
    return ThermalUsbPlatform.instance.getPlatformVersion();
  }

  Future<String?> getThermalStatus() {
    return ThermalUsbPlatform.instance.getThermalStatus();
  }

  Future<bool> print({List<int> data = const []}) {
    return ThermalUsbPlatform.instance.print(data: data);
  }

  Future<void> pairDevice() {
    return ThermalUsbPlatform.instance.pairDevice();
  }
}
