//
//  BannerAd.m
//  flutter_tencentad
//
//  Created by gstory on 2021/12/1.
//

#import "BannerAd.h"
#import "GDTUnifiedBannerView.h"
#import "TLogUtil.h"
#import "TUIViewController+getCurrentVC.h"

#pragma mark - BannerAdFactory

@implementation BannerAdFactory{
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
    BannerAd * bannerAd = [[BannerAd alloc] initWithWithFrame:frame viewIdentifier:viewId arguments:args binaryMessenger:_messenger];
    return bannerAd;
}

@end

@interface BannerAd()<GDTUnifiedBannerViewDelegate>

@property (nonatomic, strong) GDTUnifiedBannerView *banner;
@property(nonatomic,strong) UIView *container;
@property(nonatomic,assign) CGRect frame;
@property(nonatomic,assign) NSInteger viewId;
@property(nonatomic,strong) FlutterMethodChannel *channel;
@property(nonatomic,strong) NSString *codeId;
@property(nonatomic,assign) NSInteger viewWidth;
@property(nonatomic,assign) NSInteger viewHeight;
@property(nonatomic,assign) BOOL isBidding;
@end


@implementation BannerAd

- (instancetype)initWithWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger{
    if ([super init]) {
        NSDictionary *dic = args;
        _frame = frame;
        _viewId = viewId;
        _codeId = dic[@"iosId"];
        _viewWidth =[dic[@"viewWidth"] intValue];
        _viewHeight =[dic[@"viewHeight"] intValue];
        self.isBidding =[dic[@"isBidding"] boolValue];
        NSString* channelName = [NSString stringWithFormat:@"com.gstory.flutter_tencentad/BannerAdView_%lld", viewId];
        _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        [self.channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
            // 竞价成功
            if ([@"biddingSucceeded" isEqualToString:call.method]) {
                NSDictionary *dictionary = @{GDT_M_W_E_COST_PRICE:@([call.arguments[@"expectCostPrice"] intValue]),
                                             GDT_M_W_H_LOSS_PRICE:@([call.arguments[@"highestLossPrice"] intValue])};
                [_banner sendWinNotificationWithInfo:dictionary];
                [_container addSubview:_banner];
                [_channel invokeMethod:@"onShow" arguments:nil result:nil];
                //竞价失败
            } else if([@"biddingFail" isEqualToString:call.method]) {
                NSDictionary *dictionary = @{GDT_M_L_WIN_PRICE:@([call.arguments[@"winPrice"] intValue]),
                                             GDT_M_L_LOSS_REASON:@([call.arguments[@"lossReason"] intValue]),
                                             GDT_M_ADNID: call.arguments[@"adnId"]};
                [self.banner sendWinNotificationWithInfo:dictionary];
            }
        }];
        [self loadBannerAd];
    }
    return self;
}

- (UIView*)view{
    return  _container;
}

-(void)loadBannerAd{
    [_container removeFromSuperview];
    CGRect rect = {CGPointZero, CGSizeMake(_viewWidth, _viewHeight)};
    if(_banner == nil){
        _banner = [[GDTUnifiedBannerView alloc] initWithFrame:rect placementId:_codeId viewController:[UIViewController jsd_getCurrentViewController]];
        _banner.delegate = self;
        _banner.autoSwitchInterval = 30;
    }
    
    [_banner loadAdAndShow];
}

/**
 *  请求广告条数据成功后调用
 *  当接收服务器返回的广告数据成功后调用该函数
 */
- (void)unifiedBannerViewDidLoad:(GDTUnifiedBannerView *)unifiedBannerView{
    [[TLogUtil sharedInstance] print:@"请求广告条数据成功后调用"];
    //    [[TLogUtil sharedInstance] print:self.banner.eCPMLevel];
    //    [[TLogUtil sharedInstance] print:@(self.banner.eCPM)];
    //是否开启竞价
    if(self.isBidding){
        NSDictionary *dictionary = @{@"ecpmLevel":self.banner.eCPMLevel == nil ? @"" : self.banner.eCPMLevel,@"ecpm":@(self.banner.eCPM)};
        [_channel invokeMethod:@"onECPM" arguments:dictionary result:nil];
    }else{
        [_container addSubview:_banner];
        [_channel invokeMethod:@"onShow" arguments:nil result:nil];
    }
}

/**
 *  请求广告条数据失败后调用
 *  当接收服务器返回的广告数据失败后调用该函数
 */
- (void)unifiedBannerViewFailedToLoad:(GDTUnifiedBannerView *)unifiedBannerView error:(NSError *)error{
    [[TLogUtil sharedInstance] print:@"请求广告条数据失败后调用"];
    NSDictionary *dictionary = @{@"code":@(-1),@"message":error.description};
    [_channel invokeMethod:@"onFail" arguments:dictionary result:nil];
}

/**
 *  banner2.0曝光回调
 */
- (void)unifiedBannerViewWillExpose:(GDTUnifiedBannerView *)unifiedBannerView{
    [[TLogUtil sharedInstance] print:@"banner2.0曝光回调"];
    [_channel invokeMethod:@"onExpose" arguments:nil result:nil];
}

/**
 *  banner2.0点击回调
 */
- (void)unifiedBannerViewClicked:(GDTUnifiedBannerView *)unifiedBannerView{
    [[TLogUtil sharedInstance] print:@"banner2.0点击回调"];
    [_channel invokeMethod:@"onClick" arguments:nil result:nil];
}

/**
 *  banner2.0广告点击以后即将弹出全屏广告页
 */
- (void)unifiedBannerViewWillPresentFullScreenModal:(GDTUnifiedBannerView *)unifiedBannerView{
    [[TLogUtil sharedInstance] print:@"banner2.0广告点击以后即将弹出全屏广告页"];
}

/**
 *  banner2.0广告点击以后弹出全屏广告页完毕
 */
- (void)unifiedBannerViewDidPresentFullScreenModal:(GDTUnifiedBannerView *)unifiedBannerView{
    [[TLogUtil sharedInstance] print:@"banner2.0广告点击以后弹出全屏广告页完毕"];
}

/**
 *  全屏广告页即将被关闭
 */
- (void)unifiedBannerViewWillDismissFullScreenModal:(GDTUnifiedBannerView *)unifiedBannerView{
    [[TLogUtil sharedInstance] print:@"全屏广告页即将被关闭"];
}

/**
 *  全屏广告页已经被关闭
 */
- (void)unifiedBannerViewDidDismissFullScreenModal:(GDTUnifiedBannerView *)unifiedBannerView{
    [[TLogUtil sharedInstance] print:@"全屏广告页已经被关闭"];
}

/**
 *  当点击应用下载或者广告调用系统程序打开
 */
- (void)unifiedBannerViewWillLeaveApplication:(GDTUnifiedBannerView *)unifiedBannerView{
    [[TLogUtil sharedInstance] print:@"当点击应用下载或者广告调用系统程序打开"];
}

/**
 *  banner2.0被用户关闭时调用
 *  会立即关闭当前banner广告，若启用轮播，（刷新间隔 - 当前广告已展示时间）后会展示新的广告
 *  若未启用轮播或不需要再展示，需在回调中将unifiedBannerView从父view移除置nil
 */
- (void)unifiedBannerViewWillClose:(GDTUnifiedBannerView *)unifiedBannerView{
    [[TLogUtil sharedInstance] print:@"banner2.0被用户关闭时调用"];
    [_channel invokeMethod:@"onClose" arguments:nil result:nil];
}


@end
