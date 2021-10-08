//
//  GDTUnifiedInterstitialAd.h
//  GDTMobApp
//
//  Created by nimomeng on 2019/3/4.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDTSDKDefines.h"
#import "GDTServerSideVerificationOptions.h"

NS_ASSUME_NONNULL_BEGIN

@class GDTUnifiedInterstitialAd;

@protocol GDTUnifiedInterstitialAdDelegate <NSObject>
@optional

/**
 *  插屏2.0广告预加载成功回调
 *  当接收服务器返回的广告数据成功且预加载后调用该函数
 */
- (void)unifiedInterstitialSuccessToLoadAd:(GDTUnifiedInterstitialAd *)unifiedInterstitial;

/**
 *  插屏2.0广告预加载失败回调
 *  当接收服务器返回的广告数据失败后调用该函数
 */
- (void)unifiedInterstitialFailToLoadAd:(GDTUnifiedInterstitialAd *)unifiedInterstitial error:(NSError *)error;

/**
 *  插屏2.0广告视频缓存完成
 */
- (void)unifiedInterstitialDidDownloadVideo:(GDTUnifiedInterstitialAd *)unifiedInterstitial;

/**
 *  插屏2.0广告渲染成功
 *  建议在此回调后展示广告
 */
- (void)unifiedInterstitialRenderSuccess:(GDTUnifiedInterstitialAd *)unifiedInterstitial;

/**
 *  插屏2.0广告渲染失败
 */
- (void)unifiedInterstitialRenderFail:(GDTUnifiedInterstitialAd *)unifiedInterstitial error:(NSError *)error;

/**
 *  插屏2.0广告将要展示回调
 *  插屏2.0广告即将展示回调该函数
 */
- (void)unifiedInterstitialWillPresentScreen:(GDTUnifiedInterstitialAd *)unifiedInterstitial;

/**
 *  插屏2.0广告视图展示成功回调
 *  插屏2.0广告展示成功回调该函数
 */
- (void)unifiedInterstitialDidPresentScreen:(GDTUnifiedInterstitialAd *)unifiedInterstitial;

/**
 *  插屏2.0广告视图展示失败回调
 *  插屏2.0广告展示失败回调该函数
 */
- (void)unifiedInterstitialFailToPresent:(GDTUnifiedInterstitialAd *)unifiedInterstitial error:(NSError *)error;

/**
 *  插屏2.0广告展示结束回调
 *  插屏2.0广告展示结束回调该函数
 */
- (void)unifiedInterstitialDidDismissScreen:(GDTUnifiedInterstitialAd *)unifiedInterstitial;

/**
 *  当点击下载应用时会调用系统程序打开其它App或者Appstore时回调
 */
- (void)unifiedInterstitialWillLeaveApplication:(GDTUnifiedInterstitialAd *)unifiedInterstitial;

/**
 *  插屏2.0广告曝光回调
 */
- (void)unifiedInterstitialWillExposure:(GDTUnifiedInterstitialAd *)unifiedInterstitial;

/**
 *  插屏2.0广告点击回调
 */
- (void)unifiedInterstitialClicked:(GDTUnifiedInterstitialAd *)unifiedInterstitial;

/**
 *  点击插屏2.0广告以后即将弹出全屏广告页
 */
- (void)unifiedInterstitialAdWillPresentFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial;

/**
 *  点击插屏2.0广告以后弹出全屏广告页
 */
- (void)unifiedInterstitialAdDidPresentFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial;

/**
 *  全屏广告页将要关闭
 */
- (void)unifiedInterstitialAdWillDismissFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial;

/**
 *  全屏广告页被关闭
 */
- (void)unifiedInterstitialAdDidDismissFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial;

/**
 * 插屏2.0视频广告 player 播放状态更新回调
 */
- (void)unifiedInterstitialAd:(GDTUnifiedInterstitialAd *)unifiedInterstitial playerStatusChanged:(GDTMediaPlayerStatus)status;

/**
 * 插屏2.0视频广告详情页 WillPresent 回调
 */
- (void)unifiedInterstitialAdViewWillPresentVideoVC:(GDTUnifiedInterstitialAd *)unifiedInterstitial;

/**
 * 插屏2.0视频广告详情页 DidPresent 回调
 */
- (void)unifiedInterstitialAdViewDidPresentVideoVC:(GDTUnifiedInterstitialAd *)unifiedInterstitial;

/**
 * 插屏2.0视频广告详情页 WillDismiss 回调
 */
- (void)unifiedInterstitialAdViewWillDismissVideoVC:(GDTUnifiedInterstitialAd *)unifiedInterstitial;

/**
 * 插屏2.0视频广告详情页 DidDismiss 回调
 */
- (void)unifiedInterstitialAdViewDidDismissVideoVC:(GDTUnifiedInterstitialAd *)unifiedInterstitial;

/**
 * 插屏激励广告视频播放达到激励条件回调（只有插屏激励广告位才会有此回调）

 @param unifiedInterstitial GDTUnifiedInterstitialAd 实例
 @param info 包含此次广告行为的一些信息，例如 @{@"GDT_TRANS_ID":@"930f1fc8ac59983bbdf4548ee40ac353"}, 通过@“GDT_TRANS_ID”可获取此次广告行为的交易id
 */
- (void)unifiedInterstitialAdDidRewardEffective:(GDTUnifiedInterstitialAd *)unifiedInterstitial info:(NSDictionary *)info;

@end

@interface GDTUnifiedInterstitialAd : NSObject

/**
 *  插屏2.0广告预加载是否完成
 */
@property (nonatomic, readonly) BOOL isAdValid;

/**
 *  委托对象
 */
@property (nonatomic, weak) id<GDTUnifiedInterstitialAdDelegate> delegate;

@property (nonatomic, readonly) NSString *placementId;
@property (nonatomic, strong) GDTServerSideVerificationOptions *serverSideVerificationOptions;

/**
 *  构造方法
 *  详解：placementId - 广告位 ID
 */
- (instancetype)initWithPlacementId:(NSString *)placementId;

/**
 *  构造方法, S2S bidding 后获取到 token 再调用此方法
 *  @param placementId  广告位 ID
 *  @param token  通过 Server Bidding 请求回来的 token
 */
- (instancetype)initWithPlacementId:(NSString *)placementId token:(NSString *)token;

/**
 *  构造方法
 *  详解：appId - 媒体 ID
 *       placementId - 广告位 ID
 */
- (instancetype)initWithAppId:(NSString *)appId placementId:(NSString *)placementId GDT_DEPRECATED_MSG_ATTRIBUTE("接口即将废弃，请使用 initWithPlacementId:");

/**
 *  S2S bidding 竟胜之后调用, 需要在调用广告 show 之前调用
 *  @param eCPM - 曝光扣费, 单位分，若优量汇竞胜，在广告曝光时回传，必传
 *  针对本次曝光的媒体期望扣费，常用扣费逻辑包括一价扣费与二价扣费，当采用一价扣费时，胜者出价即为本次扣费价格；当采用二价扣费时，第二名出价为本次扣费价格.
 */
- (void)setBidECPM:(NSInteger)eCPM;

/**
 *  广告发起请求方法
 *  详解：[必选]发起拉取广告请求
 */
- (void)loadAd;

/**
*  插屏全屏视频广告发起请求方法
*  详解：[必选]发起拉取广告请求
*/
- (void)loadFullScreenAd;


/**
 *  广告展示方法
 *  详解：[必选]发起展示广告请求, 必须传入用于显示插播广告的UIViewController
 */

- (void)presentAdFromRootViewController:(UIViewController *)rootViewController;

/**
*  插屏视频全屏广告展示方法
*  详解：[必选]发起展示广告请求, 必须传入用于显示插播广告的UIViewController
*/
- (void)presentFullScreenAdFromRootViewController:(UIViewController *)rootViewController;

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
 请求视频的时长下限，插屏激励广告位设置此属性不生效
 以下两种情况会使用 0，1:不设置  2:minVideoDuration大于maxVideoDuration
*/
@property (nonatomic) NSInteger minVideoDuration;

/**
 请求视频的时长上限，视频时长有效值范围为[5,180]，插屏激励广告位设置此属性不生效
 */
@property (nonatomic) NSInteger maxVideoDuration;

/**
 * 是否是视频插屏2.0广告
 */
@property (nonatomic, assign, readonly) BOOL isVideoAd;

/**
 * 视频插屏2.0广告时长，单位 ms
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
