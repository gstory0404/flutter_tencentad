//
//  GDTNativeExpressAd.h
//  GDTMobApp
//
//  Created by michaelxing on 2017/4/17.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GDTSDKDefines.h"

@class GDTNativeExpressAdView;
@class GDTNativeExpressAd;

@protocol GDTNativeExpressAdDelegete <NSObject>

@optional
/**
 * 拉取原生模板广告成功
 */
- (void)nativeExpressAdSuccessToLoad:(GDTNativeExpressAd *)nativeExpressAd views:(NSArray<__kindof GDTNativeExpressAdView *> *)views;

/**
 * 拉取原生模板广告失败
 */
- (void)nativeExpressAdFailToLoad:(GDTNativeExpressAd *)nativeExpressAd error:(NSError *)error;

/**
 * 原生模板广告渲染成功, 此时的 nativeExpressAdView.size.height 根据 size.width 完成了动态更新。
 */
- (void)nativeExpressAdViewRenderSuccess:(GDTNativeExpressAdView *)nativeExpressAdView;

/**
 * 原生模板广告渲染失败
 */
- (void)nativeExpressAdViewRenderFail:(GDTNativeExpressAdView *)nativeExpressAdView;

/**
 * 原生模板广告曝光回调
 */
- (void)nativeExpressAdViewExposure:(GDTNativeExpressAdView *)nativeExpressAdView;

/**
 * 原生模板广告点击回调
 */
- (void)nativeExpressAdViewClicked:(GDTNativeExpressAdView *)nativeExpressAdView;

/**
 * 原生模板广告被关闭
 */
- (void)nativeExpressAdViewClosed:(GDTNativeExpressAdView *)nativeExpressAdView;

/**
 * 点击原生模板广告以后即将弹出全屏广告页
 */
- (void)nativeExpressAdViewWillPresentScreen:(GDTNativeExpressAdView *)nativeExpressAdView;

/**
 * 点击原生模板广告以后弹出全屏广告页
 */
- (void)nativeExpressAdViewDidPresentScreen:(GDTNativeExpressAdView *)nativeExpressAdView;

/**
 * 全屏广告页将要关闭
 */
- (void)nativeExpressAdViewWillDismissScreen:(GDTNativeExpressAdView *)nativeExpressAdView;

/**
 * 全屏广告页将要关闭
 */
- (void)nativeExpressAdViewDidDismissScreen:(GDTNativeExpressAdView *)nativeExpressAdView;

/**
 * 详解:当点击应用下载或者广告调用系统程序打开时调用
 */
- (void)nativeExpressAdViewApplicationWillEnterBackground:(GDTNativeExpressAdView *)nativeExpressAdView;

/**
 * 原生模板视频广告 player 播放状态更新回调
 */
- (void)nativeExpressAdView:(GDTNativeExpressAdView *)nativeExpressAdView playerStatusChanged:(GDTMediaPlayerStatus)status;

/**
 * 原生视频模板详情页 WillPresent 回调
 */
- (void)nativeExpressAdViewWillPresentVideoVC:(GDTNativeExpressAdView *)nativeExpressAdView;

/**
 * 原生视频模板详情页 DidPresent 回调
 */
- (void)nativeExpressAdViewDidPresentVideoVC:(GDTNativeExpressAdView *)nativeExpressAdView;

/**
 * 原生视频模板详情页 WillDismiss 回调
 */
- (void)nativeExpressAdViewWillDismissVideoVC:(GDTNativeExpressAdView *)nativeExpressAdView;

/**
 * 原生视频模板详情页 DidDismiss 回调
 */
- (void)nativeExpressAdViewDidDismissVideoVC:(GDTNativeExpressAdView *)nativeExpressAdView;

@end

@interface GDTNativeExpressAd : NSObject

/**
 *  委托对象
 */
@property (nonatomic, weak) id<GDTNativeExpressAdDelegete> delegate;


/**
 *  非 WiFi 网络，是否自动播放。默认 NO。loadAd 前设置。
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
 请求视频的时长下限。
 以下两种情况会使用 0，1:不设置  2:minVideoDuration大于maxVideoDuration
*/
@property (nonatomic) NSInteger minVideoDuration;

/**
 请求视频的时长上限，视频时长有效值范围为[5,180]。
 */
@property (nonatomic) NSInteger maxVideoDuration;

@property (nonatomic, readonly) NSString *placementId;

/**
 *  构造方法
 *  详解：placementId - 广告位 ID
 *       adSize - 广告展示的宽高
 */

- (instancetype)initWithPlacementId:(NSString *)placementId adSize:(CGSize)size;

/**
 *  构造方法, S2S bidding 后获取到 token 再调用此方法
 *  @param placementId  广告位 ID
 *  @param token  通过 Server Bidding 请求回来的 token
 */
- (instancetype)initWithPlacementId:(NSString *)placementId token:(NSString *)token adSize:(CGSize)size;

/**
 *  构造方法
 *  详解：appId - 媒体 ID
 *       placementId - 广告位 ID
 *       adSize - 广告展示的宽高
 */
- (instancetype)initWithAppId:(NSString *)appId placementId:(NSString *)placementId adSize:(CGSize)size GDT_DEPRECATED_MSG_ATTRIBUTE("接口即将废弃，请使用 initWithPlacementId:adSize:");

/**
 *  S2S bidding 竟胜之后调用, 需要在调用广告 show 之前调用
 *  @param eCPM - 曝光扣费, 单位分，若优量汇竞胜，在广告曝光时回传，必传
 *  针对本次曝光的媒体期望扣费，常用扣费逻辑包括一价扣费与二价扣费，当采用一价扣费时，胜者出价即为本次扣费价格；当采用二价扣费时，第二名出价为本次扣费价格.
 */
- (void)setBidECPM:(NSInteger)eCPM;

/**
 *  拉取广告
 *  @param count 请求广告数量，区间为[1，3]，若大于3默认设置为3
 */
- (void)loadAd:(NSInteger)count;

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
 返回广告平台名称
 
 @return 当使用流量分配功能时，用于区分广告平台；未使用时为空字符串
 */
- (NSString *)adNetworkName;

@end
