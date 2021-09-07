//
//  GDTBaseAdNetworkAdapterProtocol.h
//  GDTMobApp
//
//  Created by royqpwang on 2019/7/25.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GDTBaseAdNetworkAdapterProtocol <NSObject>

+ (void)updateAppId:(NSString *)appId extStr:(NSString *)extStr;

- (instancetype)initWithAdNetworkConnector:(id)connector
                                     posId:(NSString *)posId;


@optional

- (NSInteger)eCPM;
- (NSString *)eCPMLevel;
- (BOOL)isContractAd;

@end

