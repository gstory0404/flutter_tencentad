//
//  GDTSplashAdNetworkConnectorProtocol.h
//  GDTMobApp
//
//  Created by royqpwang on 2019/7/27.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol GDTSplashAdNetworkAdapterProtocol;

NS_ASSUME_NONNULL_BEGIN

@protocol GDTSplashAdNetworkConnectorProtocol <NSObject>

@optional
/**
 *  开屏广告成功展示
 */
- (void)adapter_splashAdSuccessPresentScreen:(id <GDTSplashAdNetworkAdapterProtocol>)adapter;

/**
 *  开屏广告素材加载成功
 */
- (void)adapter_splashAdDidLoad:(id <GDTSplashAdNetworkAdapterProtocol>)adapter;

/**
 *  开屏广告展示失败
 */
- (void)adapter_splashAdFailToPresent:(id <GDTSplashAdNetworkAdapterProtocol>)adapter withError:(NSError *)error;

/**
 *  应用进入后台时回调
 *  详解: 当点击下载应用时会调用系统程序打开，应用切换到后台
 */
- (void)adapter_splashAdApplicationWillEnterBackground:(id <GDTSplashAdNetworkAdapterProtocol>)adapter;

/**
 *  开屏广告曝光回调
 */
- (void)adapter_splashAdExposured:(id <GDTSplashAdNetworkAdapterProtocol>)adapter;

/**
 *  开屏广告点击回调
 */
- (void)adapter_splashAdClicked:(id <GDTSplashAdNetworkAdapterProtocol>)adapter;

/**
 *  开屏广告将要关闭回调
 */
- (void)adapter_splashAdWillClosed:(id <GDTSplashAdNetworkAdapterProtocol>)adapter;

/**
 *  开屏广告关闭回调
 */
- (void)adapter_splashAdClosed:(id <GDTSplashAdNetworkAdapterProtocol>)adapter;

/**
 *  开屏广告点击以后即将弹出全屏广告页
 */
- (void)adapter_splashAdWillPresentFullScreenModal:(id <GDTSplashAdNetworkAdapterProtocol>)adapter;

/**
 *  开屏广告点击以后弹出全屏广告页
 */
- (void)adapter_splashAdDidPresentFullScreenModal:(id <GDTSplashAdNetworkAdapterProtocol>)adapter;

/**
 *  点击以后全屏广告页将要关闭
 */
- (void)adapter_splashAdWillDismissFullScreenModal:(id <GDTSplashAdNetworkAdapterProtocol>)adapter;

/**
 *  点击以后全屏广告页已经关闭
 */
- (void)adapter_splashAdDidDismissFullScreenModal:(id <GDTSplashAdNetworkAdapterProtocol>)adapter;

/**
 * 开屏广告剩余时间回调
 */
- (void)adapter_splashAd:(id <GDTSplashAdNetworkAdapterProtocol>)adapter lifeTime:(NSUInteger)time;

@end

NS_ASSUME_NONNULL_END
