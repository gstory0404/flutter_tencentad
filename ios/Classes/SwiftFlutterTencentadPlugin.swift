import Flutter
import UIKit
import MySDK


public class SwiftFlutterTencentadPlugin: NSObject, FlutterPlugin {
  
  public static var event : FlutterTencentadEventPlugin?
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_tencentad", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterTencentadPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    //注册广告view
    FlutterTencentadViewPlugin.register(viewRegistrar:registrar)
    //注册event
    event = FlutterTencentadEventPlugin.init(registrar)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    //注册初始化
    case "register":
        let param = call.arguments as! NSDictionary
        LogUtil.logInstance.isShow(debug: param.value(forKey: "debug") as? Bool ?? false)
        let appId = param.value(forKey: "appId") as? String
        result(GDTSDKConfig.registerAppId(appId))
    case "getSDKVersion":
        result(GDTSDKConfig.sdkVersion())
//        result(true)
    //预加载激励广告
    case "loadRewardVideoAd":
        let param = call.arguments as! NSDictionary
        RewardedVideoAd.instance.loadRewardedVideoAd(params: param)
        result(true)
    //显示激励广告
    case "showRewardVideoAd":
        RewardedVideoAd.instance.showRewardedVideoAd()
        result(true)
    //预加载插屏广告
    case "loadInterstitialAD":
        let param = call.arguments as! NSDictionary
        InterstitialAd.instance.loadInterstitialAd(params: param)
        result(true)
    //展示插屏广告
    case "showInterstitialAD":
        InterstitialAd.instance.showInterstitialAd()
        result(true)
    default:
        result(true)
        break
    }
  }
}
