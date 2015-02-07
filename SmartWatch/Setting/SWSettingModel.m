//
//  SWSettingModel.m
//  SmartWatch
//
//  Created by zhuzhi on 14/12/13.
//
//

#import "SWSettingModel.h"
#import "WBDatabaseService.h"
#import "WBSQLBuffer.h"
#import "SWSETTING.h"
#import "SWSettingInfo.h"
#import "SWAlarmInfo.h"

@implementation SWSettingModel

- (instancetype)initWithResponder:(id)responder {
    self = [super initWithResponder:responder];
    if (self) {
        WBSQLBuffer *sqlBuffer = [[WBSQLBuffer alloc] init];
        sqlBuffer.SELECT(@"*").FROM(DBSETTING._tableName);
        WBDatabaseTransaction *transaction = [[WBDatabaseTransaction alloc] initWithSQLBuffer:sqlBuffer];
        [[WBDatabaseService defaultService] readWithTransaction:transaction completionBlock:^{}];
        if (transaction.resultSet.resultArray.count > 0) {
            [[SWSettingInfo shareInstance] loadDataWithDictionary:transaction.resultSet.resultArray.firstObject];
        }
    }
    
    return  self;
}

- (void)saveStepsTarget:(NSInteger)steps {
    [[SWSettingInfo shareInstance] setStepsTarget:steps];
    [[SWSettingInfo shareInstance] updateToDB];
}

- (void)saveSleepTarget:(NSInteger)sleep {
    [[SWSettingInfo shareInstance] setSleepTarget:sleep];
    [[SWSettingInfo shareInstance] updateToDB];

}

- (void)saveDaylightTimeWithStartHour:(NSInteger)startHour endHour:(NSInteger)endHour {
    [[SWSettingInfo shareInstance] setStartHour:startHour];
    [[SWSettingInfo shareInstance] setEndHour:endHour];
    [[SWSettingInfo shareInstance] updateToDB];
}

- (void)addNewAlarm:(SWAlarmInfo *)alarmInfo {
    if (![SWSettingInfo shareInstance].alarmArray) {
        [SWSettingInfo shareInstance].alarmArray = [NSMutableArray array];
    }
    
    [[SWSettingInfo shareInstance] willChangeValueForKey:@"alarmArray"];
    [[[SWSettingInfo shareInstance] alarmArray] removeAllObjects];
    [[[SWSettingInfo shareInstance] alarmArray] addObject:alarmInfo];
    [[SWSettingInfo shareInstance] updateToDB];
    [[SWSettingInfo shareInstance] didChangeValueForKey:@"alarmArray"];
}

- (void)removeAlarm:(SWAlarmInfo *)alarmInfo {
    [[SWSettingInfo shareInstance] willChangeValueForKey:@"alarmArray"];
    [[[SWSettingInfo shareInstance] alarmArray] removeObject:alarmInfo];
    [[SWSettingInfo shareInstance] updateToDB];
    [[SWSettingInfo shareInstance] didChangeValueForKey:@"alarmArray"];
}

- (void)updateAlarmInfo {
    [[SWSettingInfo shareInstance] willChangeValueForKey:@"alarmArray"];
    [[SWSettingInfo shareInstance] updateToDB];
    [[SWSettingInfo shareInstance] didChangeValueForKey:@"alarmArray"];
}

- (void)savePreventLost:(NSInteger)state {
    [SWSettingInfo shareInstance].preventLost = state;
    [[SWSettingInfo shareInstance] updateToDB];
}

@end
