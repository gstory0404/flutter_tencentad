//
//  GDTLoadAdParams.h
//  GDTMobSDK
//
//  Created by vicluo(罗翔) on 2019/4/26.
//  Copyright © 2019年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDTSDKDefines.h"

@interface GDTLoadAdParams : NSObject

//登陆账号类型:QQ or weixin
@property (nonatomic, assign) GDTSDKLoginType loginType;

//登陆账号体系分配的appID，如QQ分配的appID或是微信分配的appID
@property (nonatomic, copy) NSString *loginAppId;

//登陆账号体系分配的openID，如QQ分配的openId或是微信分配的openId
@property (nonatomic, copy) NSString *loginOpenId;

//透传字段，key跟value都由调用方自行指定
@property (nonatomic, strong) NSDictionary *dictionary;

- (void)setExtraInfo:(NSDictionary*)dict;

@end


