// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:developer';
import 'dart:html';
import 'dart:js' as js;
import 'package:flutter/foundation.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:thermal_usb/usb_device.dart';

import 'thermal_usb_platform_interface.dart';

/// A web implementation of the ThermalUsbPlatform of the ThermalUsb plugin.
class ThermalUsbWeb extends ThermalUsbPlatform {
  /// Constructs a ThermalUsbWeb
  ThermalUsbWeb();
  final UsbDevice usbDevice = UsbDevice();
  var pairedDevice;

  //By Default, it is usually 0
  var interfaceNumber = 0;

  //By Default, it is usually 1
  var endpointNumber = 1;

  static void registerWith(Registrar registrar) {
    ThermalUsbPlatform.instance = ThermalUsbWeb();
    loadJavaScript();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    final version = window.navigator.userAgent;
    return version;
  }

  /// Returns a [String] containing the thermal status of the platform.
  /// This is a placeholder implementation that always returns 'cool'.
  /// This method should be overridden in a platform-specific implementation.
  /// See: https://flutter.dev/docs/development/platform-integration/platform-channels
  /// https://flutter.dev/docs/development/packages-and-plugins/developing-packages#platform-interface

  @override
  Future<String?> getThermalStatus() async {
    return 'cool';
  }

  @override
  Future<void> pairDevice(
      {int? vendorId,
      int? productId,
      int? interfaceNo,
      int? endpointNo}) async {
    // interfaceNumber = interfaceNo ?? 0;
    // endpointNumber = endpointNo ?? 1;
    // pairedDevice ??= await usbDevice.requestDevices(
    //     [DeviceFilter(vendorId: vendorId ?? 0, productId: productId ?? 0)]);
    // await usbDevice.open(pairedDevice);
    // await usbDevice.claimInterface(pairedDevice, interfaceNumber);
    try {
      js.context.callMethod("connectUSBDevice");
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<bool> printTest() async {
    var text = "Hello World!";
    var centerAlign = true;
    var encodedText = utf8.encode("$text\n");
    if (centerAlign) {
      var width = 28; // Change this to adjust the width of the printer
      var leftPadding = ((width - text.length) / 2).floor();
      var rightPadding = width - text.length - leftPadding;
      var paddingString =
          ''.padLeft(leftPadding) + text + ''.padRight(rightPadding);
      encodedText = utf8.encode("\n$paddingString\n");
    }
    var buffer = Uint8List.fromList(encodedText).buffer;
    await usbDevice.transferOut(pairedDevice, endpointNumber, buffer);
    return Future.value(true);
  }

  static Future<void> loadJavaScript() async {
    final script = document.createElement('script') as ScriptElement;
    script.src = '/assets/lib/usb_connector.js';
    script.type = 'text/javascript';
    script.async = true;
    document.head!.append(script);

    // Wait for the script to load
    await script.onLoad.first;
    log('JavaScript file loaded successfully.');
  }
}
