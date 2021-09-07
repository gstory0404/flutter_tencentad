//
//  GDTUnifiedinterstitialAdNetworkAdapterProtocol.h
//  GDTMobApp
//
//  Created by royqpwang on 2019/8/10.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDTBaseAdNetworkAdapterProtocol.h"

@protocol GDTRewardVideoAdNetworkConnectorProtocol;

NS_ASSUME_NONNULL_BEGIN

@protocol GDTUnifiedinterstitialAdNetworkAdapterProtocol <GDTBaseAdNetworkAdapterProtocol>

- (BOOL)isAdValid;
- (void)loadAd;
- (void)presentAdFromRootViewController:(UIViewController *)rootViewController;

@optional
@property (nonatomic, assign) BOOL videoAutoPlayOnWWAN;
@property (nonatomic, assign) BOOL videoMuted;
@property (nonatomic, assign) BOOL detailPageVideoMuted;
@property (nonatomic) NSInteger minVideoDuration;
@property (nonatomic) NSInteger maxVideoDuration;
@property (nonatomic, assign, readonly) BOOL isVideoAd;
@property (nonatomic, assign) BOOL shouldLoadFullscreenAd;
@property (nonatomic, assign) BOOL shouldShowFullscreenAd;

- (CGFloat)videoDuration;
- (CGFloat)videoPlayTime;


@end

NS_ASSUME_NONNULL_END
