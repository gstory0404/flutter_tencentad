//
//  GDTUnifiedNativeAdNetworkAdapterProtocol.h
//  GDTMobSDK
//
//  Created by Nancy on 2019/6/27.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "GDTBaseAdNetworkAdapterProtocol.h"

@class GDTUnifiedNativeAdDataObject;
@protocol GDTUnifiedNativeAdNetworkConnectorProtocol;

NS_ASSUME_NONNULL_BEGIN

@protocol GDTUnifiedNativeAdNetworkAdapterProtocol <GDTBaseAdNetworkAdapterProtocol>

@property (nonatomic, assign) NSInteger maxVideoDuration;
@property (nonatomic, assign) NSInteger minVideoDuration;

- (void)loadAdWithCount:(NSInteger)count;

@end


@class GDTVideoConfig;
@protocol GDTUnifiedNativeAdDataObjectConnectorProtocol;

@protocol GDTUnifiedNativeAdDataObjectAdapterProtocol <NSObject>

@property (nonatomic, copy, readonly) NSString *title;

/**
 广告描述
 */
@property (nonatomic, copy, readonly) NSString *desc;

/**
 广告大图Url
 */
@property (nonatomic, copy, readonly) NSString *imageUrl;

/**
 素材宽度，单图广告代表大图 imageUrl 宽度、多图广告代表小图 mediaUrlList 宽度
 */
@property (nonatomic, readonly) NSInteger imageWidth;

/**
 素材高度，单图广告代表大图 imageUrl 高度、多图广告代表小图 mediaUrlList 高度
 */
@property (nonatomic, readonly) NSInteger imageHeight;

/**
 应用类广告App 图标Url
 */
@property (nonatomic, copy, readonly) NSString *iconUrl;

/**
 三小图广告的图片Url集合
 */
@property (nonatomic, copy, readonly) NSArray *mediaUrlList;

/**
 应用类广告的星级（5星制度）
 */
@property (nonatomic, readonly) CGFloat appRating;

/**
 应用类广告的价格
 */
@property (nonatomic, strong, readonly) NSNumber *appPrice;

/**
 是否为应用类广告
 */
@property (nonatomic, readonly) BOOL isAppAd;

/**
 是否为视频广告
 */
@property (nonatomic, readonly) BOOL isVideoAd;

/**
 是否为三小图广告
 */
@property (nonatomic, readonly) BOOL isThreeImgsAd;

/**
 返回广告的eCPM，单位：分
 
 @return 成功返回一个大于等于0的值，-1表示无权限或后台出现异常
 */
@property (nonatomic, readonly) NSInteger eCPM;

/**
 *  视频广告时长，单位 ms
 */
@property (nonatomic, readonly) CGFloat duration;

/**
 视频广告播放配置
 */
@property (nonatomic, strong) GDTVideoConfig *videoConfig;

@optional

@property (nonatomic, copy, readonly) NSString *eCPMLevel;

@property (nonatomic, copy, readonly) NSString *callToAction;

@property (nonatomic, copy, readonly) NSString *buttonText;

@property (nonatomic, assign, readonly) BOOL skippable;

/**
 *  VAST Tag Url，可能为空。
 */
@property (nonatomic, copy, readonly) NSString *vastTagUrl;

/**
 * VAST Content，可能为空。
 */
@property (nonatomic, copy, readonly) NSString *vastContent;

/**
 * 是否为 VAST 广告
 */
@property (nonatomic, readonly) BOOL isVastAd;

/**
 * 是否为微信原生页广告
 */
@property (nonatomic, readonly) BOOL isWechatCanvasAd;

/**
 判断两个自渲染2.0广告数据是否相等
 
 @param dataObject 需要对比的自渲染2.0广告数据对象
 @return YES or NO
 */
- (instancetype)initWithUnifiedNativeAdDataObject:(GDTUnifiedNativeAdDataObject *)dataObject;

- (BOOL)equalsAdData:(id <GDTUnifiedNativeAdDataObjectAdapterProtocol>)dataObject;

- (void)setRootViewController:(UIViewController * _Nullable)rootViewController;
- (void)registerConnector:(id <GDTUnifiedNativeAdDataObjectConnectorProtocol>)connector
           clickableViews:(NSArray *)clickableViews;
- (void)registerClickableCallToActionView:(UIView *)callToActionView;
- (void)unregisterView;

//是否需要主动检测曝光，默认NO
- (BOOL)needsToDetectExposure;
//检测到曝光后调用
- (void)didRecordImpression;

@end


@protocol GDTMediaViewAdapterProtocol <NSObject>

@optional
/**
 * 视频广告时长，单位 ms
 */
- (CGFloat)videoDuration;

/**
 * 视频广告已播放时长，单位 ms
 */
- (CGFloat)videoPlayTime;

/**
 播放视频
 */
- (void)play;

/**
 暂停视频，调用 pause 后，需要被暂停的视频广告对象，不会再自动播放，需要调用 play 才能恢复播放。
 */
- (void)pause;

/**
 停止播放，并展示第一帧
 */
- (void)stop;

/**
 播放静音开关
 @param flag 是否静音
 */
- (void)muteEnable:(BOOL)flag;

/**
 自定义播放按钮
 
 @param image 自定义播放按钮图片，不设置为默认图
 @param size 自定义播放按钮大小，不设置为默认大小 44 * 44
 */
- (void)setPlayButtonImage:(UIImage *)image size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
