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
#import "WBMutableSQLBuffer.h"
#import "WBSQLBuffer.h"
#import "WBDatabaseTransaction.h"
#import "WBDatabaseService.h"

@implementation SWSettingInfo

SW_DEF_SINGLETON(SWSettingInfo, shareInstance);

- (void)loadDataWithDictionary:(NSDictionary *)dictionary {
    self.stepsTarget = [dictionary intForKey:DBSETTING._TARGETSTEP];
    self.sleepTarget = [dictionary floatForKey:DBSETTING._TARGETSLEEP];
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
	self.lostMeters = [dictionary intForKey:DBSETTING._LOSTMETERS];
    self.preventLost = [dictionary intForKey:DBSETTING._PREVENTLOST];
}

- (void)updateToDB {
    WBMutableSQLBuffer *mutableSqlBuffer = [[WBMutableSQLBuffer alloc] init];
    
    WBSQLBuffer *deleteSqlbuffer = [[WBSQLBuffer alloc] init];
    deleteSqlbuffer.DELELTE(DBSETTING._tableName).WHERE([NSString stringWithFormat:@"1=1"]);
    [mutableSqlBuffer addBuffer:deleteSqlbuffer];
    
    WBSQLBuffer *sqlBuffer = [[WBSQLBuffer alloc] init];
    sqlBuffer.INSERT(DBSETTING._tableName);
    sqlBuffer.SET(DBSETTING._TARGETSTEP,@([[SWSettingInfo shareInstance] stepsTarget]));
    sqlBuffer.SET(DBSETTING._TARGETSLEEP,@([[SWSettingInfo shareInstance] sleepTarget]));
    sqlBuffer.SET(DBSETTING._DAYTIMESTARTHOUR,@([SWSettingInfo shareInstance].startHour));
    sqlBuffer.SET(DBSETTING._DAYTIMEENDTHOUR,@([SWSettingInfo shareInstance].endHour));
    
    NSMutableArray *array = [NSMutableArray array];
    for (SWAlarmInfo *info in [[SWSettingInfo shareInstance] alarmArray]) {
        NSDictionary *dict = @{ALARMHOUR: @(info.hour), ALARMMINUTE: @(info.minute), ALARMSTATE : @(info.state), ALARMREPEAT: @(info.repeat)};
        [array addObject:dict];
    }
    sqlBuffer.SET(DBSETTING._ALARM, [array jsonString]);
    sqlBuffer.SET(DBSETTING._PREVENTLOST,@([SWSettingInfo shareInstance].preventLost));
    
    [mutableSqlBuffer addBuffer:sqlBuffer];
    
    WBDatabaseTransaction *transaction = [[WBDatabaseTransaction alloc] initWithMutalbeSQLBuffer:mutableSqlBuffer];
    
    [[WBDatabaseService defaultService] writeWithTransaction:transaction completionBlock:^{
    }];
}

- (NSInteger)calorieTarget {
    NSInteger height = [[SWUserInfo shareInstance] height];
    if (height <= 0) {
        height = [[SWUserInfo shareInstance] defaultHeight];
    }
    
    NSInteger weight = [[SWUserInfo shareInstance] weight];
    if (weight <= 0) {
        weight = [[SWUserInfo shareInstance] defaultWeight];
    }
    
    NSInteger steps = self.stepsTarget;
    if (steps <= 0) {
        steps = [self defaultStepsTarget];
    }
    
	NSInteger calorie = (NSInteger)(0.53 * height + 0.58 * weight + 0.04 * steps - 135);
	if (calorie <= 0) {
		calorie = 80;
	}
	
    return calorie;
}

- (NSInteger)defaultStepsTarget {
    return 2500;
}

- (NSInteger)defaultCalorieTarget {
    return (NSInteger)(0.53 * [[SWUserInfo shareInstance] defaultHeight] + 0.58 * [[SWUserInfo shareInstance] defaultWeight] + 0.04 * [self defaultStepsTarget] - 135.0f);
}

- (NSInteger)defaultSleepTarget {
    return 7;
}

@end
