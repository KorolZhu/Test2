//
//  SWSettingModel.h
//  SmartWatch
//
//  Created by zhuzhi on 14/12/13.
//
//

#import "SWModel.h"

@interface SWSettingModel : SWModel

- (void)saveStepsTarget:(NSInteger)steps;

- (void)saveDaylightTimeWithStartHour:(NSInteger)startHour
                              endHour:(NSInteger)endHour;

@end
