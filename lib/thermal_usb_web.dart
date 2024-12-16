// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:developer';
import 'dart:js_interop';
import 'dart:js' as js;
import 'package:web/web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:thermal_usb/model/usb_device.dart';
import 'thermal_usb_platform_interface.dart';

@JS()
external JSPromise<JSBoolean> connectUSBDevice();

@JS('print')
external void printReceipt(JSUint8Array data);

@JS('onDeviceConnected') // Bind to the JavaScript global variable or function
external JSExportedDartFunction onDeviceConnected(JSObject device);

@JS('onDeviceDisconnected') // Bind to the JavaScript global variable or function
external JSExportedDartFunction onDeviceDisconnected();

@JS('onError') // Bind to the JavaScript global variable or function
external JSExportedDartFunction onError(JSObject device);
// create JSFunction

/// A web implementation of the ThermalUsbPlatform of the ThermalUsb plugin.
class ThermalUsbWeb extends ThermalUsbPlatform {
  /// Constructs a ThermalUsbWeb

  static UsbDevice? usbDevice;
  static bool connected = false;

  static final ThermalUsbWeb _staticInstance = ThermalUsbWeb();

  static final StreamController<String> _connectionState =
      StreamController<String>.broadcast();

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
      connected = true;
      _connectionState.add('connected');
    });

    js.context['onDeviceDisconnected'] = js.allowInterop(() {
      log('Device disconnected: ');
      usbDevice = null;
      connected = false;
      _connectionState.add('disconnected');
    });

    js.context['onError'] = js.allowInterop((js.JsObject error) {
      log('error: $error');
      usbDevice = null;
      connected = false;
      _connectionState.add('connect_error');
    });
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
  Future<bool> pairDevice() async {
    _connectionState.add('connecting');
    connected = (await connectUSBDevice().toDart).toDart;
    log('connected: $connected');
    if (connected) {
      _connectionState.add('connected');
    } else {
      _connectionState.add('connect_error');
    }
    return connected;
  }

  @override
  Future<bool> print({List<int> data = const []}) async {
    try {
      if (connected == false) {
        await pairDevice();
      }
      _connectionState.add('printing');
      var me = Uint8List.fromList(data);
      var jsData = me.toJS;
      printReceipt(jsData);
      _connectionState.add('printed');
    } catch (e) {
      log(e.toString());
      _connectionState.add('print_error');
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

  @override
  StreamController<String> get connectionState => _connectionState;
}
