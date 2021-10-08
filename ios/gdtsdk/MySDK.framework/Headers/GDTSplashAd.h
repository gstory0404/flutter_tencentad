//
//  GDTSplashAd.h
//  GDTMobApp
//
//  广点通开屏广告，目前只支持iPhone设备上展示垂直方向的开屏广告
//  Created by GaoChao on 15/8/20.
//  Copyright © 2015年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GDTSDKDefines.h"
#import "GDTSplashZoomOutView.h"

@class GDTSplashAd;

@protocol GDTSplashAdDelegate <NSObject>

@optional
/**
 *  开屏广告成功展示
 */
- (void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd;

/**
 *  开屏广告素材加载成功
 */
- (void)splashAdDidLoad:(GDTSplashAd *)splashAd;

/**
 *  开屏广告展示失败
 */
- (void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error;

/**
 *  应用进入后台时回调
 *  详解: 当点击下载应用时会调用系统程序打开，应用切换到后台
 */
- (void)splashAdApplicationWillEnterBackground:(GDTSplashAd *)splashAd;

/**
 *  开屏广告曝光回调
 */
- (void)splashAdExposured:(GDTSplashAd *)splashAd;

/**
 *  开屏广告点击回调
 */
- (void)splashAdClicked:(GDTSplashAd *)splashAd;

/**
 *  开屏广告将要关闭回调
 */
- (void)splashAdWillClosed:(GDTSplashAd *)splashAd;

/**
 *  开屏广告关闭回调
 */
- (void)splashAdClosed:(GDTSplashAd *)splashAd;

/**
 *  开屏广告点击以后即将弹出全屏广告页
 */
- (void)splashAdWillPresentFullScreenModal:(GDTSplashAd *)splashAd;

/**
 *  开屏广告点击以后弹出全屏广告页
 */
- (void)splashAdDidPresentFullScreenModal:(GDTSplashAd *)splashAd;

/**
 *  点击以后全屏广告页将要关闭
 */
- (void)splashAdWillDismissFullScreenModal:(GDTSplashAd *)splashAd;

/**
 *  点击以后全屏广告页已经关闭
 */
- (void)splashAdDidDismissFullScreenModal:(GDTSplashAd *)splashAd;

/**
 * 开屏广告剩余时间回调
 */
- (void)splashAdLifeTime:(NSUInteger)time;

@end

@interface GDTSplashAd : NSObject

/**
 *  委托对象
 */
@property (nonatomic, weak) id<GDTSplashAdDelegate> delegate;

/**
 *  拉取广告超时时间，默认为3秒
 *  详解：拉取广告超时时间，开发者调用loadAd方法以后会立即展示backgroundImage，然后在该超时时间内，如果广告拉
 *  取成功，则立马展示开屏广告，否则放弃此次广告展示机会。
 */
@property (nonatomic, assign) CGFloat fetchDelay;

/**
 *  开屏广告的背景图片
 *  可以设置背景图片作为开屏加载时的默认背景
 */
@property (nonatomic, strong) UIImage *backgroundImage;

/**
 *  开屏广告的背景色
 *  可以设置开屏图片来作为开屏加载时的默认图片
 */
@property (nonatomic, copy) UIColor *backgroundColor;

/**
 * 跳过按钮的位置
 */
@property (nonatomic, assign) CGPoint skipButtonCenter;

/**
 * 是否需要开屏视频V+功能
 */
@property (nonatomic, assign) BOOL needZoomOut;

/**
 * 当广告命中开屏视频V+时，splshZoomOutView有值
 * splashZoomOutView推荐尺寸为9:16，最小尺寸推荐为126*224
 */
@property (nonatomic, strong, readonly) GDTSplashZoomOutView *splashZoomOutView;

/**
 返回广告平台名称
 
 @return 当使用流量分配功能时，用于区分广告平台；未使用时为空字符串
 */
- (NSString *)adNetworkName;

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
 *  S2S bidding 竟胜之后调用, 需要在调用广告 show 之前调用
 *  @param eCPM - 曝光扣费, 单位分，若优量汇竞胜，在广告曝光时回传，必传
 *  针对本次曝光的媒体期望扣费，常用扣费逻辑包括一价扣费与二价扣费，当采用一价扣费时，胜者出价即为本次扣费价格；当采用二价扣费时，第二名出价为本次扣费价格.
 */
- (void)setBidECPM:(NSInteger)eCPM;

/**
 预加载闪屏广告接口
 
 @param placementId 广告位ID
 */
- (void)preloadSplashOrderWithPlacementId:(NSString *)placementId;

#pragma mark - Parallel method

/**
 * 返回广告是否可展示
 * 对于并行请求，在调用showAdInWindow前时需判断下
 * @return 当广告已经加载完成且未曝光时，为YES，否则为NO
 */
- (BOOL)isAdValid;

/**
 *  发起拉取广告请求，只拉取不展示
 *  详解：广告素材及广告图片拉取成功后会回调splashAdDidLoad方法，当拉取失败时会回调splashAdFailToPresent方法
 */
- (void)loadAd;

/**
 *  展示广告，调用此方法前需调用isAdValid方法判断广告素材是否有效
 *  详解：广告展示成功时会回调splashAdSuccessPresentScreen方法，展示失败时会回调splashAdFailToPresent方法
 */
- (void)showAdInWindow:(UIWindow *)window withBottomView:(UIView *)bottomView skipView:(UIView *)skipView;

/**
 *  发起拉取全屏广告请求，只拉取不展示
 *  详解：广告素材及广告图片拉取成功后会回调splashAdDidLoad方法，当拉取失败时会回调splashAdFailToPresent方法
 */
- (void)loadFullScreenAd;

/**
 *  展示全屏广告，调用此方法前需调用isAdValid方法判断广告素材是否有效
 *  详解：广告展示成功时会回调splashAdSuccessPresentScreen方法，展示失败时会回调splashAdFailToPresent方法
 */
- (void)showFullScreenAdInWindow:(UIWindow *)window withLogoImage:(UIImage *)logoImage skipView:(UIView *)skipView;

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
 *  构造方法
 *  详解：appId - 媒体 ID
 *       placementId - 广告位 ID
 */
- (instancetype)initWithAppId:(NSString *)appId placementId:(NSString *)placementId  GDT_DEPRECATED_MSG_ATTRIBUTE("接口即将废弃，请使用 initWithPlacementId:");

/**
 *  广告发起请求并展示在Window中
 *  详解：[可选]发起拉取广告请求,并将获取的广告以全屏形式展示在传入的Window参数中
 *  提示: Splash广告只支持竖屏
 *  @param window 展示全屏开屏的容器
 */
- (void)loadAdAndShowInWindow:(UIWindow *)window  GDT_DEPRECATED_MSG_ATTRIBUTE("接口即将废弃，请分别使用loadAd 和 showAdInWindow:接口");

/**
 *  广告发起请求并展示在Window中, 同时在屏幕底部设置应用自身的Logo页面或是自定义View
 *  详解：[可选]发起拉取广告请求,并将获取的广告以半屏形式展示在传入的Window的上半部，剩余部分展示传入的bottomView
 *       请注意1.bottomView需设置好宽高，所占的空间不能过大，并保证高度不超过屏幕高度的 25%。2.Splash广告只支持竖屏
 *  @param window 展示开屏的容器
 *         bottomView 自定义底部View，可以在此View中设置应用Logo
 */
- (void)loadAdAndShowInWindow:(UIWindow *)window withBottomView:(UIView *)bottomView GDT_DEPRECATED_MSG_ATTRIBUTE("接口即将废弃，请分别使用loadAd 和 showAdInWindow:接口");

/**
 *  广告发起请求并展示在Window中, 同时在屏幕底部设置应用自身的Logo页面或是自定义View,skipView是自定义的“跳过”样式
 *  详解：[可选]发起拉取广告请求,并将获取的广告以半屏形式展示在传入的Window的上半部，剩余部分展示传入的bottomView
 *       请注意1.bottomView需设置好宽高，所占的空间不能过大，并保证高度不超过屏幕高度的 25%。2.Splash广告只支持竖屏
 *  skipView
 *  @param window 展示开屏的容器
 *         bottomView 自定义底部View，可以在此View中设置应用Logo
           skipView 自定义”跳过“View.
 */
- (void)loadAdAndShowInWindow:(UIWindow *)window withBottomView:(UIView *)bottomView skipView:(UIView *)skipView GDT_DEPRECATED_MSG_ATTRIBUTE("接口即将废弃，请分别使用loadAd 和 showAdInWindow:接口");

/**
 *  广告发起请求并展示在Window中, 同时在屏幕底部设置应用自身的Logo页面或是自定义View,skipView是自定义的“跳过”样式
 *  详解：[可选]发起拉取广告请求,并将获取的广告全屏展示, 可自定义 logo
 *  skipView
 *  @param window 展示开屏的容器
 *         logoImage 自定义logo 展示在屏幕左下角
           skipView 自定义”跳过“View.
 */
- (void)loadAdAndShowFullScreenInWindow:(UIWindow *)window withLogoImage:(UIImage *)logoImage skipView:(UIView *)skipView GDT_DEPRECATED_MSG_ATTRIBUTE("接口即将废弃，请分别使用loadFullScreenAd 和 showFullScreenAdInWindow:接口");

@end
