//
//  SplashAd.m
//  flutter_tencentad
//
//  Created by gstory on 2021/12/1.
//

#import "SplashAd.h"
#import "GDTSplashAd.h"
#import "TLogUtil.h"

@implementation SplashAdFactory{
    NSObject<FlutterBinaryMessenger>*_messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger> *)messager{
    self = [super init];
    if (self) {
        _messenger = messager;
    }
    return self;
}

-(NSObject<FlutterMessageCodec> *)createArgsCodec{
    return [FlutterStandardMessageCodec sharedInstance];
}

-(NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args{
    SplashAd * splashAd = [[SplashAd alloc] initWithWithFrame:frame viewIdentifier:viewId arguments:args binaryMessenger:_messenger];
    
    return splashAd;
    
}

@end


@interface SplashAd()<GDTSplashAdDelegate>

@property (nonatomic, strong) GDTSplashAd *splash;
@property(nonatomic,strong) UIView *container;
@property(nonatomic,assign) CGRect frame;
@property(nonatomic,assign) NSInteger viewId;
@property(nonatomic,strong) FlutterMethodChannel *channel;
@property(nonatomic,strong) NSString *codeId;
@property(nonatomic,assign) NSInteger fetchDelay;
@end

@implementation SplashAd

- (instancetype)initWithWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger{
    if ([super init]) {
        NSDictionary *dic = args;
        _frame = frame;
        _viewId = viewId;
        _codeId = dic[@"iosId"];
        _fetchDelay =[dic[@"_fetchDelay"] intValue];
        NSString* channelName = [NSString stringWithFormat:@"com.gstory.flutter_tencentad/SplashAdView_%lld", viewId];
        _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        [self loadSplashAd];
    }
    return self;
}

- (UIView*)view{
    return  _container;
}

-(void)loadSplashAd{
    _splash = [[GDTSplashAd alloc] initWithPlacementId:_codeId];
    _splash.delegate = self;
    _splash.fetchDelay = _fetchDelay;
    [_splash loadFullScreenAd];
}

#pragma mark - 广告请求delegate

/**
 *  开屏广告成功展示
 */
- (void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd{
    [[TLogUtil sharedInstance] print:@"开屏广告成功展示"];
    [_channel invokeMethod:@"onShow" arguments:nil result:nil];
}

/**
 *  开屏广告素材加载成功
 */
- (void)splashAdDidLoad:(GDTSplashAd *)splashAd{
    [[TLogUtil sharedInstance] print:@"开屏广告素材加载成功"];
    if(!splashAd.isAdValid){
        [[TLogUtil sharedInstance] print:@"开屏广告展示失败"];
        NSDictionary *dictionary = @{@"code":@(-1),@"message":@"广告展示失败"};
        [_channel invokeMethod:@"onFail" arguments:dictionary result:nil];
        return;
    }
    [_splash showFullScreenAdInWindow:[UIApplication sharedApplication].keyWindow withLogoImage:nil skipView:nil];
}

/**
 *  开屏广告展示失败
 */
- (void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error{
    [[TLogUtil sharedInstance] print:@"开屏广告展示失败"];
    NSDictionary *dictionary = @{@"code":@(-1),@"message":(@"广告展示失败%@",error.description)};
    [_channel invokeMethod:@"onFail" arguments:dictionary result:nil];
}

/**
 *  应用进入后台时回调
 *  详解: 当点击下载应用时会调用系统程序打开，应用切换到后台
 */
- (void)splashAdApplicationWillEnterBackground:(GDTSplashAd *)splashAd{
    [[TLogUtil sharedInstance] print:@"应用进入后台时回调"];
}

/**
 *  开屏广告曝光回调
 */
- (void)splashAdExposured:(GDTSplashAd *)splashAd{
    [[TLogUtil sharedInstance] print:@" 开屏广告曝光回调"];
    [_channel invokeMethod:@"onExpose" arguments:nil result:nil];
}

/**
 *  开屏广告点击回调
 */
- (void)splashAdClicked:(GDTSplashAd *)splashAd{
    [[TLogUtil sharedInstance] print:@"开屏广告点击回调"];
    [_channel invokeMethod:@"onClick" arguments:nil result:nil];
}

/**
 *  开屏广告将要关闭回调
 */
- (void)splashAdWillClosed:(GDTSplashAd *)splashAd{
    [[TLogUtil sharedInstance] print:@"开屏广告将要关闭回调"];
    [_channel invokeMethod:@"onClose" arguments:nil result:nil];
}

/**
 *  开屏广告关闭回调
 */
- (void)splashAdClosed:(GDTSplashAd *)splashAd{
    [[TLogUtil sharedInstance] print:@"开屏广告关闭回调"];
}

/**
 *  开屏广告点击以后即将弹出全屏广告页
 */
- (void)splashAdWillPresentFullScreenModal:(GDTSplashAd *)splashAd{
    [[TLogUtil sharedInstance] print:@"开屏广告点击以后即将弹出全屏广告页"];
}

/**
 *  开屏广告点击以后弹出全屏广告页
 */
- (void)splashAdDidPresentFullScreenModal:(GDTSplashAd *)splashAd{
    [[TLogUtil sharedInstance] print:@"开屏广告点击以后弹出全屏广告页"];
}

/**
 *  点击以后全屏广告页将要关闭
 */
- (void)splashAdWillDismissFullScreenModal:(GDTSplashAd *)splashAd{
    [[TLogUtil sharedInstance] print:@"点击以后全屏广告页将要关闭"];
}
/**
 *  点击以后全屏广告页已经关闭
 */
- (void)splashAdDidDismissFullScreenModal:(GDTSplashAd *)splashAd{
    [[TLogUtil sharedInstance] print:@" 点击以后全屏广告页已经关闭"];
}

/**
 * 开屏广告剩余时间回调
 */
- (void)splashAdLifeTime:(NSUInteger)time;{
    NSString *timeStr =[NSString stringWithFormat:@"开屏广告剩余时间回调%u",time];
    [[TLogUtil sharedInstance] print:timeStr];
}
@end
