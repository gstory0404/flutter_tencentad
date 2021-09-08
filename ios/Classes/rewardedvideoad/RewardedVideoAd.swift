//
//  RewardedVideoAd.swift
//  flutter_tencentad
//
//  Created by gstory on 2021/9/4.
//

import Foundation
import MySDK

public class RewardedVideoAd : NSObject,GDTRewardedVideoAdDelegate{
    public static let instance = RewardedVideoAd()

    var rewardVideoAd : GDTRewardVideoAd!

    //激励广告参数
    var mCodeId : String?
    var userID : String?
    var rewardName : String = ""
    var rewardAmount : Int = 0
    var customData : String = ""

    public func loadRewardedVideoAd(params : NSDictionary) {
        LogUtil.logInstance.printLog(message: params)
        self.mCodeId = params.value(forKey: "iosId") as? String
        self.userID = params.value(forKey: "userID") as? String
        self.rewardName = params.value(forKey: "rewardName") as? String ?? ""
        self.rewardAmount = params.value(forKey: "rewardAmount") as? Int ?? 0
        self.customData = params.value(forKey: "customData") as? String ?? ""
        self.rewardVideoAd = GDTRewardVideoAd.init(placementId: mCodeId!)
        self.rewardVideoAd.delegate = self
        self.rewardVideoAd.videoMuted = false
        let a = GDTServerSideVerificationOptions.init();
        a.userIdentifier = self.userID
        a.customRewardString = customData
        self.rewardVideoAd.load()
    }

    //显示激励广告
    public func showRewardedVideoAd(){
        if (self.rewardVideoAd.expiredTimestamp <= Int(Date.init().timeIntervalSince1970)) {
            let map : NSDictionary = ["adType":"rewardAd",
                                              "onAdMethod":"onFail",
                                              "code":-1,
                                              "message":"广告已过期，请重新拉取"]
            SwiftFlutterTencentadPlugin.event!.sendEvent(event: map)
            return
          }
          if (!self.rewardVideoAd.isAdValid) {
            let map : NSDictionary = ["adType":"rewardAd",
                                              "onAdMethod":"onFail",
                                              "code":-1,
                                              "message":"广告失效，请重新拉取"]
            SwiftFlutterTencentadPlugin.event!.sendEvent(event: map)
            return
          }
        self.rewardVideoAd.show(fromRootViewController: MyUtils.getVC())
    }

    public func gdt_rewardVideoAdDidLoad(_ rewardedVideoAd: GDTRewardVideoAd) {
        LogUtil.logInstance.printLog(message: "激励广告 广告数据加载成功")
        let map : NSDictionary = ["adType":"rewardAd",
                                          "onAdMethod":"onReady"]
        SwiftFlutterTencentadPlugin.event!.sendEvent(event: map)
    }

    public func gdt_rewardVideoAdDidClose(_ rewardedVideoAd: GDTRewardVideoAd) {
        LogUtil.logInstance.printLog(message: "激励广告关闭")
        let map : NSDictionary = ["adType":"rewardAd",
                                          "onAdMethod":"onClose"]
        SwiftFlutterTencentadPlugin.event!.sendEvent(event: map)
    }

    public func gdt_rewardVideoAdDidExposed(_ rewardedVideoAd: GDTRewardVideoAd) {
        LogUtil.logInstance.printLog(message: "激励广告曝光")
        let map : NSDictionary = ["adType":"rewardAd",
                                          "onAdMethod":"onExpose"]
        SwiftFlutterTencentadPlugin.event!.sendEvent(event: map)
    }

    public func gdt_rewardVideoAdDidClicked(_ rewardedVideoAd: GDTRewardVideoAd) {
        LogUtil.logInstance.printLog(message: "激励广告点击")
        let map : NSDictionary = ["adType":"rewardAd",
                                          "onAdMethod":"onClick"]
        SwiftFlutterTencentadPlugin.event!.sendEvent(event: map)
    }

    public func gdt_rewardVideoAdWillVisible(_ rewardedVideoAd: GDTRewardVideoAd) {
        LogUtil.logInstance.printLog(message: "激励广告视频播放页即将展示回调")
    }

    public func gdt_rewardVideoAdVideoDidLoad(_ rewardedVideoAd: GDTRewardVideoAd) {
        LogUtil.logInstance.printLog(message: "激励广告视频数据下载成功")
    }

    public func gdt_rewardVideoAdDidPlayFinish(_ rewardedVideoAd: GDTRewardVideoAd) {
        LogUtil.logInstance.printLog(message: "激励广告视频广告视频播放完成")
        let map : NSDictionary = ["adType":"rewardAd",
                                          "onAdMethod":"onFinish"]
        SwiftFlutterTencentadPlugin.event!.sendEvent(event: map)
    }

    public func gdt_rewardVideoAd(_ rewardedVideoAd: GDTRewardVideoAd, didFailWithError error: Error) {
        LogUtil.logInstance.printLog(message: "激励广告错误")
        LogUtil.logInstance.printLog(message: error)
        let map : NSDictionary = ["adType":"rewardAd",
                                          "onAdMethod":"onFail",
                                          "code":-1,
                                          "message":error.localizedDescription]
        SwiftFlutterTencentadPlugin.event!.sendEvent(event: map)
    }

    public func gdt_rewardVideoAdDidRewardEffective(_ rewardedVideoAd: GDTRewardVideoAd, info: [AnyHashable : Any]) {
        LogUtil.logInstance.printLog(message: "激励广告视频广告播放达到激励条件")
        LogUtil.logInstance.printLog(message: info)
        let map : NSDictionary = ["adType":"rewardAd",
                                          "onAdMethod":"onVerify",
                                          "transId":info["GDT_TRANS_ID"],
                                          "rewardAmount":self.rewardAmount,
                                          "rewardName":self.rewardName]
        SwiftFlutterTencentadPlugin.event!.sendEvent(event: map)
    }
}
