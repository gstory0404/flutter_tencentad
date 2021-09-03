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
//        result(GDTSDKConfig.sdkVersion())
        result(true)
        break
    case "getSDKVersion":
        result("1.0.0")
    default:
        result(true)
        break
    }
  }
}
