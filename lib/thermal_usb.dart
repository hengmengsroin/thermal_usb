import 'thermal_usb_platform_interface.dart';

class ThermalUsb {
  Future<String?> getPlatformVersion() {
    return ThermalUsbPlatform.instance.getPlatformVersion();
  }

  Future<String?> getThermalStatus() {
    return ThermalUsbPlatform.instance.getThermalStatus();
  }

  Future<bool> printTest({List<int> data = const []}) {
    return ThermalUsbPlatform.instance.printTest(data: data);
  }

  Future<void> pairDevice() {
    return ThermalUsbPlatform.instance.pairDevice();
  }
}
