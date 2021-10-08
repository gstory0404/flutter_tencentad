//
//  GDTSDKConfig.h
//  GDTMobApp
//
//  Created by GaoChao on 14/8/25.
//  Copyright (c) 2014年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDTSDKDefines.h"
#import "GDTAdTestSetting.h"

@interface GDTSDKConfig : NSObject

/**
 SDK 注册接口，请在 app 初始化时调用。
 @param appId - 媒体ID
 
 @return 注册是否成功。
*/
+ (BOOL)registerAppId:(NSString *)appId;

/**
 * 提供给聚合平台用来设定SDK 流量分类
 */
+ (void)setSdkSrc:(NSString *)sdkSrc;

/**
 * 查看SDK流量来源
 */
+ (NSString *)sdkSrc;

/**
 * 获取 SDK 版本
 */

+ (NSString *)sdkVersion;

+ (void)enableGPS:(BOOL)enabled;

/**
* 设置流量渠道号
 渠道号信息主要用来协助平台提升流量变现效果及您的收益，请如实填写，若渠道号无法满足您的诉求请联系平台负责商务
 
 渠道号映射关系为：
 1：百度
 2：头条
 3：广点通
 4：搜狗
 5：其他网盟
 6：oppo
 7：vivo
 8：华为
 9：应用宝
 10：小米
 11：金立
 12：百度手机助手
 13：魅族
 14：AppStore
 999：其他
*/
+ (void)setChannel:(NSInteger)channel;

+ (void)setSDKType:(NSInteger)type;

/**
 在播放音频时是否使用SDK内部对AVAudioSession设置的category及options，默认使用，若不使用，SDK内部不做任何处理，由调用方在展示广告时自行设置；
 SDK设置的category为AVAudioSessionCategoryAmbient，options为AVAudioSessionCategoryOptionDuckOthers
 */
+ (void)enableDefaultAudioSessionSetting:(BOOL)enabled;

+ (GDTAdTestSetting *)debugSetting;

/**
 设置开发阶段调试相关的配置
 */
+ (void)setDebugSetting:(GDTAdTestSetting *)debugSetting;

+ (void)forbiddenIDFA:(BOOL)forbiddened;

/**
 获取 buyerId 用于 Server Bidding 请求获取 token, 建议每次请求前调用一次, 并使用最新值请求
 */
+ (NSString *)getBuyerId;

/**
 设置个性化推荐状态
 @param state 1为关闭个性化推荐，其他值或未设置为打开
 */
+ (void)setPersonalizedState:(NSInteger)state;

@end

