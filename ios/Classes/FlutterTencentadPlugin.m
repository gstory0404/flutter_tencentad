#import "FlutterTencentadPlugin.h"
#import "FlutterTencentAdEvent.h"
#import "RewardAd.h"
#import "TLogUtil.h"
#import "InsertAd.h"
#import "SplashAd.h"
#import "BannerAd.h"
#import "NativeAd.h"
#import "GDTMobSDK/GDTSDKConfig.h"

@implementation FlutterTencentadPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"flutter_tencentad"
                                     binaryMessenger:[registrar messenger]];
    FlutterTencentadPlugin* instance = [[FlutterTencentadPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    //注册event
    [[FlutterTencentAdEvent sharedInstance]  initEvent:registrar];
    //注册splash
    [registrar registerViewFactory:[[SplashAdFactory alloc] initWithMessenger:registrar.messenger] withId:@"com.gstory.flutter_tencentad/SplashAdView"];
    //注册banner
    [registrar registerViewFactory:[[BannerAdFactory alloc] initWithMessenger:registrar.messenger] withId:@"com.gstory.flutter_tencentad/BannerAdView"];
    //注册native
    [registrar registerViewFactory:[[NaitveAdFactory alloc] initWithMessenger:registrar.messenger] withId:@"com.gstory.flutter_tencentad/NativeExpressAdView"];
    
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"register" isEqualToString:call.method]) {
        NSString *appId = call.arguments[@"iosId"];
        BOOL debug = [call.arguments[@"debug"] boolValue];
        BOOL isInit = [GDTSDKConfig registerAppId:appId];
        NSInteger personalized =  [call.arguments[@"personalized"] intValue];
        NSInteger channelId =  [call.arguments[@"channelId"] intValue];
        //关闭个性化推荐
        [GDTSDKConfig setPersonalizedState:personalized];
        //渠道id
        [GDTSDKConfig setChannel:channelId];
        [[TLogUtil sharedInstance] debug:debug];
        result([NSNumber numberWithBool:isInit]);
    }else if([@"getSDKVersion" isEqualToString:call.method]){
        NSString *version = [GDTSDKConfig sdkVersion];
        result(version);
        //预加载激励广告
    }else if([@"loadRewardVideoAd" isEqualToString:call.method]){
        [[RewardAd sharedInstance] initAd:call.arguments];
        result(@YES);
        //显示激励广告
    }else if([@"showRewardVideoAd" isEqualToString:call.method]){
        [[RewardAd sharedInstance] showAd:call.arguments];
        result(@YES);
        //预加载插屏广告
    }else if([@"loadInterstitialAD" isEqualToString:call.method]){
        [[InsertAd sharedInstance] initAd:call.arguments];
        result(@YES);
        ////展示插屏广告
    }else if([@"showInterstitialAD" isEqualToString:call.method]){
        [[InsertAd sharedInstance] showAd:call.arguments];
        result(@YES);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

@end
