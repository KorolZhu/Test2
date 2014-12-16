//
//  SWAlarmCell.h
//  SmartWatch
//
//  Created by zhuzhi on 14/12/16.
//
//

#import <UIKit/UIKit.h>

@class SWAlarmInfo;

@interface SWAlarmCell : UITableViewCell

@property (nonatomic,strong) SWAlarmInfo *alarmInfo;

@property (nonatomic,strong) UISwitch *stateSwitch;

@end
