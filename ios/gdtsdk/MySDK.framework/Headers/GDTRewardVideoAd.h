//
//  GDTRewardVideoAd.h
//  GDTMobSDK
//
//  Created by royqpwang on 2018/9/1.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GDTSDKDefines.h"
#import "GDTLoadAdParams.h"
#import "GDTServerSideVerificationOptions.h"

NS_ASSUME_NONNULL_BEGIN


@protocol GDTRewardedVideoAdDelegate;

@interface GDTRewardVideoAd : NSObject

@property (nonatomic, getter=isAdValid, readonly) BOOL adValid;
@property (nonatomic) BOOL videoMuted;
@property (nonatomic, assign, readonly) NSInteger expiredTimestamp;
@property (nonatomic, weak) id <GDTRewardedVideoAdDelegate> delegate;
@property (nonatomic, readonly) NSString *placementId;
@property (nonatomic, strong) GDTLoadAdParams *loadAdParams;
@property (nonatomic, strong) GDTServerSideVerificationOptions *serverSideVerificationOptions;

/**
 构造方法
 
 @param placementId - 广告位 ID
 @return GDTRewardVideoAd 实例
 */
- (instancetype)initWithPlacementId:(NSString *)placementId;

/**
 *  构造方法, S2S bidding 后获取到 token 再调用此方法
 *  @param placementId  广告位 ID
 *  @param token  通过 Server Bidding 请求回来的 token
 */
- (instancetype)initWithPlacementId:(NSString *)placementId token:(NSString *)token;

/**
 构造方法

 @param appId - 媒体 ID
 @param placementId - 广告位 ID
 @return GDTRewardVideoAd 实例
 */
- (instancetype)initWithAppId:(NSString *)appId placementId:(NSString *)placementId GDT_DEPRECATED_MSG_ATTRIBUTE("接口即将废弃，请使用 initWithPlacementId:");

/**
 *  S2S bidding 竟胜之后调用, 需要在调用广告 show 之前调用
 *  @param eCPM - 曝光扣费, 单位分，若优量汇竞胜，在广告曝光时回传，必传
 *  针对本次曝光的媒体期望扣费，常用扣费逻辑包括一价扣费与二价扣费，当采用一价扣费时，胜者出价即为本次扣费价格；当采用二价扣费时，第二名出价为本次扣费价格.
 */
- (void)setBidECPM:(NSInteger)eCPM;

/**
 加载广告方法 支持 iOS8.1 及以上系统
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
 *  当广告类型为 GDTRewardAdTypeVideo时，返回视频时长，单位 ms，当广告类型为GDTRewardAdTypePage时，返回0
 */
- (CGFloat)videoDuration;

/**
 *  激励广告的类型，需在gdt_rewardVideoAdDidLoad回调后调用
 */
- (GDTRewardAdType)rewardAdType;

@end


@protocol GDTRewardedVideoAdDelegate <NSObject>

@optional


/**
 广告数据加载成功回调

 @param rewardedVideoAd GDTRewardVideoAd 实例
 */
- (void)gdt_rewardVideoAdDidLoad:(GDTRewardVideoAd *)rewardedVideoAd;

/**
 视频数据下载成功回调，已经下载过的视频会直接回调

 @param rewardedVideoAd GDTRewardVideoAd 实例
 */
- (void)gdt_rewardVideoAdVideoDidLoad:(GDTRewardVideoAd *)rewardedVideoAd;

/**
 视频播放页即将展示回调

 @param rewardedVideoAd GDTRewardVideoAd 实例
 */
- (void)gdt_rewardVideoAdWillVisible:(GDTRewardVideoAd *)rewardedVideoAd;

/**
 视频广告曝光回调

 @param rewardedVideoAd GDTRewardVideoAd 实例
 */
- (void)gdt_rewardVideoAdDidExposed:(GDTRewardVideoAd *)rewardedVideoAd;

/**
 视频播放页关闭回调

 @param rewardedVideoAd GDTRewardVideoAd 实例
 */
- (void)gdt_rewardVideoAdDidClose:(GDTRewardVideoAd *)rewardedVideoAd;

/**
 视频广告信息点击回调

 @param rewardedVideoAd GDTRewardVideoAd 实例
 */
- (void)gdt_rewardVideoAdDidClicked:(GDTRewardVideoAd *)rewardedVideoAd;

/**
 视频广告各种错误信息回调

 @param rewardedVideoAd GDTRewardVideoAd 实例
 @param error 具体错误信息
 */
- (void)gdt_rewardVideoAd:(GDTRewardVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error;

/**
 视频广告播放达到激励条件回调

 @param rewardedVideoAd GDTRewardVideoAd 实例
 */
- (void)gdt_rewardVideoAdDidRewardEffective:(GDTRewardVideoAd *)rewardedVideoAd GDT_DEPRECATED_MSG_ATTRIBUTE("接口即将废弃，请使用 gdt_rewardVideoAdDidRewardEffective:info:");


/**
 视频广告播放达到激励条件回调

 @param rewardedVideoAd GDTRewardVideoAd 实例
 @param info 包含此次广告行为的一些信息，例如 @{@"GDT_TRANS_ID":@"930f1fc8ac59983bbdf4548ee40ac353"}, 通过@“GDT_TRANS_ID”可获取此次广告行为的交易id
 */
- (void)gdt_rewardVideoAdDidRewardEffective:(GDTRewardVideoAd *)rewardedVideoAd info:(NSDictionary *)info;

/**
 视频广告视频播放完成

 @param rewardedVideoAd GDTRewardVideoAd 实例
 */
- (void)gdt_rewardVideoAdDidPlayFinish:(GDTRewardVideoAd *)rewardedVideoAd;

@end

NS_ASSUME_NONNULL_END
