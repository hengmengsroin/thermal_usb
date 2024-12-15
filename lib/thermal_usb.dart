
import 'thermal_usb_platform_interface.dart';

class ThermalUsb {
  Future<String?> getPlatformVersion() {
    return ThermalUsbPlatform.instance.getPlatformVersion();
  }
}
