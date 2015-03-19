//
//  BuglySDKHelper.m
//  BuglySDKDemo
//
//  Created by mqq on 15/1/26.
//  Copyright (c) 2015年 Tencent. All rights reserved.
//

#import "BuglySDKHelper.h"

#define BUGLY_APP_ID @"900002363"

@implementation BuglySDKHelper

+ (void)initSDK {

    // --- init for Bugly.framework ---
    // 调试阶段开启sdk日志打印, 发布阶段请务必关闭
    [[CrashReporter sharedInstance] enableLog:YES];
    
    // 如果你的App有对应的发布渠道(如AppStore),你可以通过此接口设置, 默认值为unknown,
    [[CrashReporter sharedInstance] setChannel:@"bugly_test"];
    
    // 如果你有自定义标识用户的ID, 你可以通过此接口设置, 默认值为10000
//	NSString *userId = [[HTCache sharedCache] stringForKey:HT_UserId];
//	if (userId.length > 0) {
//		[[CrashReporter sharedInstance] setUserId:userId];
//	}
//	NSString *email = [[HTCache sharedCache] secretStringForKey:HT_Email];
//	if (email.length > 0) {
//		[[CrashReporter sharedInstance] setUserData:email value:HT_Email];
//	}
	
	//设置异常合并上报，当天同一个异常只会上报第一次，后续合并保存并在第二天才会上报
//	[[CrashReporter sharedInstance] setExpMergeUpload:YES];

    // 使用AppID初始化SDK
    [[CrashReporter sharedInstance] installWithAppkey:BUGLY_APP_ID];
    // --- end ---
}

/**
 *    @brief  崩溃发生时的回调处理函数, 开发者可以在这里获取崩溃信息, 并为崩溃信息添加附带信息上报
 *
 *    @return value could be ignore
 */
static int _exception_callback_handler_test_() {
    NSLog(@"enter the exception callback");
    NSException *exception = [[CrashReporter sharedInstance] getCurrentException];
    if (exception) {
        NSLog(@"sdk catch an NSException: \n%@:%@\nRetrace stack:\n%@", [exception name], [exception reason], [exception callStackSymbols]);
    } else {
        NSString *type  = [[CrashReporter sharedInstance] getCrashType];
        NSString *stack = [[CrashReporter sharedInstance] getCrashStack];
        NSLog(@"sdk catch an exception: \nType:%@ \nTrace stack:\n%@", type, stack);

        NSString *crashLog = [[CrashReporter sharedInstance] getCrashLog];
        if (crashLog) {
            NSLog(@"sdk save a crash log: \n%@", crashLog);
        }
    }

//    // 你可以通过此接口添加附带信息同崩溃信息一起上报, 以key-value形式组装
//    [[CrashReporter sharedInstance] setUserData:@"测试用户" value:[NSString stringWithFormat:@"Bugly用户测试:%@", BUGLY_APP_ID]];
//
//    // 你可以通过次接口添加附件信息同崩溃信息一起上报
//    [[CrashReporter sharedInstance] setAttachLog:@"使用Bugly进行崩溃问题跟踪定位"];

    return 1;
};

+ (void)setExceptionCallback:(exp_callback)_callback {
    if (_callback <= 0) {
        NSLog(@"please set valid callback method %lli", (long long)_callback);

#if DEBUG == 1
        NSLog(@"set callback method for test");
        exp_call_back_func = &_exception_callback_handler_test_;
#endif
    } else {
        exp_call_back_func = _callback;
    }

    NSLog(@"sdk has set callback method: %lli", (long long)exp_call_back_func);
}

+ (void)testNSException {
	NSLog(@"it will throw an NSException ");
	NSArray * array = @[];
	NSLog(@"the element is %@", array[1]);
}

+ (void)testSignalException {
	
}

@end