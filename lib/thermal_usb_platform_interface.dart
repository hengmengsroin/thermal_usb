import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'thermal_usb_method_channel.dart';

abstract class ThermalUsbPlatform extends PlatformInterface {
  /// Constructs a ThermalUsbPlatform.
  ThermalUsbPlatform() : super(token: _token);

  static final Object _token = Object();

  static ThermalUsbPlatform _instance = MethodChannelThermalUsb();

  /// The default instance of [ThermalUsbPlatform] to use.
  ///
  /// Defaults to [MethodChannelThermalUsb].
  static ThermalUsbPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ThermalUsbPlatform] when
  /// they register themselves.
  static set instance(ThermalUsbPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> getThermalStatus() {
    throw UnimplementedError('getThermalStatus() has not been implemented.');
  }

  Future<bool> printTest({List<int> data = const []}) {
    throw UnimplementedError('printTest() has not been implemented.');
  }

  Future<void> pairDevice() {
    throw UnimplementedError('pairDevice() has not been implemented.');
  }
}
