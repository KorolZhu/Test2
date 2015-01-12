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

- (float)calorieTarget {
    return 0.53 * [[SWUserInfo shareInstance] height] + 0.58 * [[SWUserInfo shareInstance] weight] + 0.04 * self.stepsTarget - 135;
}

@end
