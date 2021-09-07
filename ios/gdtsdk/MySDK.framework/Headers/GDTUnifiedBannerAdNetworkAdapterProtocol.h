//
//  GDTUnifiedBannerAdNetworkAdapterProtocol.h
//  GDTMobApp
//
//  Created by rowanzhang on 2021/7/22.
//  Copyright © 2021 Tencent. All rights reserved.
//

#ifndef GDTUnifiedBannerAdNetworkAdapterProtocol_h
#define GDTUnifiedBannerAdNetworkAdapterProtocol_h

#import "GDTUnifiedBannerView.h"
#import "GDTBaseAdNetworkAdapterProtocol.h"

@protocol GDTUnifiedBannerAdNetworkAdapterProtocol <GDTBaseAdNetworkAdapterProtocol>

- (void)loadAdOnBannerView:(GDTUnifiedBannerView *)banner
            currentViewController:(UIViewController *)viewController;

- (void)showBannerAd;

@end

#endif /* GDTUnifiedBannerAdNetworkAdapterProtocol_h */
