//
//  GDTUnifiedNativeAdNetworkConnectorProtocol.h
//  GDTMobSDK
//
//  Created by Nancy on 2019/6/27.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDTUnifiedNativeAdView.h"

@protocol GDTUnifiedNativeAdDataObjectAdapterProtocol;
@protocol GDTUnifiedNativeAdNetworkAdapterProtocol;
@protocol GDTMediaViewAdapterProtocol;

NS_ASSUME_NONNULL_BEGIN

@protocol GDTUnifiedNativeAdNetworkConnectorProtocol <NSObject>

- (void)adapter:(id <GDTUnifiedNativeAdNetworkAdapterProtocol>)adapter
unifiedNativeAdLoaded:(NSArray<id <GDTUnifiedNativeAdDataObjectAdapterProtocol>> * _Nullable)unifiedNativeAdDataObjects
          error:(NSError * _Nullable)error;

@end

@protocol GDTMediaViewConnectorProtocol <NSObject>

- (void)adapter_mediaViewDidTapped:(id <GDTMediaViewAdapterProtocol>)mediaView;
- (void)adapter_mediaViewDidPlayFinished:(id <GDTMediaViewAdapterProtocol>)mediaView;

@end

@protocol GDTUnifiedNativeAdDataObjectConnectorProtocol <NSObject>

@property (nonatomic, strong, readonly) GDTUnifiedNativeAdView *unifiedNativeAdView;
@property (nonatomic, strong, readonly) UIView <GDTMediaViewConnectorProtocol> *mediaView;
@property (nonatomic, strong, readonly) GDTLogoView *logoView;

@optional

- (void)adapter_unifiedNativeAdViewWillExpose:(id <GDTUnifiedNativeAdDataObjectAdapterProtocol>)dataObject;

- (void)adapter_unifiedNativeAdViewDidClick:(id <GDTUnifiedNativeAdDataObjectAdapterProtocol>)dataObject;

- (void)adapter_unifiedNativeAdDetailViewClosed:(id <GDTUnifiedNativeAdDataObjectAdapterProtocol>)dataObject;

- (void)adapter_unifiedNativeAdViewApplicationWillEnterBackground:(id <GDTUnifiedNativeAdDataObjectAdapterProtocol>)dataObject;

- (void)adapter_unifiedNativeAdDetailViewWillPresentScreen:(id <GDTUnifiedNativeAdDataObjectAdapterProtocol>)dataObject;

- (void)adapter_unifiedNativeAdView:(id <GDTUnifiedNativeAdDataObjectAdapterProtocol>)dataObject
                playerStatusChanged:(GDTMediaPlayerStatus)status
                           userInfo:(nullable NSDictionary *)userInfo;
- (id <GDTUnifiedNativeAdDataObjectAdapterProtocol>) relatedDataObject;

- (void)adapter_unifiedNativeAdView:(id <GDTUnifiedNativeAdDataObjectAdapterProtocol>)dataObject
                   originDataObject:(GDTUnifiedNativeAdDataObject *)originDataObject
                    vastAdEventType:(GDTVastAdEventType)eventType;

@end




NS_ASSUME_NONNULL_END
