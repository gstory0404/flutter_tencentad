//
//  NativeAd.m
//  flutter_tencentad
//
//  Created by gstory on 2021/12/1.
//

#import "NativeAd.h"
#import "GDTNativeExpressAd.h"
#import "TLogUtil.h"
#import "TUIViewController+getCurrentVC.h"
#import "GDTNativeExpressAdView.h"

#pragma mark - NaitveAdFactory

@implementation NaitveAdFactory{
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
    NativeAd * nativeAd = [[NativeAd alloc] initWithWithFrame:frame viewIdentifier:viewId arguments:args binaryMessenger:_messenger];
    return nativeAd;
}
@end

@interface NativeAd()<GDTNativeExpressAdDelegete>

@property (nonatomic, strong) GDTNativeExpressAd *native;
@property (nonatomic, strong) GDTNativeExpressAdView *nativeView;
@property(nonatomic,strong) UIView *container;
@property(nonatomic,assign) CGRect frame;
@property(nonatomic,assign) NSInteger viewId;
@property(nonatomic,strong) FlutterMethodChannel *channel;
@property(nonatomic,strong) NSString *codeId;
@property(nonatomic,assign) NSInteger viewWidth;
@property(nonatomic,assign) NSInteger viewHeight;
@property(nonatomic,assign) BOOL isBidding;
@end

#pragma mark - NativeAd
@implementation NativeAd

- (instancetype)initWithWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger{
    if ([super init]) {
        NSDictionary *dic = args;
        _frame = frame;
        _viewId = viewId;
        _codeId = dic[@"iosId"];
        _viewWidth =[dic[@"viewWidth"] intValue];
        _viewHeight =[dic[@"viewHeight"] intValue];
        self.isBidding =[dic[@"isBidding"] boolValue];
        NSString* channelName = [NSString stringWithFormat:@"com.gstory.flutter_tencentad/NativeExpressAdView_%lld", viewId];
        _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        [self.channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
            // 竞价成功
            if ([@"biddingSucceeded" isEqualToString:call.method]) {
                NSDictionary *dictionary = @{GDT_M_W_E_COST_PRICE:@([call.arguments[@"expectCostPrice"] intValue]),
                                             GDT_M_W_H_LOSS_PRICE:@([call.arguments[@"highestLossPrice"] intValue])};
                [self.native sendWinNotificationWithInfo:dictionary];
                [_container addSubview:self.nativeView];
                [self.nativeView render];
                //竞价失败
            } else if([@"biddingFail" isEqualToString:call.method]) {
                NSDictionary *dictionary = @{GDT_M_L_WIN_PRICE:@([call.arguments[@"winPrice"] intValue]),
                                             GDT_M_L_LOSS_REASON:@([call.arguments[@"lossReason"] intValue]),
                                             GDT_M_ADNID: call.arguments[@"adnId"]};
                [self.native sendWinNotificationWithInfo:dictionary];
            }
        }];
        _container = [[UIView alloc] initWithFrame:frame];
        [self loadNativeAd];
    }
    return self;
}

- (UIView*)view{
    return  _container;
}

-(void)loadNativeAd{
    [_container removeFromSuperview];
    CGSize size = CGSizeMake(_viewWidth, _viewHeight);
    if(_native == nil){
        _native =[[GDTNativeExpressAd alloc] initWithPlacementId:_codeId adSize:size];
        _native.delegate = self;
    }
    [_native loadAd:1];
}

#pragma mark - 广告请求delegate
/**
 * 拉取原生模板广告成功
 */
- (void)nativeExpressAdSuccessToLoad:(GDTNativeExpressAd *)nativeExpressAd views:(NSArray<__kindof GDTNativeExpressAdView *> *)views{
    [[TLogUtil sharedInstance] print:@"拉取原生模板广告成功"];
    if (views.count) {
        [views enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            self.nativeView = (GDTNativeExpressAdView *)obj;
            self.nativeView.controller = [UIViewController jsd_getCurrentViewController];
            //是否开启竞价
            if(self.isBidding){
                NSDictionary *dictionary = @{@"ecpmLevel":self.nativeView.eCPMLevel == nil ? @"" : self.nativeView.eCPMLevel,@"ecpm":@(self.nativeView.eCPM)};
                [_channel invokeMethod:@"onECPM" arguments:dictionary result:nil];
            }else{
                [_container addSubview:self.nativeView];
                [self.nativeView render];
            }
        }];
    }
}

/**
 * 拉取原生模板广告失败
 */
- (void)nativeExpressAdFailToLoad:(GDTNativeExpressAd *)nativeExpressAd error:(NSError *)error{
    [[TLogUtil sharedInstance] print:(@"拉取原生模板广告失败 %@",error.description)];
    NSDictionary *dictionary = @{@"code":@(-1),@"message":(@"%@",error.description)};
    [_channel invokeMethod:@"onFail" arguments:dictionary result:nil];
}


/**
 * 原生模板广告渲染成功, 此时的 nativeExpressAdView.size.height 根据 size.width 完成了动态更新。
 */
- (void)nativeExpressAdViewRenderSuccess:(GDTNativeExpressAdView *)nativeExpressAdView{
    [[TLogUtil sharedInstance] print:@"原生模板广告渲染成功"];
    NSDictionary *dictionary = @{@"width": @(nativeExpressAdView.frame.size.width),@"height":@(nativeExpressAdView.frame.size.height)};
    [_channel invokeMethod:@"onShow" arguments:dictionary result:nil];
}


/**
 * 原生模板广告渲染失败
 */
- (void)nativeExpressAdViewRenderFail:(GDTNativeExpressAdView *)nativeExpressAdView{
    [[TLogUtil sharedInstance] print:@"原生模板广告渲染失败"];
    NSDictionary *dictionary = @{@"code":@(-1),@"message":@"原生模板广告渲染失败"};
    [_channel invokeMethod:@"onFail" arguments:dictionary result:nil];
}


/**
 * 原生模板广告曝光回调
 */
- (void)nativeExpressAdViewExposure:(GDTNativeExpressAdView *)nativeExpressAdView{
    [[TLogUtil sharedInstance] print:@"原生模板广告曝光回调"];
    [_channel invokeMethod:@"onExpose" arguments:nil result:nil];
}


/**
 * 原生模板广告点击回调
 */
- (void)nativeExpressAdViewClicked:(GDTNativeExpressAdView *)nativeExpressAdView{
    [[TLogUtil sharedInstance] print:@"原生模板广告点击回调"];
    [_channel invokeMethod:@"onClick" arguments:nil result:nil];
}


/**
 * 原生模板广告被关闭
 */
- (void)nativeExpressAdViewClosed:(GDTNativeExpressAdView *)nativeExpressAdView{
    [[TLogUtil sharedInstance] print:@"原生模板广告被关闭"];
    [_channel invokeMethod:@"onClose" arguments:nil result:nil];
}


/**
 * 点击原生模板广告以后即将弹出全屏广告页
 */
- (void)nativeExpressAdViewWillPresentScreen:(GDTNativeExpressAdView *)nativeExpressAdView{
    [[TLogUtil sharedInstance] print:@"点击原生模板广告以后即将弹出全屏广告页"];
}


/**
 * 点击原生模板广告以后弹出全屏广告页
 */
- (void)nativeExpressAdViewDidPresentScreen:(GDTNativeExpressAdView *)nativeExpressAdView{
    [[TLogUtil sharedInstance] print:@"点击原生模板广告以后弹出全屏广告页"];
}


/**
 * 全屏广告页将要关闭
 */
- (void)nativeExpressAdViewWillDismissScreen:(GDTNativeExpressAdView *)nativeExpressAdView{
    [[TLogUtil sharedInstance] print:@"全屏广告页将要关闭"];
}


/**
 * 全屏广告页将要关闭
 */
- (void)nativeExpressAdViewDidDismissScreen:(GDTNativeExpressAdView *)nativeExpressAdView{
    [[TLogUtil sharedInstance] print:@"全屏广告页将要关闭"];
}


/**
 * 详解:当点击应用下载或者广告调用系统程序打开时调用
 */
- (void)nativeExpressAdViewApplicationWillEnterBackground:(GDTNativeExpressAdView *)nativeExpressAdView{
    [[TLogUtil sharedInstance] print:@"详解:当点击应用下载或者广告调用系统程序打开时调用"];
}


/**
 * 原生模板视频广告 player 播放状态更新回调
 */
- (void)nativeExpressAdView:(GDTNativeExpressAdView *)nativeExpressAdView playerStatusChanged:(GDTMediaPlayerStatus)status{
    [[TLogUtil sharedInstance] print:@"原生模板视频广告 player 播放状态更新回调"];
}


/**
 * 原生视频模板详情页 WillPresent 回调
 */
- (void)nativeExpressAdViewWillPresentVideoVC:(GDTNativeExpressAdView *)nativeExpressAdView{
    [[TLogUtil sharedInstance] print:@"原生视频模板详情页 WillPresent 回调"];
}


/**
 * 原生视频模板详情页 DidPresent 回调
 */
- (void)nativeExpressAdViewDidPresentVideoVC:(GDTNativeExpressAdView *)nativeExpressAdView{
    [[TLogUtil sharedInstance] print:@"原生视频模板详情页 DidPresent 回调"];
}


/**
 * 原生视频模板详情页 WillDismiss 回调
 */
- (void)nativeExpressAdViewWillDismissVideoVC:(GDTNativeExpressAdView *)nativeExpressAdView{
    [[TLogUtil sharedInstance] print:@" 原生视频模板详情页 WillDismiss 回调"];
}


/**
 * 原生视频模板详情页 DidDismiss 回调
 */
- (void)nativeExpressAdViewDidDismissVideoVC:(GDTNativeExpressAdView *)nativeExpressAdView;{
    [[TLogUtil sharedInstance] print:@"原生视频模板详情页 DidDismiss 回调"];
}


@end
