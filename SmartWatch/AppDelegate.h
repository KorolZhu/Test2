//
//  AppDelegate.h
//  SmartWatch
//
//  Created by zhuzhi on 14/11/16.
//  Copyright (c) 2014年 SW. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SWExerciseRecordsViewController;
@class SWHistoryRecordsViewController;
@class SWProfileViewController;
@class SWSettingViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) SWExerciseRecordsViewController *exerciseRecordsViewController;
@property (strong, nonatomic) SWHistoryRecordsViewController *historyRecordsViewController;
@property (strong, nonatomic) SWProfileViewController *profileViewController;
@property (strong, nonatomic) SWSettingViewController *settingViewController;

@end

