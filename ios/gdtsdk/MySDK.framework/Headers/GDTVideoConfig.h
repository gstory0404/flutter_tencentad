//
//  GDTVideoConfig.h
//  GDTMobApp
//
//  Created by royqpwang on 2019/5/16.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, GDTVideoAutoPlayPolicy) {
    GDTVideoAutoPlayPolicyWIFI = 0, // WIFI 下自动播放
    GDTVideoAutoPlayPolicyAlways = 1, // 总是自动播放，无论网络条件
    GDTVideoAutoPlayPolicyNever = 2, // 从不自动播放，无论网络条件
};

NS_ASSUME_NONNULL_BEGIN

@interface GDTVideoConfig : NSObject

/**
 视频自动播放策略，默认 GDTVideoAutoPlayPolicyAlways,
 选择 GDTVideoAutoPlayPolicyNever 策略时，需要开发者调用 GDTMediaView 的 play\pause 方法触发视频播、暂停，
 或者开启 userControlEnable 设置，让用户点击 MediaView 控制播放状态
 */
@property (nonatomic, assign) GDTVideoAutoPlayPolicy autoPlayPolicy;

/**
 是否静音播放视频广告，视频初始状态是否静音，默认 YES，
 可通过 GDTMediaView muteEnable: 方法实时控制播放器j静音状态，
 */
@property (nonatomic, assign) BOOL videoMuted;

/**
 视频详情页播放时是否静音，默认NO，
 */
@property (nonatomic, assign) BOOL detailPageVideoMuted;

/**
 是否启动自动续播功能，当在 tableView 等场景播放器被销毁时，广告展示时继续从上次播放位置续播，默认 NO
 */
@property (nonatomic, assign) BOOL autoResumeEnable;

/**
 广告发生点击行为时，是否展示视频详情页
 设为 NO 时，用户点击 clickableViews 会直接打开 App Store 或者广告落地页
 */
@property (nonatomic, assign) BOOL detailPageEnable;

/**
 是否支持用户点击 MediaView 改变视频播放暂停状态，默认 YES
 设为 YES 时，用户点击会切换播放器播放、暂停状态
 */
@property (nonatomic, assign) BOOL userControlEnable;

/**
 是否展示播放进度条，默认 YES
 */
@property (nonatomic, assign) BOOL progressViewEnable;

/**
 是否展示播放器封面图，默认 YES
 */
@property (nonatomic, assign) BOOL coverImageEnable;

@end

NS_ASSUME_NONNULL_END
