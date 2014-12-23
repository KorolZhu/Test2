//
//  SWSettingInfo.m
//  SmartWatch
//
//  Created by zhuzhi on 14/12/13.
//
//

#import "SWSettingInfo.h"
#import "SWSETTING.h"
#import "SWUserInfo.h"
#import "SWAlarmInfo.h"

@implementation SWSettingInfo

SW_DEF_SINGLETON(SWSettingInfo, shareInstance);

- (void)loadDataWithDictionary:(NSDictionary *)dictionary {
    self.stepsTarget = [dictionary intForKey:DBSETTING._TARGETSTEP];
    self.startHour = [dictionary intForKey:DBSETTING._DAYTIMESTARTHOUR];
    self.endHour = [dictionary intForKey:DBSETTING._DAYTIMEENDTHOUR];
    NSString *string = [dictionary stringForKey:DBSETTING._ALARM];
    NSArray *array = [string jsonValue];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        SWAlarmInfo *info = [[SWAlarmInfo alloc] initWithDictionary:dict];
        [mutableArray addObject:info];
    }
    self.alarmArray = mutableArray;
}

- (float)calorieTarget {
    return 0.53 * [[SWUserInfo shareInstance] height] + 0.58 * [[SWUserInfo shareInstance] weight] + 0.04 * self.stepsTarget - 135;
}

@end
