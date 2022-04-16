//
//  LogUtil.m
//  flutter_tencentad
//
//  Created by gstory on 2021/12/1.
//

#import <Foundation/Foundation.h>
#import "TLogUtil.h"

@interface TLogUtil()
@property(nonatomic,assign) BOOL isDebug;
@end


@implementation TLogUtil

+ (instancetype)sharedInstance{
    static TLogUtil *myInstance = nil;
    if(myInstance == nil){
        myInstance = [[TLogUtil alloc]init];
    }
    return myInstance;
}

- (void)debug:(BOOL)isDebug{
    _isDebug = isDebug;
}

- (void)print:(NSString *)message{
    if(_isDebug){
        GLog(@"%@", message);
    }
}

@end
