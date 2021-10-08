//
//  GDTNativeExpressProAdManager.h
//  GDTMobApp
//
//  Created by royqpwang on 2020/4/28.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDTAdParams.h"
#import "GDTSDKDefines.h"

NS_ASSUME_NONNULL_BEGIN

@class GDTNativeExpressProAdManager;
@class GDTNativeExpressProAdView;

@protocol GDTNativeExpressProAdManagerDelegate <NSObject>

@optional
/**
 * 拉取原生模板2.0广告成功
 */
- (void)gdt_nativeExpressProAdSuccessToLoad:(GDTNativeExpressProAdManager *)adManager views:(NSArray<__kindof GDTNativeExpressProAdView *> *)views;

/**
 * 拉取原生模板2.0广告失败
 */
- (void)gdt_nativeExpressProAdFailToLoad:(GDTNativeExpressProAdManager *)adManager error:(NSError *)error;

@end

GDT_DEPRECATED_MSG_ATTRIBUTE("GDTNativeExpressProAdManager类即将在12月废弃，请使用GDTNativeExpressAd类")
@interface GDTNativeExpressProAdManager : NSObject

/**
 *  委托对象
 */
@property (nonatomic, weak) id<GDTNativeExpressProAdManagerDelegate> delegate;

@property (nonatomic, readonly) NSString *placementId;

@property (nonatomic, strong, readonly) GDTAdParams *adParams;

/**
 *  构造方法
 *  详解：placementId - 广告位 ID
 *       adSize - 广告参数
 */
- (instancetype)initWithPlacementId:(NSString *)placementId adPrams:(GDTAdParams *)adParams;

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

@end

NS_ASSUME_NONNULL_END
