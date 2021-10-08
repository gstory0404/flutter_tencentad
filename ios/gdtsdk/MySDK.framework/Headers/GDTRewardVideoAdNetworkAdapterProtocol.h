//
//  GDTRewardVideoAdNetworkAdapterProtocol.h
//  GDTMobApp
//
//  Created by royqpwang on 2019/6/19.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDTBaseAdNetworkAdapterProtocol.h"
#import "GDTServerSideVerificationOptions.h"

@protocol GDTRewardVideoAdNetworkConnectorProtocol;

NS_ASSUME_NONNULL_BEGIN

@protocol GDTRewardVideoAdNetworkAdapterProtocol <GDTBaseAdNetworkAdapterProtocol>

- (void)loadAd;

@optional

@property (nonatomic, strong) GDTServerSideVerificationOptions *serverSideVerificationOptions;

@property (nonatomic) BOOL videoMuted;

- (BOOL)showAdFromRootViewController:(UIViewController *)viewController;

- (BOOL)isAdValid;

- (NSInteger)expiredTimestamp;

- (CGFloat)videoDuration;


@end

NS_ASSUME_NONNULL_END
