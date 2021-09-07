//
//  GDTSplashZoomOutView.h
//  GDTMobApp
//
//  Created by nimomeng on 2020/11/11.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@class GDTSplashZoomOutView;

@protocol GDTSplashZoomOutViewDelegate <NSObject>
@optional
- (void)splashZoomOutViewDidClick:(GDTSplashZoomOutView *)splashZoomOutView;
- (void)splashZoomOutViewAdDidClose:(GDTSplashZoomOutView *)splashZoomOutView;
- (void)splashZoomOutViewAdVideoFinished:(GDTSplashZoomOutView *)splashZoomOutView;
- (void)splashZoomOutViewAdDidPresentFullScreenModal:(GDTSplashZoomOutView *)splashZoomOutView;
- (void)splashZoomOutViewAdDidDismissFullScreenModal:(GDTSplashZoomOutView *)splashZoomOutView;
@end

@interface GDTSplashZoomOutView : UIView
@property (nonatomic, weak) UIViewController *rootViewController;
@property (nonatomic, weak) id<GDTSplashZoomOutViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
