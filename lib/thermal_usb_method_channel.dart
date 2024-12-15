import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'thermal_usb_platform_interface.dart';

/// An implementation of [ThermalUsbPlatform] that uses method channels.
class MethodChannelThermalUsb extends ThermalUsbPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('thermal_usb');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
