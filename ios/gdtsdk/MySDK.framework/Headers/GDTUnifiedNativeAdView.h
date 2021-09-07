//
//  GDTUnifiedNativeAdView.h
//  GDTMobSDK
//
//  Created by nimomeng on 2018/10/10.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDTLogoView.h"
#import "GDTMediaView.h"
#import "GDTUnifiedNativeAdDataObject.h"
#import "GDTSDKDefines.h"

@class GDTUnifiedNativeAdView;

//视频广告时长Key
extern NSString* const kGDTUnifiedNativeAdKeyVideoDuration;

@protocol GDTUnifiedNativeAdViewDelegate <NSObject>

@optional
/**
 广告曝光回调

 @param unifiedNativeAdView GDTUnifiedNativeAdView 实例
 */
- (void)gdt_unifiedNativeAdViewWillExpose:(GDTUnifiedNativeAdView *)unifiedNativeAdView;


/**
 广告点击回调

 @param unifiedNativeAdView GDTUnifiedNativeAdView 实例
 */
- (void)gdt_unifiedNativeAdViewDidClick:(GDTUnifiedNativeAdView *)unifiedNativeAdView;


/**
 广告详情页关闭回调

 @param unifiedNativeAdView GDTUnifiedNativeAdView 实例
 */
- (void)gdt_unifiedNativeAdDetailViewClosed:(GDTUnifiedNativeAdView *)unifiedNativeAdView;


/**
 当点击应用下载或者广告调用系统程序打开时调用
 
 @param unifiedNativeAdView GDTUnifiedNativeAdView 实例
 */
- (void)gdt_unifiedNativeAdViewApplicationWillEnterBackground:(GDTUnifiedNativeAdView *)unifiedNativeAdView;


/**
 广告详情页面即将展示回调

 @param unifiedNativeAdView GDTUnifiedNativeAdView 实例
 */
- (void)gdt_unifiedNativeAdDetailViewWillPresentScreen:(GDTUnifiedNativeAdView *)unifiedNativeAdView;


/**
 视频广告播放状态更改回调

 @param nativeExpressAdView GDTUnifiedNativeAdView 实例
 @param status 视频广告播放状态
 @param userInfo 视频广告信息
 */
- (void)gdt_unifiedNativeAdView:(GDTUnifiedNativeAdView *)unifiedNativeAdView playerStatusChanged:(GDTMediaPlayerStatus)status userInfo:(NSDictionary *)userInfo;
@end

@interface GDTUnifiedNativeAdView:UIView

/**
 绑定的数据对象
 */
@property (nonatomic, strong, readonly) GDTUnifiedNativeAdDataObject *dataObject;

/**
 视频广告的媒体View，绑定数据对象后自动生成，可自定义布局
 */
@property (nonatomic, strong, readonly) GDTMediaView *mediaView;

/**
 腾讯广告 LogoView，自动生成，可自定义布局
 */
@property (nonatomic, strong, readonly) GDTLogoView *logoView;

/**
 广告 View 时间回调对象
 */
@property (nonatomic, weak) id<GDTUnifiedNativeAdViewDelegate> delegate;

/*
 *  viewControllerForPresentingModalView
 *  详解：开发者需传入用来弹出目标页的ViewController，一般为当前ViewController
 */
@property (nonatomic, weak) UIViewController *viewController;

/**
 自渲染2.0视图注册方法
 
 @param dataObject 数据对象，必传字段
 @param clickableViews 可点击的视图数组，此数组内的广告元素才可以响应广告对应的点击事件
 */
- (void)registerDataObject:(GDTUnifiedNativeAdDataObject *)dataObject
            clickableViews:(NSArray<UIView *> *)clickableViews;


/**
 自渲染2.0视图注册方法
 @param dataObject 数据对象，必传字段
 @param clickableViews 可点击的视图数组，此数组内的广告元素才可以响应广告对应的点击事件
 @param customClickableViews 可点击的视图数组，与clickableViews的区别是：在视频广告中当dataObject中的videoConfig的detailPageEnable为YES时，点击后直接进落地页而非视频详情页，除此条件外点击行为与clickableViews保持一致
 */
- (void)registerDataObject:(GDTUnifiedNativeAdDataObject *)dataObject
            clickableViews:(NSArray<UIView *> *)clickableViews customClickableViews:(NSArray <UIView *> *)customClickableViews;

/**
 注册可点击的callToAction视图的方法
 建议开发者使用GDTUnifiedNativeAdDataObject中的callToAction字段来创建视图，并取代自定义的下载或打开等button,
 调用此方法之前必须先调用registerDataObject:clickableViews
 @param callToActionView CTA视图, 系统自动处理点击事件
 */
- (void)registerClickableCallToActionView:(UIView *)callToActionView;

/**
 注销数据对象，在 tableView、collectionView 等场景需要复用 GDTUnifiedNativeAdView 时，
 需要在合适的时机，例如 cell 的 prepareForReuse 方法内执行 unregisterDataObject 方法，
 将广告对象与 GDTUnifiedNativeAdView 解绑，具体可参考示例 demo 的 UnifiedNativeAdBaseTableViewCell 类
 */
- (void)unregisterDataObject;

//#pragma mark - DEPRECATED
///**
// 此方法已经废弃
// 自渲染2.0视图注册方法
//
// @param dataObject 数据对象，必传字段
// @param logoView logo视图
// @param viewController 所在ViewController，必传字段。支持在register之后对其进行修改
// @param clickableViews 可点击的视图数组，此数组内的广告元素才可以响应广告对应的点击事件
// */
//- (void)registerDataObject:(GDTUnifiedNativeAdDataObject *)dataObject
//                  logoView:(GDTLogoView *)logoView
//            viewController:(UIViewController *)viewController
//            clickableViews:(NSArray<UIView *> *)clickableViews GDT_DEPRECATED_MSG_ATTRIBUTE("use registerDataObject:clickableViews: instead.");
//
//
///**
// 此方法已经废弃
// 自渲染2.0视图注册方法
// 
// @param dataObject 数据对象，必传字段
// @param mediaView 媒体对象视图，此处放视频播放器的容器视图
// @param logoView logo视图
// @param viewController 所在ViewController，必传字段。支持在register之后对其进行修改
// @param clickableViews 可点击的视图数组，此数组内的广告元素才可以响应广告对应的点击事件
// */
//- (void)registerDataObject:(GDTUnifiedNativeAdDataObject *)dataObject
//                 mediaView:(GDTMediaView *)mediaView
//                  logoView:(GDTLogoView *)logoView
//            viewController:(UIViewController *)viewController
//            clickableViews:(NSArray<UIView *> *)clickableViews GDT_DEPRECATED_MSG_ATTRIBUTE("use registerDataObject:clickableViews: instead.");
@end



