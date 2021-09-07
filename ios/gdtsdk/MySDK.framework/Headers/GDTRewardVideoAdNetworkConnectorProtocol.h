//
//  GDTRewardVideoAdNetworkConnectorProtocol.h
//  GDTMobApp
//
//  Created by royqpwang on 2019/6/19.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GDTRewardVideoAdNetworkAdapterProtocol;


@protocol GDTRewardVideoAdNetworkConnectorProtocol <NSObject>

- (void)adapter_rewardVideoAdDidLoad:(id<GDTRewardVideoAdNetworkAdapterProtocol>)adapter;

/**
 视频数据下载成功回调，已经下载过的视频会直接回调
 
 @param adapter 实例
 */
- (void)adapter_rewardVideoAdVideoDidLoad:(id<GDTRewardVideoAdNetworkAdapterProtocol>)adapter;

/**
 视频播放页即将展示回调
 
 @param adapter 实例
 */
- (void)adapter_rewardVideoAdWillVisible:(id<GDTRewardVideoAdNetworkAdapterProtocol>)adapter;

/**
 视频广告曝光回调
 
 @param adapter 实例
 */
- (void)adapter_rewardVideoAdDidExposed:(id<GDTRewardVideoAdNetworkAdapterProtocol>)adapter;

/**
 视频播放页关闭回调
 
 @param adapter 实例
 */
- (void)adapter_rewardVideoAdDidClose:(id<GDTRewardVideoAdNetworkAdapterProtocol>)adapter;

/**
 视频广告信息点击回调
 
 @param adapter 实例
 */
- (void)adapter_rewardVideoAdDidClicked:(id<GDTRewardVideoAdNetworkAdapterProtocol>)adapter;

/**
 视频广告各种错误信息回调
 
 @param adapter 实例
 @param error 具体错误信息
 */
- (void)adapter_rewardVideoAd:(id<GDTRewardVideoAdNetworkAdapterProtocol>)adapter didFailWithError:(NSError *)error;

/**
 视频广告播放达到激励条件回调
 
 @param adapter 实例
 */
- (void)adapter_rewardVideoAdDidRewardEffective:(id<GDTRewardVideoAdNetworkAdapterProtocol>)adapter;


- (void)adapter_rewardVideoAdDidPlayFinish:(id<GDTRewardVideoAdNetworkAdapterProtocol>)adapter;

@end
