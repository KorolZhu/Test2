//
//  SWSettingModel.h
//  SmartWatch
//
//  Created by zhuzhi on 14/12/13.
//
//

#import "SWModel.h"

@class SWAlarmInfo;

@interface SWSettingModel : SWModel

- (void)saveStepsTarget:(NSInteger)steps;

- (void)saveDaylightTimeWithStartHour:(NSInteger)startHour
                              endHour:(NSInteger)endHour;

- (void)addNewAlarm:(SWAlarmInfo *)alarmInfo;
- (void)removeAlarm:(SWAlarmInfo *)alarmInfo;
- (void)updateAlarmInfo;

@end
