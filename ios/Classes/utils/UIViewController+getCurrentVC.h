//
//  UIViewController+getCurrentVC.h
//  ANChat
//
//  Created by 郭维佳 on 2021/12/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (getCurrentVC)<UIViewControllerAnimatedTransitioning>

+ (UIViewController *)jsd_getCurrentViewController;

+ (UIViewController *)jsd_getRootViewController;

+ (UIViewController *)getCurrentVCWithCurrentView:(UIView *)currentView;

@end

NS_ASSUME_NONNULL_END
