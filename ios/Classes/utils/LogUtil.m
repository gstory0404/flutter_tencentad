//
//  LogUtil.m
//  flutter_tencentad
//
//  Created by 郭维佳 on 2021/12/1.
//

#import <Foundation/Foundation.h>
#import "LogUtil.h"

@interface LogUtil()
@property(nonatomic,assign) BOOL isDebug;
@end


@implementation LogUtil

+ (instancetype)sharedInstance{
    static LogUtil *myInstance = nil;
    if(myInstance == nil){
        myInstance = [[LogUtil alloc]init];
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
