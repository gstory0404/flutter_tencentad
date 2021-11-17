//
//  GDTNativeExpressAdNetworkConnectorProtocol.h
//  GDTMobApp
//
//  Created by royqpwang on 2019/11/27.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDTSDKDefines.h"

@protocol GDTNativeExpressAdNetworkAdapterProtocol;
@protocol GDTNativeExpressAdViewAdapterProtocol;

@protocol GDTNativeExpressAdNetworkConnectorProtocol <NSObject>

/**
 * 拉取原生模板广告成功
 */
- (void)adapter_nativeExpressAdSuccessToLoad:(id<GDTNativeExpressAdNetworkAdapterProtocol>)adapter
                                viewAdapters:(NSArray<id<GDTNativeExpressAdViewAdapterProtocol>> *)
                                                 viewAdapters;

/**
 * 拉取原生模板广告失败
 */
- (void)adapter_nativeExpressAdFailToLoad:(id<GDTNativeExpressAdNetworkAdapterProtocol>)adapter
                                    error:(NSError *)error;

/**
 * 原生模板广告渲染成功, 此时的 nativeExpressAdView.size.height 根据 size.width 完成了动态更新。
 */
- (void)adapter_nativeExpressAdViewAdapterRenderSuccess:
    (id<GDTNativeExpressAdViewAdapterProtocol>)viewAdapter;

/**
 * 原生模板广告渲染失败
 */
- (void)adapter_nativeExpressAdViewAdapterRenderFail:
    (id<GDTNativeExpressAdViewAdapterProtocol>)viewAdapter;

/**
 * 原生模板广告曝光回调
 */
- (void)adapter_nativeExpressAdViewAdapterExposure:(id<GDTNativeExpressAdViewAdapterProtocol>)viewAdapter;

/**
 * 原生模板广告点击回调
 */
- (void)adapter_nativeExpressAdViewAdapterClicked:(id<GDTNativeExpressAdViewAdapterProtocol>)viewAdapter;

/**
 * 原生模板广告被关闭
 */
- (void)adapter_nativeExpressAdViewAdapterClosed:(id<GDTNativeExpressAdViewAdapterProtocol>)viewAdapter;

/**
 * 点击原生模板广告以后即将弹出全屏广告页
 */
- (void)adapter_nativeExpressAdViewAdapterWillPresentScreen:
    (id<GDTNativeExpressAdViewAdapterProtocol>)viewAdapter;

/**
 * 点击原生模板广告以后弹出全屏广告页
 */
- (void)adapter_nativeExpressAdViewAdapterDidPresentScreen:
    (id<GDTNativeExpressAdViewAdapterProtocol>)viewAdapter;

/**
 * 全屏广告页将要关闭
 */
- (void)adapter_nativeExpressAdViewAdapterWillDissmissScreen:
    (id<GDTNativeExpressAdViewAdapterProtocol>)viewAdapter;

/**
 * 全屏广告页将要关闭
 */
- (void)adapter_nativeExpressAdViewAdapterDidDissmissScreen:
    (id<GDTNativeExpressAdViewAdapterProtocol>)viewAdapter;

/**
 * 详解:当点击应用下载或者广告调用系统程序打开时调用
 */
- (void)adapter_nativeExpressAdViewAdapterApplicationWillEnterBackground:
    (id<GDTNativeExpressAdViewAdapterProtocol>)viewAdapter;

/**
 * 原生模板视频广告 player 播放状态更新回调
 */
- (void)adapter_nativeExpressAdViewAdapter:(id<GDTNativeExpressAdViewAdapterProtocol>)viewAdapter
                playerStatusChanged:(GDTMediaPlayerStatus)status;

/**
 * 原生视频模板详情页 WillPresent 回调
 */
- (void)adapter_nativeExpressAdViewAdapterWillPresentVideoViewController:
    (id<GDTNativeExpressAdViewAdapterProtocol>)viewAdapter;

/**
 * 原生视频模板详情页 DidPresent 回调
 */
- (void)adapter_nativeExpressAdViewAdapterDidPresentVideoViewController:
    (id<GDTNativeExpressAdViewAdapterProtocol>)viewAdapter;

/**
 * 原生视频模板详情页 WillDismiss 回调
 */
- (void)adapter_nativeExpressAdViewAdapterWillDismissVideoViewController:
    (id<GDTNativeExpressAdViewAdapterProtocol>)viewAdapter;

/**
 * 原生视频模板详情页 DidDismiss 回调
 */
- (void)adapter_nativeExpressAdViewAdapterDidDismissVideoViewController:
    (id<GDTNativeExpressAdViewAdapterProtocol>)viewAdapter;

@end
