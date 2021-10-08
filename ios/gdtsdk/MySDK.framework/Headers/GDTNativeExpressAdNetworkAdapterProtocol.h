//
//  GDTNativeExpressAdNetworkAdapterProtocol.h
//  GDTMobApp
//
//  Created by royqpwang on 2019/11/27.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "GDTBaseAdNetworkAdapterProtocol.h"

@protocol GDTNativeExpressAdNetworkConnectorProtocol;

NS_ASSUME_NONNULL_BEGIN

@protocol GDTNativeExpressAdNetworkAdapterProtocol <GDTBaseAdNetworkAdapterProtocol>

- (void)loadAdWithCount:(NSInteger)count;

@optional
@property (nonatomic, assign) BOOL videoAutoPlayOnWWAN;
@property (nonatomic, assign) BOOL videoMuted;
@property (nonatomic, assign) BOOL detailPageVideoMuted;
@property (nonatomic, assign) NSInteger minVideoDuration;
@property (nonatomic, assign) NSInteger maxVideoDuration;
@property (nonatomic, assign) CGSize adSize;

@end

NS_ASSUME_NONNULL_END
