//
//  FlutterTencentAdEvent.m
//  flutter_tencentad
//
//  Created by gstory on 2021/12/1.
//

#import "FlutterTencentAdEvent.h"
#import <Flutter/Flutter.h>

@interface FlutterTencentAdEvent()<FlutterStreamHandler>
@property(nonatomic,strong) FlutterEventSink eventSink;
@end

@implementation FlutterTencentAdEvent

+ (instancetype)sharedInstance{
    static FlutterTencentAdEvent *myInstance = nil;
    if(myInstance == nil){
        myInstance = [[FlutterTencentAdEvent alloc]init];
    }
    return myInstance;
}


- (void)initEvent:(NSObject<FlutterPluginRegistrar>*)registrar{
    FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:@"com.gstory.flutter_tencentad/adevent"   binaryMessenger:[registrar messenger]];
    [eventChannel setStreamHandler:self];
}

-(void)sentEvent:(NSDictionary*)arguments{
    self.eventSink(arguments);
}



#pragma mark - FlutterStreamHandler
- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    self.eventSink = nil;
    return nil;
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
    self.eventSink = events;
    return nil;
}@end
