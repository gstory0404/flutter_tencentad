//
//  GDTUnifiedBannerAdNetworkConnectorProtocol.h
//  GDTMobApp
//
//  Created by rowanzhang on 2021/7/22.
//  Copyright © 2021 Tencent. All rights reserved.
//

#ifndef GDTUnifiedBannerAdNetworkConnectorProtocol_h
#define GDTUnifiedBannerAdNetworkConnectorProtocol_h

@protocol GDTUnifiedBannerAdNetworkAdapterProtocol;

@protocol GDTUnifiedBannerAdNetworkConnectorProtocol <NSObject>

@optional

- (void)adapter_unifiedBannerViewDidLoad:(id <GDTUnifiedBannerAdNetworkAdapterProtocol>)adapter;

- (void)adapter_unifiedBannerViewFailedToLoad:(id <GDTUnifiedBannerAdNetworkAdapterProtocol>)adapter error:(NSError *)error;

- (void)adapter_unifiedBannerViewWillExpose:(id <GDTUnifiedBannerAdNetworkAdapterProtocol>)adapter;

- (void)adapter_unifiedBannerViewClicked:(id <GDTUnifiedBannerAdNetworkAdapterProtocol>)adapter;

- (void)adapter_unifiedBannerViewWillPresentFullScreenModal:(id <GDTUnifiedBannerAdNetworkAdapterProtocol>)adapter;

- (void)adapter_unifiedBannerViewDidPresentFullScreenModal:(id <GDTUnifiedBannerAdNetworkAdapterProtocol>)adapter;

- (void)adapter_unifiedBannerViewWillDismissFullScreenModal:(id <GDTUnifiedBannerAdNetworkAdapterProtocol>)adapter;

- (void)adapter_unifiedBannerViewDidDismissFullScreenModal:(id <GDTUnifiedBannerAdNetworkAdapterProtocol>)adapter;

- (void)adapter_unifiedBannerViewWillLeaveApplication:(id <GDTUnifiedBannerAdNetworkAdapterProtocol>)adapter;

- (void)adapter_unifiedBannerViewWillClose:(id <GDTUnifiedBannerAdNetworkAdapterProtocol>)adapter;

@end

#endif /* GDTUnifiedBannerAdNetworkConnectorProtocol_h */
