//
//  GDTNativeExpressRewardVideoAd.h
//  GDTMobApp
//
//  Created by royqpwang on 2020/7/6.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDTServerSideVerificationOptions.h"
#import "GDTSDKDefines.h"

NS_ASSUME_NONNULL_BEGIN

@protocol GDTNativeExpressRewardedVideoAdDelegate;

GDT_DEPRECATED_MSG_ATTRIBUTE("GDTNativeExpressRewardVideoAd类即将在12月废弃，请使用GDTRewardVideoAd类")
@interface GDTNativeExpressRewardVideoAd : NSObject

@property (nonatomic, getter=isAdValid, readonly) BOOL adValid;
@property (nonatomic) BOOL videoMuted;

@property (nonatomic, assign, readonly) NSInteger expiredTimestamp;
@property (nonatomic, weak) id <GDTNativeExpressRewardedVideoAdDelegate> delegate;

@property (nonatomic, readonly) NSString *placementId;
@property (nonatomic, strong) GDTServerSideVerificationOptions *serverSideVerificationOptions;

/**
 构造方法
 
 @param placementId - 广告位 ID
 @return GDTRewardVideoAd 实例
 */
- (instancetype)initWithPlacementId:(NSString *)placementId;

/**
 加载广告方法 支持 iOS9 及以上系统
 */
- (void)loadAd;
/**
 展示广告方法

 @param rootViewController 用于 present 激励视频 VC
 @return 是否展示成功
 */
- (BOOL)showAdFromRootViewController:(UIViewController *)rootViewController;

/**
 *  竟胜之后调用, 需要在调用广告 show 之前调用
 *  @param price - 竟胜价格 (单位: 分)
 */
- (void)sendWinNotificationWithPrice:(NSInteger)price;

/**
 *  竟败之后调用
 *  @param price - 竟胜价格 (单位: 分)
 *  @param reason - 优量汇广告竟败原因
 *  @param adnID - adnID
 */
- (void)sendLossNotificationWithWinnerPrice:(NSInteger)price lossReason:(GDTAdBiddingLossReason)reason winnerAdnID:(NSString *)adnID;

/**
 返回广告的eCPM，单位：分
 
 @return 成功返回一个大于等于0的值，-1表示无权限或后台出现异常
 */
- (NSInteger)eCPM;

/**
 返回广告的eCPM等级
 
 @return 成功返回一个包含数字的string，@""或nil表示无权限或后台异常
 */
- (NSString *)eCPMLevel;


/**
 返回广告平台名称

 @return 当使用激励视频聚合功能时，用于区分广告平台
 */
- (NSString *)adNetworkName;

/**
 * 激励视频广告时长，单位 ms
 */
- (CGFloat)videoDuration;

@end


@protocol GDTNativeExpressRewardedVideoAdDelegate <NSObject>

@optional


/**
 广告数据加载成功回调

 @param rewardedVideoAd GDTRewardVideoAd 实例
 */
- (void)gdt_nativeExpressRewardVideoAdDidLoad:(GDTNativeExpressRewardVideoAd *)rewardedVideoAd;

/**
 视频数据下载成功回调，已经下载过的视频会直接回调

 @param rewardedVideoAd GDTRewardVideoAd 实例
 */
- (void)gdt_nativeExpressRewardVideoAdVideoDidLoad:(GDTNativeExpressRewardVideoAd *)rewardedVideoAd;

/**
 视频播放页即将展示回调

 @param rewardedVideoAd GDTRewardVideoAd 实例
 */
- (void)gdt_nativeExpressRewardVideoAdWillVisible:(GDTNativeExpressRewardVideoAd *)rewardedVideoAd;

/**
 视频广告曝光回调

 @param rewardedVideoAd GDTRewardVideoAd 实例
 */
- (void)gdt_nativeExpressRewardVideoAdDidExposed:(GDTNativeExpressRewardVideoAd *)rewardedVideoAd;

/**
 视频播放页关闭回调

 @param rewardedVideoAd GDTRewardVideoAd 实例
 */
- (void)gdt_nativeExpressRewardVideoAdDidClose:(GDTNativeExpressRewardVideoAd *)rewardedVideoAd;

/**
 视频广告信息点击回调

 @param rewardedVideoAd GDTRewardVideoAd 实例
 */
- (void)gdt_nativeExpressRewardVideoAdDidClicked:(GDTNativeExpressRewardVideoAd *)rewardedVideoAd;

/**
 视频广告各种错误信息回调

 @param rewardedVideoAd GDTRewardVideoAd 实例
 @param error 具体错误信息
 */
- (void)gdt_nativeExpressRewardVideoAd:(GDTNativeExpressRewardVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error;

/**
 视频广告播放达到激励条件回调

 @param rewardedVideoAd GDTRewardVideoAd 实例
 */
- (void)gdt_nativeExpressRewardVideoAdDidRewardEffective:(GDTNativeExpressRewardVideoAd *)rewardedVideoAd GDT_DEPRECATED_MSG_ATTRIBUTE("接口即将废弃，请使用 gdt_nativeExpressRewardVideoAdDidRewardEffective:info:");;

/**
 视频广告播放达到激励条件回调

 @param rewardedVideoAd GDTRewardVideoAd 实例
 */
- (void)gdt_nativeExpressRewardVideoAdDidRewardEffective:(GDTNativeExpressRewardVideoAd *)rewardedVideoAd info:(NSDictionary *)info;

/**
 视频广告视频播放完成

 @param rewardedVideoAd GDTRewardVideoAd 实例
 */
- (void)gdt_nativeExpressRewardVideoAdDidPlayFinish:(GDTNativeExpressRewardVideoAd *)rewardedVideoAd;

@end

NS_ASSUME_NONNULL_END
