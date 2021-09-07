//
//  GDTServerSideVerificationOptions.h
//  GDTMobApp
//
//  Created by Nancy on 2020/12/18.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GDTServerSideVerificationOptions : NSObject

//用户的userid,可选
@property(nonatomic, copy, nullable) NSString *userIdentifier;

//服务器端验证回调中包含的可选自定义奖励字符串
@property(nonatomic, copy, nullable) NSString *customRewardString;

@end

NS_ASSUME_NONNULL_END
