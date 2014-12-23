//
//  SWAlarmEditViewController.h
//  SmartWatch
//
//  Created by zhuzhi on 14/12/16.
//
//

#import <UIKit/UIKit.h>

@class SWAlarmInfo;
@class SWSettingModel;

@interface SWAlarmEditViewController : UIViewController

@property (nonatomic,strong) SWAlarmInfo *alarmInfo;
@property (nonatomic,weak) SWSettingModel *model;

@end
