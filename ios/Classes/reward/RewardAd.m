//
//  RewardAd.m
//  flutter_tencentad
//
//  Created by gstory on 2021/12/1.
//

#import "RewardAd.h"
#import "GDTRewardVideoAd.h"
#import "FlutterTencentAdEvent.h"
#import "TLogUtil.h"
#import "UIViewController+getCurrentVC.h"

@interface RewardAd()<GDTRewardedVideoAdDelegate>

@property(nonatomic,strong) GDTRewardVideoAd *reward;
@property(nonatomic,strong) NSString *codeId;
@property(nonatomic,strong) NSString *rewardName;
@property(nonatomic,strong) NSString *rewardAmount;
@property(nonatomic,strong) NSString *userID;
@property(nonatomic,strong) NSString *customData;

@end

@implementation RewardAd

+ (instancetype)sharedInstance{
    static RewardAd *myInstance = nil;
    if(myInstance == nil){
        myInstance = [[RewardAd alloc]init];
    }
    return myInstance;
}

//预加载激励广告
-(void)initAd:(NSDictionary*)arguments{
    NSDictionary *dic = arguments;
    _codeId = dic[@"iosId"];
    _rewardName = dic[@"rewardName"];
    _rewardAmount = dic[@"rewardAmount"];
    _userID =dic[@"userID"];
    _customData = dic[@"customData"];
    _reward = [[GDTRewardVideoAd alloc] initWithPlacementId:_codeId];
    _reward.delegate = self;
    _reward.videoMuted = false;
    GDTServerSideVerificationOptions  *options = [[GDTServerSideVerificationOptions alloc] init];
    options.userIdentifier = _userID;
    options.customRewardString = _customData;
    _reward.serverSideVerificationOptions = options;
    [_reward loadAd];
}

//展示广告
-(void)showAd{
    if (_reward.expiredTimestamp <= [[NSDate date] timeIntervalSince1970]) {
        [[TLogUtil sharedInstance] print:(@"广告已过期，请重新拉取")];
        NSDictionary *dictionary = @{@"adType":@"rewardAd",@"onAdMethod":@"onFail",@"code":@(-1),@"message":@"广告已过期，请重新拉取"};
        [[FlutterTencentAdEvent sharedInstance] sentEvent:dictionary];
        return;
    }
    if (!_reward.isAdValid) {
        [[TLogUtil sharedInstance] print:(@"广告失效，请重新拉取")];
        NSDictionary *dictionary = @{@"adType":@"rewardAd",@"onAdMethod":@"onFail",@"code":@(-1),@"message":@"广告失效，请重新拉取"};
        [[FlutterTencentAdEvent sharedInstance] sentEvent:dictionary];
        return;
    }
    [_reward showAdFromRootViewController:[UIViewController jsd_getCurrentViewController]];
}

#pragma mark - 广告请求delegate

/**
 广告数据加载成功回调

 @param rewardedVideoAd GDTRewardVideoAd 实例
 */
- (void)gdt_rewardVideoAdDidLoad:(GDTRewardVideoAd *)rewardedVideoAd{
    [[TLogUtil sharedInstance] print:(@"激励广告数据加载成功")];
    NSDictionary *dictionary = @{@"adType":@"rewardAd",@"onAdMethod":@"onReady"};
    [[FlutterTencentAdEvent sharedInstance] sentEvent:dictionary];
}

/**
 视频数据下载成功回调，已经下载过的视频会直接回调

 @param rewardedVideoAd GDTRewardVideoAd 实例
 */
- (void)gdt_rewardVideoAdVideoDidLoad:(GDTRewardVideoAd *)rewardedVideoAd{
    [[TLogUtil sharedInstance] print:(@"激励广告视频数据下载成功")];
}

/**
 视频播放页即将展示回调

 @param rewardedVideoAd GDTRewardVideoAd 实例
 */
- (void)gdt_rewardVideoAdWillVisible:(GDTRewardVideoAd *)rewardedVideoAd{
    [[TLogUtil sharedInstance] print:(@"激励广告视频播放页即将展示回调")];
}

/**
 视频广告曝光回调

 @param rewardedVideoAd GDTRewardVideoAd 实例
 */
- (void)gdt_rewardVideoAdDidExposed:(GDTRewardVideoAd *)rewardedVideoAd{
    [[TLogUtil sharedInstance] print:(@"激励广告曝光")];
    NSDictionary *dictionary = @{@"adType":@"rewardAd",@"onAdMethod":@"onExpose"};
    [[FlutterTencentAdEvent sharedInstance] sentEvent:dictionary];
}

/**
 视频播放页关闭回调

 @param rewardedVideoAd GDTRewardVideoAd 实例
 */
- (void)gdt_rewardVideoAdDidClose:(GDTRewardVideoAd *)rewardedVideoAd{
    [[TLogUtil sharedInstance] print:(@"激励广告关闭")];
    NSDictionary *dictionary = @{@"adType":@"rewardAd",@"onAdMethod":@"onClose"};
    [[FlutterTencentAdEvent sharedInstance] sentEvent:dictionary];
}

/**
 视频广告信息点击回调

 @param rewardedVideoAd GDTRewardVideoAd 实例
 */
- (void)gdt_rewardVideoAdDidClicked:(GDTRewardVideoAd *)rewardedVideoAd{
    [[TLogUtil sharedInstance] print:(@"激励广告点击")];
    NSDictionary *dictionary = @{@"adType":@"rewardAd",@"onAdMethod":@"onClick"};
    [[FlutterTencentAdEvent sharedInstance] sentEvent:dictionary];
}

/**
 视频广告各种错误信息回调

 @param rewardedVideoAd GDTRewardVideoAd 实例
 @param error 具体错误信息
 */
- (void)gdt_rewardVideoAd:(GDTRewardVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error{
    [[TLogUtil sharedInstance] print:(@"激励广告错误,%@",error.userInfo)];
    NSInteger code = error.code;
    NSString *message = error.userInfo;
    NSDictionary *dictionary = @{@"adType":@"rewardAd",@"onAdMethod":@"onFail",@"code":@(code),@"message":message};
    [[FlutterTencentAdEvent sharedInstance] sentEvent:dictionary];
}

/**
 视频广告播放达到激励条件回调

 @param rewardedVideoAd GDTRewardVideoAd 实例
 */
- (void)gdt_rewardVideoAdDidRewardEffective:(GDTRewardVideoAd *)rewardedVideoAd GDT_DEPRECATED_MSG_ATTRIBUTE("接口即将废弃，请使用 gdt_rewardVideoAdDidRewardEffective:info:"){
   
}


/**
 视频广告播放达到激励条件回调

 @param rewardedVideoAd GDTRewardVideoAd 实例
 @param info 包含此次广告行为的一些信息，例如 @{@"GDT_TRANS_ID":@"930f1fc8ac59983bbdf4548ee40ac353"}, 通过@“GDT_TRANS_ID”可获取此次广告行为的交易id
 */
- (void)gdt_rewardVideoAdDidRewardEffective:(GDTRewardVideoAd *)rewardedVideoAd info:(NSDictionary *)info{
    [[TLogUtil sharedInstance] print:(@"激励广告视频广告播放达到激励条件")];
    NSString *transId = info[@"GDT_TRANS_ID"];
    NSDictionary *dictionary = @{@"adType":@"rewardAd",@"onAdMethod":@"onVerify",@"transId":transId,@"rewardAmount":_rewardAmount,@"rewardName":_rewardName};
    [[FlutterTencentAdEvent sharedInstance] sentEvent:dictionary];
}

/**
 视频广告视频播放完成

 @param rewardedVideoAd GDTRewardVideoAd 实例
 */
- (void)gdt_rewardVideoAdDidPlayFinish:(GDTRewardVideoAd *)rewardedVideoAd{
    [[TLogUtil sharedInstance] print:(@"激励广告视频广告视频播放完成")];
    NSDictionary *dictionary = @{@"adType":@"rewardAd",@"onAdMethod":@"onFinish"};
    [[FlutterTencentAdEvent sharedInstance] sentEvent:dictionary];
}

@end
