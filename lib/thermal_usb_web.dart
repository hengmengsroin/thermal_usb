// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'dart:developer';
import 'dart:html';
import 'dart:js' as js;
import 'package:flutter/foundation.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:thermal_usb/model/usb_device.dart';

import 'thermal_usb_platform_interface.dart';

/// A web implementation of the ThermalUsbPlatform of the ThermalUsb plugin.
class ThermalUsbWeb extends ThermalUsbPlatform {
  /// Constructs a ThermalUsbWeb
  ThermalUsbWeb();
  final UsbDevice usbDevice = UsbDevice();

  static void registerWith(Registrar registrar) {
    ThermalUsbPlatform.instance = ThermalUsbWeb();
    // loadJavaScript();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    final version = window.navigator.userAgent;
    return version;
  }

  /// Returns a [String] containing the thermal status of the platform.
  @override
  Future<String?> getThermalStatus() async {
    return 'cool';
  }

  @override
  Future<void> pairDevice() async {
    try {
      js.context.callMethod("connectUSBDevice");
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<bool> print({List<int> data = const []}) async {
    try {
      js.context.callMethod("print", [Uint8List.fromList(data)]);
    } catch (e) {
      log(e.toString());
    }
    return Future.value(true);
  }

  static Future<void> loadJavaScript() async {
    final script = document.createElement('script') as ScriptElement;
    script.src = 'assets/lib/usb_connector.js';
    script.type = 'text/javascript';
    script.async = true;
    document.head!.append(script);

    // Wait for the script to load
    await script.onLoad.first;
    log('JavaScript file loaded successfully.');
  }
}
