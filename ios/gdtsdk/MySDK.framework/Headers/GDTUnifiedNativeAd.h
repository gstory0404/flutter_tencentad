//
//  GDTUnifiedNativeAd.h
//  GDTMobSDK
//
//  Created by nimomeng on 2018/10/10.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDTUnifiedNativeAdDataObject.h"
#import "GDTUnifiedNativeAdView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol GDTUnifiedNativeAdDelegate <NSObject>

/**
 广告数据回调

 @param unifiedNativeAdDataObjects 广告数据数组
 @param error 错误信息
 */
- (void)gdt_unifiedNativeAdLoaded:(NSArray<GDTUnifiedNativeAdDataObject *> * _Nullable)unifiedNativeAdDataObjects error:(NSError * _Nullable)error;
@end

@interface GDTUnifiedNativeAd : NSObject
@property (nonatomic, weak) id<GDTUnifiedNativeAdDelegate> delegate;

/**
 请求视频的时长下限。
 以下两种情况会使用 0，1:不设置  2:minVideoDuration大于maxVideoDuration
*/
@property (nonatomic) NSInteger minVideoDuration;

/**
 请求视频的时长上限，视频时长有效值范围为[5,180]。
 */
@property (nonatomic) NSInteger maxVideoDuration;

/**
 可选属性，设置本次拉取的视频广告从用户角度看到的视频播放策略。
 
 “用户角度”特指用户看到的情况，并非SDK是否自动播放，与自动播放策略 GDTVideoAutoPlayPolicy 的取值并非一一对应
 
 例如开发者设置了 GDTVideoAutoPlayPolicyNever 表示 SDK 不自动播放视频，但是开发者通过 GDTMediaView 的 play 方法播放视频，这在用户看来仍然是自动播放的。
 
 准确的设置 GDTVideoPlayPolicy 有助于提高视频广告的eCPM值，如果广告位仅支持图文广告，则无需调用。
 
 需要在 loadAd 前设置此属性。
 */
@property (nonatomic, assign) GDTVideoPlayPolicy videoPlayPolicy;

/**
 可选属性，设置本次拉取的视频广告封面是由SDK渲染还是开发者自行渲染。
 
 SDK 渲染，指视频广告 containerView 直接在 feed 流等场景展示，用户可以直接看到渲染的视频广告。Demo 工程中的 “视频Feed” 就是 SDK 渲染。
 
 开发者自行渲染，指开发者获取到广告对象后，先用封面图字段在 feed 流中先渲染出一个封面图入口，用户点击封面图，再进入一个有 conainterView 的详细页，播放视频。Demo 工程中的 "竖版 Feed 视频" 就是开发者渲染的场景。
 */
@property (nonatomic, assign) GDTVideoRenderType videoRenderType;

/**
 构造方法

 @param placementId 广告位ID
 @return GDTUnifiedNativeAd 实例
 */
- (instancetype)initWithPlacementId:(NSString *)placementId;

/**
 *  构造方法, S2S bidding 后获取到 token 再调用此方法
 *  @param placementId  广告位 ID
 *  @param token  通过 Server Bidding 请求回来的 token
 */
- (instancetype)initWithPlacementId:(NSString *)placementId token:(NSString *)token;

/**
 构造方法

 @param appId 媒体ID
 @param placementId 广告位ID
 @return GDTUnifiedNativeAd 实例
 */
- (instancetype)initWithAppId:(NSString *)appId placementId:(NSString *)placementId GDT_DEPRECATED_MSG_ATTRIBUTE("接口即将废弃，请使用 initWithPlacementId:");

/**
 *  S2S bidding 竟胜之后调用, 需要在调用广告 show 之前调用
 *  @param eCPM - 曝光扣费, 单位分，若优量汇竞胜，在广告曝光时回传，必传
 *  针对本次曝光的媒体期望扣费，常用扣费逻辑包括一价扣费与二价扣费，当采用一价扣费时，胜者出价即为本次扣费价格；当采用二价扣费时，第二名出价为本次扣费价格.
 */
- (void)setBidECPM:(NSInteger)eCPM;

/**
 加载广告
 */
- (void)loadAd;

/**
 加载广告

 @param adCount 加载条数
 */
- (void)loadAdWithAdCount:(NSInteger)adCount;

/**
 *  竟胜之后调用, 需要在调用广告 show 之前调用
 *  @param price - 竟胜价格 (单位: 分)
 */
- (void)sendWinNotificationWithPrice:(NSInteger)price;

/**
 *  竟败之后调用
 *  @param price - 竟胜价格 (单位: 分)
 *  @param reason - 优量汇广告竟败原因
 *  @param adnID - adnID
 */
- (void)sendLossNotificationWithWinnerPrice:(NSInteger)price lossReason:(GDTAdBiddingLossReason)reason winnerAdnID:(NSString *)adnID;

/**
 返回广告平台名称
 
 @return 当使用流量分配功能时，用于区分广告平台；未使用时为空字符串
 */
- (NSString *)adNetworkName;

/**
 * 当需要支持 VAST 广告时，需流量自行配置 adapter 的 vastClassName
 */
- (void)setVastClassName:(NSString *)vastClassName;

@end
NS_ASSUME_NONNULL_END
