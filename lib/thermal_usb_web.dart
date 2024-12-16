// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'dart:developer';
import 'dart:js_interop';
import 'dart:js' as js;
import 'package:web/web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:thermal_usb/model/usb_device.dart';
import 'thermal_usb_platform_interface.dart';

@JS()
external void connectUSBDevice();

@JS('print')
external void printReceipt(JSUint8Array data);

@JS('onDeviceConnected') // Bind to the JavaScript global variable or function
external JSExportedDartFunction onDeviceConnected(JSObject device);

@JS('onDeviceDisconnected') // Bind to the JavaScript global variable or function
external JSExportedDartFunction onDeviceDisconnected();

// create JSFunction

/// A web implementation of the ThermalUsbPlatform of the ThermalUsb plugin.
class ThermalUsbWeb extends ThermalUsbPlatform {
  /// Constructs a ThermalUsbWeb

  static UsbDevice? usbDevice;

  static final ThermalUsbWeb _staticInstance = ThermalUsbWeb();

  static Stream eventSubscription = Stream.empty();

  static ThermalUsbWeb getInstance() {
    return _staticInstance;
  }

  static void registerWith(Registrar registrar) {
    ThermalUsbPlatform.instance = ThermalUsbWeb();
    // loadJavaScript();
    js.context['onDeviceConnected'] = js.allowInterop((js.JsObject device) {
      log('Device connected: $device');
      // convert JSObject to Map
      usbDevice = UsbDevice(
          type: "type",
          connected: true,
          productId: "productId",
          vendorId: "vendorId");
    });

    // js.context['onDeviceDisconnected'] = js.allowInterop(() {
    //   log('Device disconnected: ');
    //   usbDevice = null;
    // });
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
      connectUSBDevice();
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<bool> print({List<int> data = const []}) async {
    try {
      if (usbDevice == null) {
        return Future.value(false);
      }
      var me = Uint8List.fromList(data);
      var jsData = me.toJS;
      printReceipt(jsData);
    } catch (e) {
      log(e.toString());
    }
    return Future.value(true);
  }

  static Future<void> loadJavaScript() async {
    final script = document.createElement('script') as HTMLScriptElement;
    script.src = 'assets/lib/usb_connector.js';
    script.type = 'text/javascript';
    document.body!.append(script);

    await script.onLoad.first;
    log('JavaScript file loaded successfully.');
  }
}
