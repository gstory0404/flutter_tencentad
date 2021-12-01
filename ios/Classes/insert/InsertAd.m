//
//  InsertAd.m
//  flutter_tencentad
//
//  Created by gstory on 2021/12/1.
//

#import "InsertAd.h"
#import "GDTUnifiedInterstitialAd.h"
#import "LogUtil.h"
#import "UIViewController+getCurrentVC.h"
#import "FlutterTencentAdEvent.h"


@interface InsertAd()<GDTUnifiedInterstitialAdDelegate>

@property(nonatomic,strong) GDTUnifiedInterstitialAd *interstitialAd;
@property(nonatomic,strong) NSString *codeId;
@property(nonatomic,assign) BOOL isFullScreen;
@property(nonatomic,strong) UIViewController *currentController;

@end



@implementation InsertAd

+ (instancetype)sharedInstance{
    static InsertAd *myInstance = nil;
    if(myInstance == nil){
        myInstance = [[InsertAd alloc]init];
    }
    return myInstance;
}

//预加载激励广告
-(void)initAd:(NSDictionary*)arguments{
    NSDictionary *dic = arguments;
    _codeId = dic[@"iosId"];
    _isFullScreen = [dic[@"isFullScreen"] boolValue];
    _interstitialAd = [[GDTUnifiedInterstitialAd alloc] initWithPlacementId:_codeId];
    _interstitialAd.delegate = self;
    _interstitialAd.videoMuted = false;
    _isFullScreen ?  [_interstitialAd loadFullScreenAd] : [_interstitialAd loadAd];
}

//展示广告
- (void)showAd{
    if(_isFullScreen){
        [_interstitialAd presentFullScreenAdFromRootViewController:[UIViewController jsd_getCurrentViewController]];
    }else{
        [_interstitialAd presentAdFromRootViewController:[UIViewController jsd_getCurrentViewController]];
    }
}


#pragma mark - 广告请求delegate

/**
 *  插屏2.0广告预加载成功回调
 *  当接收服务器返回的广告数据成功且预加载后调用该函数
 */
- (void)unifiedInterstitialSuccessToLoadAd:(GDTUnifiedInterstitialAd *)unifiedInterstitial{
    [[LogUtil sharedInstance] print:@"插屏2.0广告预加载成功回调"];
}

/**
 *  插屏2.0广告预加载失败回调
 *  当接收服务器返回的广告数据失败后调用该函数
 */
- (void)unifiedInterstitialFailToLoadAd:(GDTUnifiedInterstitialAd *)unifiedInterstitial error:(NSError *)error{
    [[LogUtil sharedInstance] print:(@"插屏2.0广告预加载失败回调 %@",error.userInfo)];
    NSDictionary *dictionary = @{@"adType":@"interactAd",@"onAdMethod":@"onFail",@"code":@(-1),@"message":(@"%@",error.userInfo)};
    [[FlutterTencentAdEvent sharedInstance] sentEvent:dictionary];
}

/**
 *  插屏2.0广告视频缓存完成
 */
- (void)unifiedInterstitialDidDownloadVideo:(GDTUnifiedInterstitialAd *)unifiedInterstitial{
    [[LogUtil sharedInstance] print:@"插屏2.0广告视频缓存完成"];
}

/**
 *  插屏2.0广告渲染成功
 *  建议在此回调后展示广告
 */
- (void)unifiedInterstitialRenderSuccess:(GDTUnifiedInterstitialAd *)unifiedInterstitial{
    [[LogUtil sharedInstance] print:@"插屏2.0广告渲染成功"];
    NSDictionary *dictionary = @{@"adType":@"interactAd",@"onAdMethod":@"onReady"};
    [[FlutterTencentAdEvent sharedInstance] sentEvent:dictionary];
}

/**
 *  插屏2.0广告渲染失败
 */
- (void)unifiedInterstitialRenderFail:(GDTUnifiedInterstitialAd *)unifiedInterstitial error:(NSError *)error{
    [[LogUtil sharedInstance] print:(@"插屏2.0广告渲染失败 %@",error.userInfo)];
    NSDictionary *dictionary = @{@"adType":@"interactAd",@"onAdMethod":@"onFail",@"code":@(-1),@"message":(@"插屏2.0广告渲染失败 %@",error.userInfo)};
    [[FlutterTencentAdEvent sharedInstance] sentEvent:dictionary];
}

/**
 *  插屏2.0广告将要展示回调
 *  插屏2.0广告即将展示回调该函数
 */
- (void)unifiedInterstitialWillPresentScreen:(GDTUnifiedInterstitialAd *)unifiedInterstitial{
    [[LogUtil sharedInstance] print:@"插屏2.0广告将要展示回调"];
    NSDictionary *dictionary = @{@"adType":@"interactAd",@"onAdMethod":@"onShow"};
    [[FlutterTencentAdEvent sharedInstance] sentEvent:dictionary];
}

/**
 *  插屏2.0广告视图展示成功回调
 *  插屏2.0广告展示成功回调该函数
 */
- (void)unifiedInterstitialDidPresentScreen:(GDTUnifiedInterstitialAd *)unifiedInterstitial{
    [[LogUtil sharedInstance] print:@"插屏2.0广告视图展示成功回调"];
}

/**
 *  插屏2.0广告视图展示失败回调
 *  插屏2.0广告展示失败回调该函数
 */
- (void)unifiedInterstitialFailToPresent:(GDTUnifiedInterstitialAd *)unifiedInterstitial error:(NSError *)error{
    [[LogUtil sharedInstance] print:(@"插屏2.0广告视图展示失败回调 %@",error.userInfo)];
    NSDictionary *dictionary = @{@"adType":@"interactAd",@"onAdMethod":@"onFail",@"code":@(-1),@"message":(@"%@",error.userInfo)};
    [[FlutterTencentAdEvent sharedInstance] sentEvent:dictionary];
}

/**
 *  插屏2.0广告展示结束回调
 *  插屏2.0广告展示结束回调该函数
 */
- (void)unifiedInterstitialDidDismissScreen:(GDTUnifiedInterstitialAd *)unifiedInterstitial{
    [[LogUtil sharedInstance] print:@"插屏2.0广告展示结束回调"];
    NSDictionary *dictionary = @{@"adType":@"interactAd",@"onAdMethod":@"onClose"};
    [[FlutterTencentAdEvent sharedInstance] sentEvent:dictionary];
}

/**
 *  当点击下载应用时会调用系统程序打开其它App或者Appstore时回调
 */
- (void)unifiedInterstitialWillLeaveApplication:(GDTUnifiedInterstitialAd *)unifiedInterstitial{
    [[LogUtil sharedInstance] print:@"插屏2.0点击下载应用时会调用系统程序打开其它App或者Appstore时回调"];
}

/**
 *  插屏2.0广告曝光回调
 */
- (void)unifiedInterstitialWillExposure:(GDTUnifiedInterstitialAd *)unifiedInterstitial{
    [[LogUtil sharedInstance] print:@"插屏2.0广告曝光回调"];
    NSDictionary *dictionary = @{@"adType":@"interactAd",@"onAdMethod":@"onExpose"};
    [[FlutterTencentAdEvent sharedInstance] sentEvent:dictionary];
}

/**
 *  插屏2.0广告点击回调
 */
- (void)unifiedInterstitialClicked:(GDTUnifiedInterstitialAd *)unifiedInterstitial{
    [[LogUtil sharedInstance] print:@"插屏2.0广告点击回调"];
    NSDictionary *dictionary = @{@"adType":@"interactAd",@"onAdMethod":@"onClick"};
    [[FlutterTencentAdEvent sharedInstance] sentEvent:dictionary];
}

/**
 *  点击插屏2.0广告以后即将弹出全屏广告页
 */
- (void)unifiedInterstitialAdWillPresentFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial{
    [[LogUtil sharedInstance] print:@"点击插屏2.0广告以后即将弹出全屏广告页"];
}

/**
 *  点击插屏2.0广告以后弹出全屏广告页
 */
- (void)unifiedInterstitialAdDidPresentFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial{
    [[LogUtil sharedInstance] print:@"点击插屏2.0广告以后弹出全屏广告页"];
}

/**
 *  全屏广告页将要关闭
 */
- (void)unifiedInterstitialAdWillDismissFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial{
    [[LogUtil sharedInstance] print:@"插屏2.0全屏广告页将要关闭"];
}

/**
 *  全屏广告页被关闭
 */
- (void)unifiedInterstitialAdDidDismissFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial{
    [[LogUtil sharedInstance] print:@"插屏2.0全屏广告页将要关闭"];
}

/**
 * 插屏2.0视频广告 player 播放状态更新回调
 */
- (void)unifiedInterstitialAd:(GDTUnifiedInterstitialAd *)unifiedInterstitial playerStatusChanged:(GDTMediaPlayerStatus)status{
    [[LogUtil sharedInstance] print:@"插屏2.0视频广告 player 播放状态更新回调"];
}

/**
 * 插屏2.0视频广告详情页 WillPresent 回调
 */
- (void)unifiedInterstitialAdViewWillPresentVideoVC:(GDTUnifiedInterstitialAd *)unifiedInterstitial{
    [[LogUtil sharedInstance] print:@"插屏2.0视频广告详情页 WillPresent 回调"];
}

/**
 * 插屏2.0视频广告详情页 DidPresent 回调
 */
- (void)unifiedInterstitialAdViewDidPresentVideoVC:(GDTUnifiedInterstitialAd *)unifiedInterstitial{
    [[LogUtil sharedInstance] print:@"插屏2.0视频广告详情页 DidPresent 回调"];
}

/**
 * 插屏2.0视频广告详情页 WillDismiss 回调
 */
- (void)unifiedInterstitialAdViewWillDismissVideoVC:(GDTUnifiedInterstitialAd *)unifiedInterstitial{
    [[LogUtil sharedInstance] print:@"插屏2.0视频广告详情页 WillDismiss 回调"];
}

/**
 * 插屏2.0视频广告详情页 DidDismiss 回调
 */
- (void)unifiedInterstitialAdViewDidDismissVideoVC:(GDTUnifiedInterstitialAd *)unifiedInterstitial{
    [[LogUtil sharedInstance] print:@"插屏2.0视频广告详情页 DidDismiss 回调"];
}

/**
 * 插屏激励广告视频播放达到激励条件回调（只有插屏激励广告位才会有此回调）
 
 @param unifiedInterstitial GDTUnifiedInterstitialAd 实例
 @param info 包含此次广告行为的一些信息，例如 @{@"GDT_TRANS_ID":@"930f1fc8ac59983bbdf4548ee40ac353"}, 通过@“GDT_TRANS_ID”可获取此次广告行为的交易id
 */
- (void)unifiedInterstitialAdDidRewardEffective:(GDTUnifiedInterstitialAd *)unifiedInterstitial info:(NSDictionary *)info{
    [[LogUtil sharedInstance] print:@"插屏激励广告视频播放达到激励条件回调（只有插屏激励广告位才会有此回调）"];
}


@end
