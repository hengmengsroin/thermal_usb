import 'thermal_usb_platform_interface.dart';

class ThermalUsb {
  Future<String?> getPlatformVersion() {
    return ThermalUsbPlatform.instance.getPlatformVersion();
  }

  Future<String?> getThermalStatus() {
    return ThermalUsbPlatform.instance.getThermalStatus();
  }

  Future<bool> printTest() {
    return ThermalUsbPlatform.instance.printTest();
  }

  Future<void> pairDevice(
      {required int vendorId,
      required int productId,
      int? interfaceNo,
      int? endpointNo}) {
    return ThermalUsbPlatform.instance.pairDevice(
        vendorId: vendorId,
        productId: productId,
        interfaceNo: interfaceNo,
        endpointNo: endpointNo);
  }
}
