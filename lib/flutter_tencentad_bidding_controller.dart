part of 'flutter_tencentad.dart';

/// @Author: gstory
/// @CreateDate: 2022/9/2 14:39
/// @Email gstory0404@gmail.com
/// @Description: 优量汇竞价

class FlutterTencentAdBiddingController {
  late MethodChannel? _methodChannel;

  init(MethodChannel? method) {
    _methodChannel = method;
  }

  //回传竞价结果
  void biddingResult(FlutterTencentBiddingResult result){
    //竞价成功
    if(result.isSuccess){
      _methodChannel?.invokeMethod('biddingSucceeded', {
        'expectCostPrice': result.expectCostPrice,
        'highestLossPrice': result.highestLossPrice,
      });
      //竞价失败
    }else{
      _methodChannel?.invokeMethod('biddingSucceeded', {
        'winPrice': result.winPrice,
        'lossReason': result.lossReason,
        'adnId': result.adnId,
      });
    }
  }
}

class FlutterTencentBiddingResult {
  int? expectCostPrice;
  int? highestLossPrice;
  int? winPrice;
  int? lossReason;
  String? adnId;

  bool isSuccess = true;

  FlutterTencentBiddingResult();

  ///竞价成功
  ///
  ///[expectCostPrice] 竞胜出价，类型为Integer
  ///
  ///[highestLossPrice] 最大竞败方出价，类型为Integer
  FlutterTencentBiddingResult success(int expectCostPrice,int highestLossPrice) {
    this.isSuccess = true;
    this.expectCostPrice = expectCostPrice;
    this.highestLossPrice = highestLossPrice;
    return this;
  }

  ///竞价失败
  ///
  /// [winPrice] 本次竞胜方出价（单位：分），类型为Integer。选填
  ///
  /// [lossReason] 优量汇广告竞败原因，类型为Integer。必填 [FlutterTencentAdBiddingLossReason]
  ///
  /// [adnId] 本次竞胜方渠道ID，类型为Integer。必填。 [FlutterTencentAdADNID]
  FlutterTencentBiddingResult fail(int winPrice, int lossReason, String adnId) {
    this.isSuccess = false;
    this.winPrice = winPrice;
    this.lossReason = lossReason;
    this.adnId = adnId;
    return this;
  }

  FlutterTencentBiddingResult.fromJson(Map<String, dynamic> json) {
    expectCostPrice = json['expectCostPrice'];
    highestLossPrice = json['highestLossPrice'];
    winPrice = json['winPrice'];
    lossReason = json['lossReason'];
    adnId = json['adnId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    data['expectCostPrice'] = this.expectCostPrice;
    data['highestLossPrice'] = this.highestLossPrice;
    data['winPrice'] = this.winPrice;
    data['lossReason'] = this.lossReason;
    data['adnId'] = this.adnId;
    return data;
  }
}
