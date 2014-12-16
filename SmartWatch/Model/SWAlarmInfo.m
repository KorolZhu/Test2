//
//  SWAlarmInfo.m
//  SmartWatch
//
//  Created by zhuzhi on 14/12/16.
//
//

#import "SWAlarmInfo.h"

@implementation SWAlarmInfo

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.hour = [dictionary intForKey:ALARMHOUR];
        self.minute = [dictionary intForKey:ALARMMINUTE];
        self.state = [dictionary intForKey:ALARMSTATE];
        self.repeat = [dictionary intForKey:ALARMREPEAT];
    }
    
    return self;
}

@end
