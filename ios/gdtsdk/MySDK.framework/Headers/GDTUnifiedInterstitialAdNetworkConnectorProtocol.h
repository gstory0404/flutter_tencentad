//
//  GDTUnifiedInterstitialAdNetworkConnectorProtocol.h
//  GDTMobApp
//
//  Created by royqpwang on 2019/8/10.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GDTUnifiedinterstitialAdNetworkAdapterProtocol;


@protocol GDTUnifiedInterstitialAdNetworkConnectorProtocol <NSObject>

/**
 *  插屏2.0广告预加载成功回调
 *  当接收服务器返回的广告数据成功且预加载后调用该函数
 */
- (void)adapter_unifiedInterstitialSuccessToLoadAd:(id<GDTUnifiedinterstitialAdNetworkAdapterProtocol>)adapter;

/**
 *  插屏2.0广告预加载失败回调
 *  当接收服务器返回的广告数据失败后调用该函数
 */
- (void)adapter_unifiedInterstitialFailToLoadAd:(id<GDTUnifiedinterstitialAdNetworkAdapterProtocol>)adapter error:(NSError *)error;

/**
 *  插屏2.0广告将要展示回调
 *  插屏2.0广告即将展示回调该函数
 */
- (void)adapter_unifiedInterstitialWillPresentScreen:(id<GDTUnifiedinterstitialAdNetworkAdapterProtocol>)adapter;

/**
 *  插屏2.0广告视图展示成功回调
 *  插屏2.0广告展示成功回调该函数
 */
- (void)adapter_unifiedInterstitialDidPresentScreen:(id<GDTUnifiedinterstitialAdNetworkAdapterProtocol>)adapter;


/**
 插屏2.0广告展示视图失败

 @param adapter adapter对象
 @param error 错误
 */
- (void)adapter_unifiedInterstitialFailToPresentAd:(id<GDTUnifiedinterstitialAdNetworkAdapterProtocol>)adapter error:(NSError *)error;

/**
 *  插屏2.0广告展示结束回调
 *  插屏2.0广告展示结束回调该函数
 */
- (void)adapter_unifiedInterstitialDidDismissScreen:(id<GDTUnifiedinterstitialAdNetworkAdapterProtocol>)adapter;

/**
 *  当点击下载应用时会调用系统程序打开其它App或者Appstore时回调
 */
- (void)adapter_unifiedInterstitialWillLeaveApplication:(id<GDTUnifiedinterstitialAdNetworkAdapterProtocol>)adapter;

/**
 *  插屏2.0广告曝光回调
 */
- (void)adapter_unifiedInterstitialWillExposure:(id<GDTUnifiedinterstitialAdNetworkAdapterProtocol>)adapter;

/**
 *  插屏2.0广告点击回调
 */
- (void)adapter_unifiedInterstitialClicked:(id<GDTUnifiedinterstitialAdNetworkAdapterProtocol>)adapter;

/**
 *  点击插屏2.0广告以后即将弹出全屏广告页
 */
- (void)adapter_unifiedInterstitialAdWillPresentFullScreenModal:(id<GDTUnifiedinterstitialAdNetworkAdapterProtocol>)adapter;

/**
 *  点击插屏2.0广告以后弹出全屏广告页
 */
- (void)adapter_unifiedInterstitialAdDidPresentFullScreenModal:(id<GDTUnifiedinterstitialAdNetworkAdapterProtocol>)adapter;

/**
 *  全屏广告页将要关闭
 */
- (void)adapter_unifiedInterstitialAdWillDismissFullScreenModal:(id<GDTUnifiedinterstitialAdNetworkAdapterProtocol>)adapter;

/**
 *  全屏广告页被关闭
 */
- (void)adapter_unifiedInterstitialAdDidDismissFullScreenModal:(id<GDTUnifiedinterstitialAdNetworkAdapterProtocol>)adapter;

/**
 * 插屏2.0视频广告 player 播放状态更新回调
 */
- (void)adapter_unifiedInterstitialAd:(id<GDTUnifiedinterstitialAdNetworkAdapterProtocol>)adapter playerStatusChanged:(GDTMediaPlayerStatus)status;

/**
 * 插屏2.0视频广告详情页 WillPresent 回调
 */
- (void)adapter_unifiedInterstitialAdViewWillPresentVideoVC:(id<GDTUnifiedinterstitialAdNetworkAdapterProtocol>)adapter;

/**
 * 插屏2.0视频广告详情页 DidPresent 回调
 */
- (void)adapter_unifiedInterstitialAdViewDidPresentVideoVC:(id<GDTUnifiedinterstitialAdNetworkAdapterProtocol>)adapter;

/**
 * 插屏2.0视频广告详情页 WillDismiss 回调
 */
- (void)adapter_unifiedInterstitialAdViewWillDismissVideoVC:(id<GDTUnifiedinterstitialAdNetworkAdapterProtocol>)adapter;

/**
 * 插屏2.0视频广告详情页 DidDismiss 回调
 */
- (void)adapter_unifiedInterstitialAdViewDidDismissVideoVC:(id<GDTUnifiedinterstitialAdNetworkAdapterProtocol>)adapter;

/**
 * 插屏激励回调
 */
- (void)adapter_unifiedInterstitialAdDidRewardEffective:(id <GDTUnifiedinterstitialAdNetworkAdapterProtocol>)adapter info:(NSDictionary *)info;

@end

