//
//  GDTUnifiedBannerView.h
//  GDTMobSDK
//
//  Created by nimomeng on 2019/3/1.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDTLoadAdParams.h"

NS_ASSUME_NONNULL_BEGIN

@class GDTUnifiedBannerView;

@protocol GDTUnifiedBannerViewDelegate <NSObject>
@optional
/**
 *  请求广告条数据成功后调用
 *  当接收服务器返回的广告数据成功后调用该函数
 */
- (void)unifiedBannerViewDidLoad:(GDTUnifiedBannerView *)unifiedBannerView;

/**
 *  请求广告条数据失败后调用
 *  当接收服务器返回的广告数据失败后调用该函数
 */
- (void)unifiedBannerViewFailedToLoad:(GDTUnifiedBannerView *)unifiedBannerView error:(NSError *)error;

/**
 *  banner2.0曝光回调
 */
- (void)unifiedBannerViewWillExpose:(GDTUnifiedBannerView *)unifiedBannerView;

/**
 *  banner2.0点击回调
 */
- (void)unifiedBannerViewClicked:(GDTUnifiedBannerView *)unifiedBannerView;

/**
 *  banner2.0广告点击以后即将弹出全屏广告页
 */
- (void)unifiedBannerViewWillPresentFullScreenModal:(GDTUnifiedBannerView *)unifiedBannerView;

/**
 *  banner2.0广告点击以后弹出全屏广告页完毕
 */
- (void)unifiedBannerViewDidPresentFullScreenModal:(GDTUnifiedBannerView *)unifiedBannerView;

/**
 *  全屏广告页即将被关闭
 */
- (void)unifiedBannerViewWillDismissFullScreenModal:(GDTUnifiedBannerView *)unifiedBannerView;

/**
 *  全屏广告页已经被关闭
 */
- (void)unifiedBannerViewDidDismissFullScreenModal:(GDTUnifiedBannerView *)unifiedBannerView;

/**
 *  当点击应用下载或者广告调用系统程序打开
 */
- (void)unifiedBannerViewWillLeaveApplication:(GDTUnifiedBannerView *)unifiedBannerView;

/**
 *  banner2.0被用户关闭时调用
 *  会立即关闭当前banner广告，若启用轮播，（刷新间隔 - 当前广告已展示时间）后会展示新的广告
 *  若未启用轮播或不需要再展示，需在回调中将unifiedBannerView从父view移除置nil
 */
- (void)unifiedBannerViewWillClose:(GDTUnifiedBannerView *)unifiedBannerView;

@end

@interface GDTUnifiedBannerView : UIView
/**
 *  委托 [可选]
 */
@property (nonatomic, weak) id<GDTUnifiedBannerViewDelegate> delegate;

/**
 *  Banner展现和轮播时的动画效果开关，默认打开
 */
@property (nonatomic) BOOL animated;

/**
 *  广告刷新间隔，范围 [30, 120] 秒，默认值 30 秒。设 0 则不刷新。 [可选]
 */
@property (nonatomic) int autoSwitchInterval;

/**
 *  QQ小游戏SDK字段透传
*/
@property (nonatomic, strong) GDTLoadAdParams *loadAdParams;

/**
 *  构造方法
 *  详解：placementId - 广告位 ID
 *       viewController - 视图控制器
 */
- (instancetype)initWithPlacementId:(NSString *)placementId
                     viewController:(UIViewController *)viewController;

/**
 *  构造方法
 *  详解：frame - banner 展示的位置和大小
 *       placementId - 广告位 ID
 *       viewController - 视图控制器
 */
- (instancetype)initWithFrame:(CGRect)frame
                  placementId:(NSString *)placementId
               viewController:(UIViewController *)viewController;

/**
 *  构造方法, S2S bidding 后获取到 token 再调用此方法
 *  @param placementId  广告位 ID
 *  @param token  通过 Server Bidding 请求回来的 token
 *  @param viewController 视图控制器
 */
- (instancetype)initWithPlacementId:(NSString *)placementId
                              token:(NSString *)token
                     viewController:(UIViewController *)viewController;

/**
 *  S2S bidding 竟胜之后调用, 需要在调用广告 show 之前调用
 *  @param eCPM - 曝光扣费, 单位分，若优量汇竞胜，在广告曝光时回传，必传
 *  针对本次曝光的媒体期望扣费，常用扣费逻辑包括一价扣费与二价扣费，当采用一价扣费时，胜者出价即为本次扣费价格；当采用二价扣费时，第二名出价为本次扣费价格.
 */
- (void)setBidECPM:(NSInteger)eCPM;

/**
 *  拉取并展示广告
 */
- (void)loadAdAndShow;

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

@end

NS_ASSUME_NONNULL_END
