//
//  UIViewController+getCurrentVC.m
//  ANChat
//
//  Created by gstory on 2021/12/1.
//

#import "TUIViewController+getCurrentVC.h"
//#import "HNBasePresentationController.h"

@implementation UIViewController (getCurrentVC)


+ (UIWindow *)jsd_getKeyWindow{
    UIWindow *window = nil;

    if (@available(iOS 13.0, *)) {
        NSSet<UIScene *> *connectedScenes = UIApplication.sharedApplication.connectedScenes;
        for (UIScene *scene in connectedScenes) {
            if (![scene isKindOfClass:[UIWindowScene class]]) {
                continue;
            }
            UIWindowScene *windowScene = (UIWindowScene *)scene;
            if (windowScene.activationState != UISceneActivationStateForegroundActive) {
                continue;
            }
            for (UIWindow *item in windowScene.windows) {
                if (item.isKeyWindow) {
                    return item;
                }
            }
            for (UIWindow *item in windowScene.windows) {
                if (!item.isHidden && item.windowLevel == UIWindowLevelNormal) {
                    window = item;
                    break;
                }
            }
            if (window != nil) {
                return window;
            }
        }
    }

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    window = UIApplication.sharedApplication.keyWindow;
#pragma clang diagnostic pop
    if (window != nil) {
        return window;
    }

    for (UIWindow *item in UIApplication.sharedApplication.windows) {
        if (item.isKeyWindow) {
            return item;
        }
    }
    for (UIWindow *item in UIApplication.sharedApplication.windows) {
        if (!item.isHidden && item.windowLevel == UIWindowLevelNormal) {
            return item;
        }
    }

    return nil;
}

+ (UIViewController *)jsd_getRootViewController{
    UIWindow *window = [self jsd_getKeyWindow];
    if (window.rootViewController != nil) {
        return window.rootViewController;
    }

    for (UIWindow *item in UIApplication.sharedApplication.windows) {
        if (item.rootViewController != nil) {
            return item.rootViewController;
        }
    }
    return nil;
}

+ (UIViewController *)jsd_getCurrentViewController{
    
    UIViewController* currentViewController = [self jsd_getRootViewController];
    if (currentViewController == nil) {
        return nil;
    }
    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currentViewController.presentedViewController && !currentViewController.presentedViewController.isBeingDismissed) {
            
            currentViewController = currentViewController.presentedViewController;
        } else if ([currentViewController isKindOfClass:[UINavigationController class]]) {
            
            UINavigationController* navigationController = (UINavigationController* )currentViewController;
            UIViewController *topVC = navigationController.topViewController ?: navigationController.visibleViewController;
            if (topVC != nil) {
                currentViewController = topVC;
            } else if (navigationController.childViewControllers.count > 0) {
                currentViewController = [navigationController.childViewControllers lastObject];
            } else {
                return navigationController;
            }
            
        } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
            
            UITabBarController* tabBarController = (UITabBarController* )currentViewController;
            if (tabBarController.selectedViewController != nil) {
                currentViewController = tabBarController.selectedViewController;
            } else {
                return tabBarController;
            }
        } else {
            
            NSUInteger childViewControllerCount = currentViewController.childViewControllers.count;
            if (childViewControllerCount > 0) {
                
                UIViewController *nextController = currentViewController.childViewControllers.lastObject;
                if (nextController != nil && nextController != currentViewController) {
                    currentViewController = nextController;
                } else {
                    return currentViewController;
                }
            } else {
                
                return currentViewController;
            }
        }
        
    }
    return currentViewController;
}

+ (UIViewController *)getCurrentVCWithCurrentView:(UIView *)currentView
{
    for (UIView *next = currentView ; next ; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


+(UITabBarController *)currentTtabarController
{
    UIWindow * window = [self jsd_getKeyWindow];
    UIViewController *tabbarController = window.rootViewController;
    if ([tabbarController isKindOfClass:[UITabBarController class]]) {
        return (UITabBarController *)tabbarController;
    }
    return nil;
}

+(UINavigationController *)currentTabbarSelectedNavigationController
{
    UIWindow * window = [self jsd_getKeyWindow];
    UIViewController *rootVC = window.rootViewController;
    if ([rootVC isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)rootVC;
    }else if([rootVC isKindOfClass:[UITabBarController class]]){
        UITabBarController *tabarController = [self currentTtabarController];
        UINavigationController *selectedNV = (UINavigationController *)tabarController.selectedViewController;
        if ([selectedNV isKindOfClass:[UINavigationController class]]) {
            return selectedNV;
        }
    }
    
    return nil;
}



@end
