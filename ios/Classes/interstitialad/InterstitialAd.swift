//
//  InterstitialAd.swift
//  flutter_tencentad
//
//  Created by gstory on 2021/9/1.
//

import Foundation

public class InterstitialAd : NSObject,GDTUnifiedInterstitialAdDelegate{
    
    public static let instance = InterstitialAd()
    
    //  插屏广告参数
    var mCodeId : String?
    var isFullScreen : Bool?
    
    private var interstitialAd : GDTUnifiedInterstitialAd?
    
    //预加载
    public func loadInterstitialAd(params : NSDictionary) {
        LogUtil.logInstance.printLog(message: params)
        mCodeId = params.value(forKey: "iosId") as? String
        isFullScreen = params.value(forKey: "isFullScreen") as? Bool
        self.interstitialAd = GDTUnifiedInterstitialAd.init(placementId: self.mCodeId!)
        self.interstitialAd?.delegate = self
        self.interstitialAd?.videoMuted = true
        if(self.isFullScreen!){
            self.interstitialAd?.loadFullScreenAd()
        }else{
            self.interstitialAd?.load()
        }
    }
    
    //展示
    public func showInterstitialAd(){
        if(self.isFullScreen!){
            self.interstitialAd?.presentFullScreenAd(fromRootViewController: MyUtils.getVC())
        }else{
            self.interstitialAd?.present(fromRootViewController: MyUtils.getVC())
        }
        
    }
    
    
   
    /**
     *  插屏2.0广告点击回调
     */
    public func unifiedInterstitialClicked(_ unifiedInterstitial: GDTUnifiedInterstitialAd) {
        LogUtil.logInstance.printLog(message: "插屏广告点击")
        let map : NSDictionary = ["adType":"interactAd",
                                          "onAdMethod":"onClick"]
        SwiftFlutterTencentadPlugin.event!.sendEvent(event: map)
    }
    
    /**
     *  插屏2.0广告预加载成功回调
     *  当接收服务器返回的广告数据成功且预加载后调用该函数
     */
    public func unifiedInterstitialSuccess(toLoad unifiedInterstitial: GDTUnifiedInterstitialAd) {
        LogUtil.logInstance.printLog(message: "插屏广告预加载成功")
    }
    
    
    /**
     *  插屏2.0广告曝光回调
     */
    public func unifiedInterstitialWillExposure(_ unifiedInterstitial: GDTUnifiedInterstitialAd) {
        LogUtil.logInstance.printLog(message: "插屏广告曝光")
        let map : NSDictionary = ["adType":"interactAd",
                                          "onAdMethod":"onExpose"]
        SwiftFlutterTencentadPlugin.event!.sendEvent(event: map)
    }
    
    /**
     *  插屏2.0广告渲染成功
     *  建议在此回调后展示广告
     */
    public func unifiedInterstitialRenderSuccess(_ unifiedInterstitial: GDTUnifiedInterstitialAd) {
        LogUtil.logInstance.printLog(message: "插屏广告渲染成功")
        let map : NSDictionary = ["adType":"interactAd",
                                          "onAdMethod":"onReady"]
        SwiftFlutterTencentadPlugin.event!.sendEvent(event: map)
    }
    
    
    /**
     *  插屏2.0广告预加载失败回调
     *  当接收服务器返回的广告数据失败后调用该函数
     */
    public func unifiedInterstitialFail(toLoad unifiedInterstitial: GDTUnifiedInterstitialAd, error: Error) {
        LogUtil.logInstance.printLog(message: "插屏广告预加载失败")
        LogUtil.logInstance.printLog(message: error)
        let map : NSDictionary = ["adType":"interactAd",
                                          "onAdMethod":"onFail",
                                          "code":-1,
                                          "message":error.localizedDescription]
        SwiftFlutterTencentadPlugin.event!.sendEvent(event: map)
    }
    
    /**
     *  插屏2.0广告视频缓存完成
     */
    public func unifiedInterstitialDidDownloadVideo(_ unifiedInterstitial: GDTUnifiedInterstitialAd) {
        LogUtil.logInstance.printLog(message: "插屏广告视频缓存完成")
    }
    
    /**
     *  插屏2.0广告视图展示成功回调
     *  插屏2.0广告展示成功回调该函数
     */
    public func unifiedInterstitialDidPresentScreen(_ unifiedInterstitial: GDTUnifiedInterstitialAd) {
        LogUtil.logInstance.printLog(message: "插屏广告展示成功")
        let map : NSDictionary = ["adType":"interactAd",
                                          "onAdMethod":"onShow"]
        SwiftFlutterTencentadPlugin.event!.sendEvent(event: map)
    }
    
    /**
     *  插屏2.0广告展示结束回调
     *  插屏2.0广告展示结束回调该函数
     */
    public func unifiedInterstitialDidDismissScreen(_ unifiedInterstitial: GDTUnifiedInterstitialAd) {
        LogUtil.logInstance.printLog(message: "插屏广告展示结束")
        let map : NSDictionary = ["adType":"interactAd",
                                          "onAdMethod":"onClose"]
        SwiftFlutterTencentadPlugin.event!.sendEvent(event: map)
    }
    
    /**
     *  插屏2.0广告将要展示回调
     *  插屏2.0广告即将展示回调该函数
     */
    public func unifiedInterstitialWillPresentScreen(_ unifiedInterstitial: GDTUnifiedInterstitialAd) {
        LogUtil.logInstance.printLog(message: "插屏广告将要展示")
    }
    
    /**
     *  当点击下载应用时会调用系统程序打开其它App或者Appstore时回调
     */
    public func unifiedInterstitialWillLeaveApplication(_ unifiedInterstitial: GDTUnifiedInterstitialAd) {
        LogUtil.logInstance.printLog(message: "插屏广告点击下载应用")
    }
    
    /**
     *  插屏2.0广告视图展示失败回调
     *  插屏2.0广告展示失败回调该函数
     */
    public func unifiedInterstitialFail(toPresent unifiedInterstitial: GDTUnifiedInterstitialAd, error: Error) {
        LogUtil.logInstance.printLog(message: "插屏广告展示失败")
        LogUtil.logInstance.printLog(message: error)
        let map : NSDictionary = ["adType":"interactAd",
                                          "onAdMethod":"onFail",
                                          "code":-1,
                                          "message":error.localizedDescription]
        SwiftFlutterTencentadPlugin.event!.sendEvent(event: map)
    }
    
    /**
     *  插屏2.0广告渲染失败
     */
    public func unifiedInterstitialRenderFail(_ unifiedInterstitial: GDTUnifiedInterstitialAd, error: Error) {
        LogUtil.logInstance.printLog(message: "插屏广告渲染失败")
        LogUtil.logInstance.printLog(message: error)
        let map : NSDictionary = ["adType":"interactAd",
                                          "onAdMethod":"onFail",
                                          "code":-1,
                                          "message":error.localizedDescription]
        SwiftFlutterTencentadPlugin.event!.sendEvent(event: map)
    }
    
    /**
     *  点击插屏2.0广告以后弹出全屏广告页
     */
    public func unifiedInterstitialAdDidPresentFullScreenModal(_ unifiedInterstitial: GDTUnifiedInterstitialAd) {
        LogUtil.logInstance.printLog(message: "插屏广告弹出全屏广告页")
    }
    
    /**
     *  全屏广告页被关闭
     */
    public func unifiedInterstitialAdDidDismissFullScreenModal(_ unifiedInterstitial: GDTUnifiedInterstitialAd) {
        LogUtil.logInstance.printLog(message: "插屏广告全屏广告页被关闭")
    }
    
    /**
     *  点击插屏2.0广告以后即将弹出全屏广告页
     */
    public func unifiedInterstitialAdWillPresentFullScreenModal(_ unifiedInterstitial: GDTUnifiedInterstitialAd) {
        LogUtil.logInstance.printLog(message: "插屏广告即将弹出全屏广告页")
    }
    
    /**
     *  全屏广告页将要关闭
     */
    public func unifiedInterstitialAdWillDismissFullScreenModal(_ unifiedInterstitial: GDTUnifiedInterstitialAd) {
        LogUtil.logInstance.printLog(message: "插屏广告全屏广告页将要关闭")
    }
    
    /**
     * 插屏2.0视频广告详情页 DidPresent 回调
     */
    public func unifiedInterstitialAdViewDidPresentVideoVC(_ unifiedInterstitial: GDTUnifiedInterstitialAd) {
        LogUtil.logInstance.printLog(message: "插屏广告视频广告详情页 DidPresent 回调")
    }
    
    /**
     * 插屏2.0视频广告详情页 DidDismiss 回调
     */
    public func unifiedInterstitialAdViewDidDismissVideoVC(_ unifiedInterstitial: GDTUnifiedInterstitialAd) {
        LogUtil.logInstance.printLog(message: "插屏广告视频广告详情页 DidDismiss 回调")
    }
    
    /**
     * 插屏2.0视频广告详情页 WillPresent 回调
     */
    public func unifiedInterstitialAdViewWillPresentVideoVC(_ unifiedInterstitial: GDTUnifiedInterstitialAd) {
        LogUtil.logInstance.printLog(message: "插屏广告视频广告详情页 WillPresent 回调")
    }
    
    /**
     * 插屏2.0视频广告详情页 WillDismiss 回调
     */
    public func unifiedInterstitialAdViewWillDismissVideoVC(_ unifiedInterstitial: GDTUnifiedInterstitialAd) {
        LogUtil.logInstance.printLog(message: "插屏广告视频广告详情页 WillDismiss 回调")
    }
    
    /**
     * 插屏激励广告视频播放达到激励条件回调（只有插屏激励广告位才会有此回调）

     @param unifiedInterstitial GDTUnifiedInterstitialAd 实例
     @param info 包含此次广告行为的一些信息，例如 @{@"GDT_TRANS_ID":@"930f1fc8ac59983bbdf4548ee40ac353"}, 通过@“GDT_TRANS_ID”可获取此次广告行为的交易id
     */
    public func unifiedInterstitialAdDidRewardEffective(_ unifiedInterstitial: GDTUnifiedInterstitialAd, info: [AnyHashable : Any]) {
        LogUtil.logInstance.printLog(message: "插屏广告插屏激励广告视频播放达到激励条件回调（")
    }
        
    /**
     * 插屏2.0视频广告 player 播放状态更新回调
     */
    public func unifiedInterstitialAd(_ unifiedInterstitial: GDTUnifiedInterstitialAd, playerStatusChanged status: GDTMediaPlayerStatus) {
        LogUtil.logInstance.printLog(message: "插屏广告视频广告 player 播放状态更新")
    }
    
}
