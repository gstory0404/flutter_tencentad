//
//  SplashAdView.swift
//  flutter_tencentad
//
//  Created by 郭维佳 on 2021/9/7.
//

import Foundation

public class SplashAdView : NSObject,FlutterPlatformView,GDTSplashAdDelegate{
    
    private var container : UIView
    var frame: CGRect
    private var channel : FlutterMethodChannel?
    private var splashAd: GDTSplashAd!
    
    private var codeId: String?
    private var fetchDelay: Int = 0
    
    init(_ frame : CGRect,binaryMessenger: FlutterBinaryMessenger , id : Int64, params :Any?) {
        self.frame = frame
        self.container = UIView(frame: frame)
        let dict = params as! NSDictionary
        self.codeId = dict.value(forKey: "iosId") as? String
        self.fetchDelay = dict.value(forKey: "fetchDelay") as! Int
        super.init()
        self.channel = FlutterMethodChannel.init(name: FlutterTencentadConfig.view.splashAdView + "_" + String(id), binaryMessenger: binaryMessenger)
        loadSplashAd()
    }
    
    public func view() -> UIView {
        return container
    }
    
    private func loadSplashAd(){
        splashAd = GDTSplashAd.init(placementId: self.codeId)
        splashAd.delegate = self
        splashAd.fetchDelay = CGFloat(self.fetchDelay)
        self.splashAd.loadFullScreenAd()
    }
    
    /**
     *  开屏广告关闭回调
     */
    public func splashAdClosed(_ splashAd: GDTSplashAd!) {
        LogUtil.logInstance.printLog(message: "开屏广告关闭")
//        self.channel?.invokeMethod("onClose", arguments: "")
    }
    
    /**
     *  开屏广告点击回调
     */
    public func splashAdClicked(_ splashAd: GDTSplashAd!) {
        LogUtil.logInstance.printLog(message: "开屏广告点击")
        self.channel?.invokeMethod("onClick", arguments: "")
    }
    
    /**
     *  开屏广告曝光回调
     */
    public func splashAdExposured(_ splashAd: GDTSplashAd!) {
        LogUtil.logInstance.printLog(message: "开屏广告曝光回调")
        self.channel?.invokeMethod("onExpose", arguments: "")

    }
    
    /**
     *  开屏广告素材加载成功
     */
    public func splashAdDidLoad(_ splashAd: GDTSplashAd!) {
        LogUtil.logInstance.printLog(message: "开屏广告素材加载成功")
        if(!splashAd.isAdValid()){
            LogUtil.logInstance.printLog(message: "开屏广告展示失败")
            return
        }
        let window = UIApplication.shared.keyWindow
        self.splashAd.showFullScreenAd(in: window, withLogoImage: nil, skip: nil)
    }
    
    /**
     *  开屏广告展示失败
     */
    public func splashAdFail(toPresent splashAd: GDTSplashAd!, withError error: Error!) {
        LogUtil.logInstance.printLog(message: "开屏广告展示失败")
        LogUtil.logInstance.printLog(message: error)
        let map : NSDictionary = ["code":-1,
                                  "message":error.debugDescription]
        self.channel?.invokeMethod("onFail", arguments: map)
    }
    
    /**
     *  开屏广告将要关闭回调
     */
    public func splashAdWillClosed(_ splashAd: GDTSplashAd!) {
        LogUtil.logInstance.printLog(message: "开屏广告将要关闭")
        //开屏广告使用window展示 所以提前监听关闭 不然会有较长时间空白
        self.channel?.invokeMethod("onClose", arguments: "")
    }
    
    /**
     *  开屏广告成功展示
     */
    public func splashAdSuccessPresentScreen(_ splashAd: GDTSplashAd!) {
        LogUtil.logInstance.printLog(message: " 开屏广告成功展示")
        self.channel?.invokeMethod("onShow", arguments: "")
    }
    
    /**
     *  应用进入后台时回调
     *  详解: 当点击下载应用时会调用系统程序打开，应用切换到后台
     */
    public func splashAdApplicationWillEnterBackground(_ splashAd: GDTSplashAd!) {
        LogUtil.logInstance.printLog(message: "应用进入后台时回调")
    }
    
    /**
     *  开屏广告点击以后弹出全屏广告页
     */
    public func splashAdDidPresentFullScreenModal(_ splashAd: GDTSplashAd!) {
        LogUtil.logInstance.printLog(message: "开屏广告点击以后弹出全屏广告页")
    }
    
    /**
     *  点击以后全屏广告页已经关闭
     */
    public func splashAdDidDismissFullScreenModal(_ splashAd: GDTSplashAd!) {
        LogUtil.logInstance.printLog(message: "点击以后全屏广告页已经关闭")
    }
    
    /**
     *  开屏广告点击以后即将弹出全屏广告页
     */
    public func splashAdWillPresentFullScreenModal(_ splashAd: GDTSplashAd!) {
        LogUtil.logInstance.printLog(message: " 开屏广告点击以后即将弹出全屏广告页")
    }
    
    
    /**
     *  点击以后全屏广告页将要关闭
     */
    public func splashAdWillDismissFullScreenModal(_ splashAd: GDTSplashAd!) {
        LogUtil.logInstance.printLog(message: "点击以后全屏广告页将要关闭")
    }

}
