//
//  GDTExpressInterstitialAd.h
//  GDTMobApp
//
//  Created by nancynan on 2021/2/25.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDTSDKDefines.h"
#import "GDTServerSideVerificationOptions.h"

NS_ASSUME_NONNULL_BEGIN

@class GDTExpressInterstitialAd;

@protocol GDTExpressInterstitialAdDelegate <NSObject>
@optional

/**
 *  模板插屏广告预加载成功回调
 *  当接收服务器返回的广告数据成功且预加载后调用该函数
 */
- (void)expressInterstitialSuccessToLoadAd:(GDTExpressInterstitialAd *)expressInterstitial;

/**
 *  模板插屏广告预加载失败回调
 *  当接收服务器返回的广告数据失败后调用该函数
 */
- (void)expressInterstitialFailToLoadAd:(GDTExpressInterstitialAd *)expressInterstitial error:(NSError *)error;

/**
 *  模板插屏广告视频缓存完成
 */
- (void)expressInterstitialDidDownloadVideo:(GDTExpressInterstitialAd *)expressInterstitial;

/**
 *  模板插屏广告广告渲染成功
 *  建议在此回调后展示广告
 */
- (void)expressInterstitialRenderSuccess:(GDTExpressInterstitialAd *)expressInterstitial;

/**
 *  模板插屏广告广告渲染失败
 */
- (void)expressInterstitialRenderFail:(GDTExpressInterstitialAd *)expressInterstitial error:(NSError *)error;

/**
 *  模板插屏广告将要展示回调
 *  模板插屏广告即将展示回调该函数
 */
- (void)expressInterstitialWillPresentScreen:(GDTExpressInterstitialAd *)expressInterstitial;

/**
 *  模板插屏广告视图展示成功回调
 *  模板插屏广告展示成功回调该函数
 */
- (void)expressInterstitialDidPresentScreen:(GDTExpressInterstitialAd *)expressInterstitial;

/**
 *  模板插屏广告视图展示失败回调
 *  模板插屏广告展示失败回调该函数
 */
- (void)expressInterstitialFailToPresent:(GDTExpressInterstitialAd *)expressInterstitial error:(NSError *)error;

/**
 *  模板插屏广告展示结束回调
 *  模板插屏广告展示结束回调该函数
 */
- (void)expressInterstitialDidDismissScreen:(GDTExpressInterstitialAd *)expressInterstitial;

/**
 *  当点击下载应用时会调用系统程序打开其它App或者Appstore时回调
 */
- (void)expressInterstitialWillLeaveApplication:(GDTExpressInterstitialAd *)expressInterstitial;

/**
 *  模板插屏广告曝光回调
 */
- (void)expressInterstitialWillExposure:(GDTExpressInterstitialAd *)expressInterstitial;

/**
 *  模板插屏广告点击回调
 */
- (void)expressInterstitialClicked:(GDTExpressInterstitialAd *)expressInterstitial;

/**
 *  点击模板插屏广告以后即将弹出全屏广告页
 */
- (void)expressInterstitialAdWillPresentFullScreenModal:(GDTExpressInterstitialAd *)expressInterstitial;

/**
 *  点击模板插屏广告以后弹出全屏广告页
 */
- (void)expressInterstitialAdDidPresentFullScreenModal:(GDTExpressInterstitialAd *)expressInterstitial;

/**
 *  模板全屏广告页将要关闭
 */
- (void)expressInterstitialAdWillDismissFullScreenModal:(GDTExpressInterstitialAd *)expressInterstitial;

/**
 *  模板全屏广告页被关闭
 */
- (void)expressInterstitialAdDidDismissFullScreenModal:(GDTExpressInterstitialAd *)expressInterstitial;

/**
 * 模板插屏视频广告 player 播放状态更新回调
 */
- (void)expressInterstitialAd:(GDTExpressInterstitialAd *)expressInterstitial playerStatusChanged:(GDTMediaPlayerStatus)status;

/**
 * 模板插屏视频广告详情页 WillPresent 回调
 */
- (void)expressInterstitialAdViewWillPresentVideoVC:(GDTExpressInterstitialAd *)expressInterstitial;

/**
 * 模板插屏视频广告详情页 DidPresent 回调
 */
- (void)expressInterstitialAdViewDidPresentVideoVC:(GDTExpressInterstitialAd *)expressInterstitial;

/**
 * 模板插屏视频广告详情页 WillDismiss 回调
 */
- (void)expressInterstitialAdViewWillDismissVideoVC:(GDTExpressInterstitialAd *)expressInterstitial;

/**
 * 模板插屏视频广告详情页 DidDismiss 回调
 */
- (void)expressInterstitialAdViewDidDismissVideoVC:(GDTExpressInterstitialAd *)expressInterstitial;

/**
 * 插屏激励广告视频播放达到激励条件回调（只有插屏激励广告位才会有此回调）
 
 @param expressInterstitial GDTExpressInterstitialAd 实例
 @param info 包含此次广告行为的一些信息，例如 @{@"GDT_TRANS_ID":@"930f1fc8ac59983bbdf4548ee40ac353"}, 通过@“GDT_TRANS_ID”可获取此次广告行为的交易id
 */
- (void)expressInterstitialAdDidRewardEffective:(GDTExpressInterstitialAd *)expressInterstitial info:(NSDictionary *)info;

@end

GDT_DEPRECATED_MSG_ATTRIBUTE("GDTExpressInterstitialAd类即将在12月废弃，请使用GDTUnifiedInterstitialAd类")
@interface GDTExpressInterstitialAd : NSObject

/**
 *  模板插屏广告预加载是否完成
 */
@property (nonatomic, readonly) BOOL isAdValid;

/**
 *  委托对象
 */
@property (nonatomic, weak) id<GDTExpressInterstitialAdDelegate> delegate;

@property (nonatomic, readonly) NSString *placementId;
@property (nonatomic, strong) GDTServerSideVerificationOptions *serverSideVerificationOptions;

/**
 *  构造方法
 *  详解：placementId - 广告位 ID
 */
- (instancetype)initWithPlacementId:(NSString *)placementId;

#pragma mark - 半屏接口
/**
 *  广告发起请求方法
 *  详解：[必选]发起拉取广告请求
 */
- (void)loadHalfScreenAd;

/**
 *  广告展示方法
 *  详解：[必选]发起展示广告请求, 必须传入用于显示插播广告的UIViewController
 */

- (void)presentHalfScreenAdFromRootViewController:(UIViewController *)rootViewController;

#pragma mark - 全屏接口
/**
*  模板插屏全屏视频广告发起请求方法
*  详解：[必选]发起拉取广告请求
*/
- (void)loadFullScreenAd;

/**
*  模板插屏视频全屏广告展示方法
*  详解：[必选]发起展示广告请求, 必须传入用于显示插播广告的UIViewController
*/
- (void)presentFullScreenAdFromRootViewController:(UIViewController *)rootViewController;

#pragma mark -
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
 *  非 WiFi 网络，是否自动播放。默认 YES。loadAd 前设置。
 */

@property (nonatomic, assign) BOOL videoAutoPlayOnWWAN;

/**
 *  自动播放时，是否静音。默认 YES。loadAd 前设置。
 */
@property (nonatomic, assign) BOOL videoMuted;


/**
 *  视频详情页播放时是否静音。默认NO。loadAd 前设置。
 */
@property (nonatomic, assign) BOOL detailPageVideoMuted;

/**
 请求视频的时长下限。插屏激励广告位设置此属性不生效
 以下两种情况会使用 0，1:不设置  2:minVideoDuration大于maxVideoDuration
*/
@property (nonatomic) NSInteger minVideoDuration;

/**
 请求视频的时长上限，视频时长有效值范围为[5,180]。插屏激励广告位设置此属性不生效
 */
@property (nonatomic) NSInteger maxVideoDuration;

/**
 * 是否是视频插屏广告
 */
@property (nonatomic, assign, readonly) BOOL isVideoAd;

/**
 * 视频插屏广告时长，单位 ms
 */
- (CGFloat)videoDuration;

/**
 * 视频插屏广告已播放时长，单位 ms
 */
- (CGFloat)videoPlayTime;

/**
 返回广告平台名称
 
 @return 当使用流量分配功能时，用于区分广告平台；未使用时为空字符串
 */
- (NSString *)adNetworkName;

@end

NS_ASSUME_NONNULL_END
