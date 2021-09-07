//
//  GDTAdDebugSetting.h
//  GDTMobSDK
//
//  Created by Nancy on 2020/8/12.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 提供一些配置，用于在开发调试阶段使用
 */
@interface GDTAdTestSetting : NSObject
@property (nonatomic, copy, nullable) NSString *playableUrl;//测试时使用的试玩广告地址
@end

NS_ASSUME_NONNULL_END
