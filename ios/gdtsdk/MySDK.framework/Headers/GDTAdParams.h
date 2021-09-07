//
//  GDTAdParams.h
//  GDTMobApp
//
//  Created by royqpwang on 2020/4/30.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GDTAdParams : NSObject

/**
 *  广告大小，模板 2.0 信息流广告使用。当 height = 0，自动根据 width 算高；当 height > 0，直接使用传入的 width、height 作为模板容器 View 的大小。
 */
@property (nonatomic, assign) CGSize adSize;

/**
 *  非 WiFi 网络，视频广告是否自动播放。默认 NO。loadAd 前设置。
 */
@property (nonatomic, assign) BOOL videoAutoPlayOnWWAN;

/**
 *  视频广告自动播放时，是否静音。默认 YES。loadAd 前设置。
 */
@property (nonatomic, assign) BOOL videoMuted;

/**
 *  视频详情页播放时是否静音。默认NO。loadAd 前设置。
 */
@property (nonatomic, assign) BOOL detailPageVideoMuted;

/**
 请求视频的时长下限。
 以下两种情况会使用 0，1:不设置  2:minVideoDuration大于maxVideoDuration
*/
@property (nonatomic) NSInteger minVideoDuration;

/**
 请求视频的时长上限，视频时长有效值范围为[5,180]。
 */
@property (nonatomic) NSInteger maxVideoDuration;

@end

NS_ASSUME_NONNULL_END
