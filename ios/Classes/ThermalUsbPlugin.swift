import Flutter
import UIKit

public class ThermalUsbPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "thermal_usb", binaryMessenger: registrar.messenger())
    let instance = ThermalUsbPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "getThermalStatus":
      result("cool")
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
