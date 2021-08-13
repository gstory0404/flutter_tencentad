import Flutter
import UIKit

public class SwiftFlutterTencentadPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_tencentad", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterTencentadPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    //
    case "register":
//        GDTSDKConfig.
        result(true)
        break
    default:
        result(true)
        break
    }
  }
}
