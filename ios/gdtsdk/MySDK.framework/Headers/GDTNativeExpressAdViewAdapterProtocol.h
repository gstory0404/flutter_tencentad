//
//  GDTNativeExpressAdViewAdapterProtocol.h
//  GDTMobApp
//
//  Created by rowanzhang on 2021/8/16.
//  Copyright © 2021 Tencent. All rights reserved.
//

#ifndef GDTNativeExpressAdViewAdapterProtocol_h
#define GDTNativeExpressAdViewAdapterProtocol_h
@class GDTNativeExpressAdView;
@protocol GDTNativeExpressAdViewAdapterProtocol <NSObject>

@property (nonatomic, weak) GDTNativeExpressAdView *gdtExpressAdView;

@property (nonatomic, assign, readonly) BOOL isReady;
@property (nonatomic, assign, readonly) BOOL isVideoAd;
@property (nonatomic, weak) UIViewController *controller;

- (UIView *)adView;

- (void)render;
- (CGFloat)videoDuration;
- (CGFloat)videoPlayTime;
- (NSInteger)eCPM;
- (NSString *)eCPMLevel;

@end

#endif /* GDTNativeExpressAdViewAdapterProtocol_h */
