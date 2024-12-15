import 'package:flutter_test/flutter_test.dart';
import 'package:thermal_usb/thermal_usb.dart';
import 'package:thermal_usb/thermal_usb_platform_interface.dart';
import 'package:thermal_usb/thermal_usb_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockThermalUsbPlatform
    with MockPlatformInterfaceMixin
    implements ThermalUsbPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<String?> getThermalStatus() => Future.value('cool');

  @override
  Future<bool> printTest({List<int> data = const []}) => Future.value(true);

  @override
  Future<void> pairDevice() {
    throw UnimplementedError('pairDevice() has not been implemented.');
  }
}

void main() {
  final ThermalUsbPlatform initialPlatform = ThermalUsbPlatform.instance;

  test('$MethodChannelThermalUsb is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelThermalUsb>());
  });

  test('getPlatformVersion', () async {
    ThermalUsb thermalUsbPlugin = ThermalUsb();
    MockThermalUsbPlatform fakePlatform = MockThermalUsbPlatform();
    ThermalUsbPlatform.instance = fakePlatform;

    expect(await thermalUsbPlugin.getPlatformVersion(), '42');
  });

  test('getThermalStatus', () async {
    ThermalUsb thermalUsbPlugin = ThermalUsb();
    MockThermalUsbPlatform fakePlatform = MockThermalUsbPlatform();
    ThermalUsbPlatform.instance = fakePlatform;

    expect(await thermalUsbPlugin.getThermalStatus(), 'cool');
  });

  test('printTest', () async {
    ThermalUsb thermalUsbPlugin = ThermalUsb();
    MockThermalUsbPlatform fakePlatform = MockThermalUsbPlatform();
    ThermalUsbPlatform.instance = fakePlatform;

    expect(await thermalUsbPlugin.printTest(), isTrue);
  });

  tearDown(() {
    ThermalUsbPlatform.instance = initialPlatform;
  });

  test('pairDevice', () async {
    ThermalUsb thermalUsbPlugin = ThermalUsb();
    MockThermalUsbPlatform fakePlatform = MockThermalUsbPlatform();
    ThermalUsbPlatform.instance = fakePlatform;

    expect(() async {
      await thermalUsbPlugin.pairDevice();
    }, throwsUnimplementedError);
  });
}
