//
//  AppDelegate.m
//  SmartWatch
//
//  Created by zhuzhi on 14/11/16.
//  Copyright (c) 2014年 SW. All rights reserved.
//

#import "AppDelegate.h"
#import "SWExerciseRecordsViewController.h"
#import "SWHistoryRecordsViewController.h"
#import "SWProfileViewController.h"
#import "SWSettingViewController.h"
#import "SWShareKit.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[SWShareKit sharedInstance] registerApp];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    _exerciseRecordsViewController = [[SWExerciseRecordsViewController alloc] init];
    [_exerciseRecordsViewController.tabBarItem setTitle:NSLocalizedString(@"运动记录", nil)];
    [_exerciseRecordsViewController.tabBarItem setImage:[UIImage imageNamed:@"first"]];
    
    _historyRecordsViewController = [[SWHistoryRecordsViewController alloc] init];
    [_historyRecordsViewController.tabBarItem setTitle:NSLocalizedString(@"历史记录", nil)];
    [_historyRecordsViewController.tabBarItem setImage:[UIImage imageNamed:@"first"]];
    
    _profileViewController = [[SWProfileViewController alloc] init];
    [_profileViewController.tabBarItem setTitle:NSLocalizedString(@"个人资料", nil)];
    [_profileViewController.tabBarItem setImage:[UIImage imageNamed:@"first"]];
    
    _settingViewController = [[SWSettingViewController alloc] init];
    [_settingViewController.tabBarItem setTitle:NSLocalizedString(@"设置", nil)];
    [_settingViewController.tabBarItem setImage:[UIImage imageNamed:@"first"]];
    
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:_exerciseRecordsViewController];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:_historyRecordsViewController];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:_profileViewController];
    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:_settingViewController];
    
    _tabBarController = [[UITabBarController alloc] init];
    _tabBarController.viewControllers = @[nav1,nav2,nav3,nav4];

    self.window.rootViewController = _tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [[SWShareKit sharedInstance] handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
