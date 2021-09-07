//
//  BannerAdView.swift
//  Pods
//
//  Created by gstory on 2021/9/1.
//

import Foundation
import Flutter
import MySDK


public class BannerAdView : NSObject,FlutterPlatformView,GDTUnifiedBannerViewDelegate{
    
    
    private var container : UIView
    var frame: CGRect
    private var channel : FlutterMethodChannel?
    private var bannerView:GDTUnifiedBannerView?
    
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
        self.channel = FlutterMethodChannel.init(name: FlutterTencentadConfig.view.bannerAdView + "_" + String(id), binaryMessenger: binaryMessenger)
        self.loadBannerAd()
    }
    
    public func view() -> UIView {
        return container
    }
    
    private func loadBannerAd(){
         self.removeAllView()
         LogUtil.logInstance.printLog(message: "开始初始化")
         if bannerView == nil {
            let rect = CGRect.init(x: 0, y: 0, width: Int(self.viewWidth!), height: Int(self.viewHeight!))
            self.bannerView = GDTUnifiedBannerView.init(frame: rect, placementId: self.codeId!, viewController: MyUtils.getVC())
            self.bannerView?.delegate = self
            self.bannerView?.autoSwitchInterval = 30;
        }
        self.container.addSubview(self.bannerView!)
        self.bannerView?.loadAdAndShow()
    }
    
    private func removeAllView(){
        self.container.removeFromSuperview()
    }
        
    private func disposeView() {
        self.removeAllView()
    }
    
    /**
     *  banner2.0广告点击以后弹出全屏广告页完毕
     */
    public func unifiedBannerViewDidPresentFullScreenModal(_ unifiedBannerView: GDTUnifiedBannerView) {
        LogUtil.logInstance.printLog(message: "banner广告点击以后弹出全屏广告页完毕")
    }
    
    /**
     *  banner2.0点击回调
     */
    public func unifiedBannerViewClicked(_ unifiedBannerView: GDTUnifiedBannerView) {
        LogUtil.logInstance.printLog(message: "banner点击回调")
        self.channel?.invokeMethod("onClick", arguments: "banner点击回调")
    }
    
    
    /**
     *  请求广告条数据成功后调用
     *  当接收服务器返回的广告数据成功后调用该函数
     */
    public func unifiedBannerViewDidLoad(_ unifiedBannerView: GDTUnifiedBannerView) {
        LogUtil.logInstance.printLog(message: "banner请求广告条数据成功后调用, 当接收服务器返回的广告数据成功后调用该函数")
        self.channel?.invokeMethod("onShow", arguments: "")
    }
    
    /**
     *  banner2.0被用户关闭时调用
     */
    public func unifiedBannerViewWillClose(_ unifiedBannerView: GDTUnifiedBannerView) {
        LogUtil.logInstance.printLog(message: "banner被用户关闭时调用")
        self.channel?.invokeMethod("onClose", arguments: "")
        self.disposeView()
    }
    
    /**
     *  banner2.0曝光回调
     */
    public func unifiedBannerViewWillExpose(_ unifiedBannerView: GDTUnifiedBannerView) {
        LogUtil.logInstance.printLog(message: "banner曝光回调")
        self.channel?.invokeMethod("onExpose", arguments: "")
    }
    
    /**
     *  当点击应用下载或者广告调用系统程序打开
     */
    public func unifiedBannerViewWillLeaveApplication(_ unifiedBannerView: GDTUnifiedBannerView) {
        LogUtil.logInstance.printLog(message: "banner当点击应用下载或者广告调用系统程序打开")
    }
    
    public func unifiedBannerViewFailed(toLoad unifiedBannerView: GDTUnifiedBannerView, error: Error) {
        LogUtil.logInstance.printLog(message: "banner加载失败")
        LogUtil.logInstance.printLog(message: error)
       
        let map : NSDictionary = ["onAdMethod":"onFail",
                                  "code":-1,
                                          "message":error]
        self.channel?.invokeMethod("onFail", arguments: map)
    }
    
    /**
     *   全屏广告页已经被关闭
     */
    public func unifiedBannerViewDidDismissFullScreenModal(_ unifiedBannerView: GDTUnifiedBannerView) {
        LogUtil.logInstance.printLog(message: "banner全屏广告页已经被关闭")
    
    }
    
    /**
     *  banner2.0广告点击以后即将弹出全屏广告页
     */
    public func unifiedBannerViewWillPresentFullScreenModal(_ unifiedBannerView: GDTUnifiedBannerView) {
        LogUtil.logInstance.printLog(message: "banner广告点击以后即将弹出全屏广告页")
    }
    
    /**
     *  全屏广告页即将被关闭
     */
    public func unifiedBannerViewWillDismissFullScreenModal(_ unifiedBannerView: GDTUnifiedBannerView) {
        LogUtil.logInstance.printLog(message: "banner全屏广告页即将被关闭")
    }
}
