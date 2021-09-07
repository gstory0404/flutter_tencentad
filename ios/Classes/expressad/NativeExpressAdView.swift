//
//  NativeExpressAdView.swift
//  flutter_tencentad
//
//  Created by gstory on 2021/9/1.
//

import Foundation
import MySDK

public class NativeExpressAdView : NSObject,FlutterPlatformView,GDTNativeExpressAdDelegete{
    
    
    private var container : UIView
    var frame: CGRect
    private var channel : FlutterMethodChannel?
    private var nativeExpressAd:GDTNativeExpressAd?
    
    private var codeId: String?
    private var viewWidth: Float?
    private var viewHeight: Float?
    
    
    init(_ frame : CGRect,binaryMessenger: FlutterBinaryMessenger , id : Int64, params :Any?) {
        self.frame = frame
        self.container = UIView(frame: frame)
        let dict = params as! NSDictionary
        self.codeId = dict.value(forKey: "codeId") as? String
        self.viewWidth = Float(dict.value(forKey: "viewWidth") as! Double)
        self.viewHeight = Float(dict.value(forKey: "viewHeight") as! Double)
        super.init()
        self.channel = FlutterMethodChannel.init(name: FlutterTencentadConfig.view.nativeAdView + "_" + String(id), binaryMessenger: binaryMessenger)
        self.loadBannerAd()
    }
    
    public func view() -> UIView {
        return container
    }
    
    private func loadBannerAd(){
         self.removeAllView()
         LogUtil.logInstance.printLog(message: "开始初始化")
         if nativeExpressAd == nil {
            self.nativeExpressAd = GDTNativeExpressAd.init(placementId: self.codeId, adSize: CGSize(width: Int(self.viewWidth!), height: Int(self.viewHeight!)))
            self.nativeExpressAd?.delegate = self
        }
        self.nativeExpressAd?.load(1)
    }
    
    private func removeAllView(){
        self.container.removeFromSuperview()
    }
        
    private func disposeView() {
        self.removeAllView()
    }
    
    /**
     * 拉取原生模板广告成功
     */
    public func nativeExpressAdSuccess(toLoad nativeExpressAd: GDTNativeExpressAd!, views: [GDTNativeExpressAdView]!) {
        LogUtil.logInstance.printLog(message: "信息流拉取原生模板广告成功")
        if(views.count > 0){
            let expressView:GDTNativeExpressAdView = views[0]
            expressView.controller = MyUtils.getVC()
            expressView.render()
            self.container.addSubview(expressView)
        }
    }
    
    /**
     * 原生模板广告被关闭
     */
    public func nativeExpressAdViewClosed(_ nativeExpressAdView: GDTNativeExpressAdView!) {
        LogUtil.logInstance.printLog(message: "信息流原生模板广告被关闭")
        self.channel?.invokeMethod("onClose", arguments: "")
    }
    
    /**
     * 原生模板广告点击回调
     */
    public func nativeExpressAdViewClicked(_ nativeExpressAdView: GDTNativeExpressAdView!) {
        LogUtil.logInstance.printLog(message: "信息流原生模板广告点击")
        self.channel?.invokeMethod("onClick", arguments: "")
    }
    
    
    /**
     * 原生模板广告曝光回调
     */
    public func nativeExpressAdViewExposure(_ nativeExpressAdView: GDTNativeExpressAdView!) {
        LogUtil.logInstance.printLog(message: "信息流原生模板广告曝光")
        self.channel?.invokeMethod("onExpose", arguments: "")
    }
    
    /**
     * 原生模板广告渲染失败
     */
    public func nativeExpressAdViewRenderFail(_ nativeExpressAdView: GDTNativeExpressAdView!) {
        LogUtil.logInstance.printLog(message: "信息流原生模板广告渲染失败")
        let map : NSDictionary = ["onAdMethod":"onFail",
                                  "code":-1,
                                  "message":"信息流原生模板广告渲染失败"]
        self.channel?.invokeMethod("onFail", arguments: map)
    }
    
    /**
     * 拉取原生模板广告失败
     */
    public func nativeExpressAdFail(toLoad nativeExpressAd: GDTNativeExpressAd!, error: Error!) {
        LogUtil.logInstance.printLog(message: "信息流拉取原生模板广告失败")
        let map : NSDictionary = ["onAdMethod":"onFail",
                                  "code":-1,
                                          "message":error!]
        self.channel?.invokeMethod("onFail", arguments: map)
    }
    
    /**
     * 原生模板广告渲染成功, 此时的 nativeExpressAdView.size.height 根据 size.width 完成了动态更新。
     */
    public func nativeExpressAdViewRenderSuccess(_ nativeExpressAdView: GDTNativeExpressAdView!) {
        LogUtil.logInstance.printLog(message: "信息流原生模板广告渲染成功, 此时的 nativeExpressAdView.size.height 根据 size.width 完成了动态更新。")
        self.channel?.invokeMethod("onShow", arguments: "")
    }
    
    /**
     * 点击原生模板广告以后弹出全屏广告页
     */
    public func nativeExpressAdViewDidPresentScreen(_ nativeExpressAdView: GDTNativeExpressAdView!) {
        LogUtil.logInstance.printLog(message: "信息流点击原生模板广告以后弹出全屏广告页")
    }
    
    /**
     * 全屏广告页将要关闭
     */
    public func nativeExpressAdViewDidDismissScreen(_ nativeExpressAdView: GDTNativeExpressAdView!) {
        LogUtil.logInstance.printLog(message: "信息流全屏广告页将要关闭")
    }
    
    /**
     * 点击原生模板广告以后即将弹出全屏广告页
     */
    public func nativeExpressAdViewWillPresentScreen(_ nativeExpressAdView: GDTNativeExpressAdView!) {
        LogUtil.logInstance.printLog(message: "信息流点击原生模板广告以后即将弹出全屏广告页")
    }
    
    
    /**
     * 全屏广告页将要关闭
     */
    public func nativeExpressAdViewWillDismissScreen(_ nativeExpressAdView: GDTNativeExpressAdView!) {
        LogUtil.logInstance.printLog(message: "信息流全屏广告页将要关闭")
    }
    
    /**
     * 详解:当点击应用下载或者广告调用系统程序打开时调用
     */
    public func nativeExpressAdViewApplicationWillEnterBackground(_ nativeExpressAdView: GDTNativeExpressAdView!) {
        LogUtil.logInstance.printLog(message: "信息流 详解:当点击应用下载或者广告调用系统程序打开时调用")
    }
    
    /**
     * 原生视频模板详情页 DidPresent 回调
     */
    public func nativeExpressAdViewDidPresentVideoVC(_ nativeExpressAdView: GDTNativeExpressAdView!) {
        LogUtil.logInstance.printLog(message: "信息流原生视频模板详情页 DidPresent 回调")
    }
    
    
    /**
     * 原生视频模板详情页 DidDismiss 回调
     */
    public func nativeExpressAdViewDidDismissVideoVC(_ nativeExpressAdView: GDTNativeExpressAdView!) {
        LogUtil.logInstance.printLog(message: "信息流原生视频模板详情页 DidDismiss 回调")
    }
    
    /**
     * 原生视频模板详情页 WillPresent 回调
     */
    public func nativeExpressAdViewWillPresentVideoVC(_ nativeExpressAdView: GDTNativeExpressAdView!) {
        LogUtil.logInstance.printLog(message: "信息流原生视频模板详情页 WillPresent 回调")
    }
    
    /**
     * 原生视频模板详情页 WillDismiss 回调
     */
    public func nativeExpressAdViewWillDismissVideoVC(_ nativeExpressAdView: GDTNativeExpressAdView!) {
        LogUtil.logInstance.printLog(message: "信息流原生视频模板详情页 WillDismiss 回调")
    }
    
    /**
     * 原生模板视频广告 player 播放状态更新回调
     */
    public func nativeExpressAdView(_ nativeExpressAdView: GDTNativeExpressAdView!, playerStatusChanged status: GDTMediaPlayerStatus) {
        LogUtil.logInstance.printLog(message: "信息流原生模板视频广告 player 播放状态更新回调")
    }
}
