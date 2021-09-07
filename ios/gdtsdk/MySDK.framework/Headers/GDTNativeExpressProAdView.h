//
//  GDTNativeExpressProAdView.h
//  GDTMobApp
//
//  Created by royqpwang on 2020/4/28.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDTAdParams.h"
#import "GDTSDKDefines.h"

NS_ASSUME_NONNULL_BEGIN

@class GDTNativeExpressProAdView;

@protocol GDTNativeExpressProAdViewDelegate <NSObject>

@optional
/**
 * 原生模板2.0广告渲染成功, 此时的 nativeExpressAdView.size.height 根据 size.width 完成了动态更新。
 */
- (void)gdt_NativeExpressProAdViewRenderSuccess:(GDTNativeExpressProAdView *)nativeExpressProAdView;

/**
 * 原生模板2.0广告渲染失败
 */
- (void)gdt_NativeExpressProAdViewRenderFail:(GDTNativeExpressProAdView *)nativeExpressProAdView;

/**
 * 原生模板2.0广告曝光回调
 */
- (void)gdt_NativeExpressProAdViewExposure:(GDTNativeExpressProAdView *)nativeExpressProAdView;

/**
 * 原生模板2.0广告点击回调
 */
- (void)gdt_NativeExpressProAdViewClicked:(GDTNativeExpressProAdView *)nativeExpressProAdView;

/**
 * 原生模板2.0广告被关闭
 */
- (void)gdt_NativeExpressProAdViewClosed:(GDTNativeExpressProAdView *)nativeExpressProAdView;

/**
 * 点击原生模板2.0广告以后即将弹出全屏广告页
 */
- (void)gdt_NativeExpressProAdViewWillPresentScreen:(GDTNativeExpressProAdView *)nativeExpressProAdView;

/**
 * 点击原生模板2.0广告以后弹出全屏广告页
 */
- (void)gdt_NativeExpressProAdViewDidPresentScreen:(GDTNativeExpressProAdView *)nativeExpressProAdView;

/**
 * 全屏广告页将要关闭
 */
- (void)gdt_NativeExpressProAdViewWillDissmissScreen:(GDTNativeExpressProAdView *)nativeExpressProAdView;

/**
 * 全屏广告页已经关闭
 */
- (void)gdt_NativeExpressProAdViewDidDissmissScreen:(GDTNativeExpressProAdView *)nativeExpressProAdView;

/**
 * 视频详情页 WillPresent 回调
 */
- (void)gdt_NativeExpressProAdViewWillPresentVideoVC:(GDTNativeExpressProAdView *)nativeExpressProAdView;

/**
 * 视频详情页 DidPresent 回调
 */
- (void)gdt_NativeExpressProAdViewDidPresentVideoVC:(GDTNativeExpressProAdView *)nativeExpressProAdView;

/**
 * 视频详情页 WillDismiss 回调
 */
- (void)gdt_NativeExpressProAdViewWillDismissVideoVC:(GDTNativeExpressProAdView *)nativeExpressProAdView;

/**
 * 视频详情页 DidDismiss 回调
 */
- (void)gdt_NativeExpressProAdViewDidDismissVideoVC:(GDTNativeExpressProAdView *)nativeExpressProAdView;

/**
 * 详解:当点击应用下载或者广告调用系统程序打开时调用
 */
- (void)gdt_NativeExpressProAdViewApplicationWillEnterBackground:(GDTNativeExpressProAdView *)nativeExpressProAdView;

/**
 * 原生模板视频广告 player 播放状态更新回调
 */
- (void)gdt_NativeExpressProAdView:(GDTNativeExpressProAdView *)nativeExpressProAdView playerStatusChanged:(GDTMediaPlayerStatus)status;

- (void)gdt_NativeExpressProAdViewVideoDidFinished:(GDTNativeExpressProAdView *)nativeExpressProAdView;

@end

@interface GDTNativeExpressProAdView : UIView

@property (nonatomic, weak) id <GDTNativeExpressProAdViewDelegate> delegate;

/**
 * 是否渲染完毕
 */
@property (nonatomic, assign, readonly) BOOL isReady;

/**
 * 是否是视频模板广告
 */
@property (nonatomic, assign, readonly) BOOL isVideoAd;

/*
 *  viewControllerForPresentingModalView
 *  详解：[必选]开发者需传入用来弹出目标页的ViewController，一般为当前ViewController
 */
@property (nonatomic, weak) UIViewController *controller;

/**
 *[必选]
 *原生模板2.0广告渲染
 */
- (void)render;

/**
 * 视频模板广告时长，单位 ms
 */
- (CGFloat)videoDuration;

/**
 * 视频模板广告已播放时长，单位 ms
 */
- (CGFloat)videoPlayTime;

/**
 返回广告的eCPM，单位：分
 
 @return 成功返回一个大于等于0的值，-1表示无权限或后台出现异常
 */
- (NSInteger)eCPM;

/**
 返回广告的eCPM等级
 
 @return 成功返回一个包含数字的string，@""或nil表示无权限或后台异常
 */
- (NSString *)eCPMLevel;

@end

NS_ASSUME_NONNULL_END
