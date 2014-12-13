//
//  SWSettingInfo.m
//  SmartWatch
//
//  Created by zhuzhi on 14/12/13.
//
//

#import "SWSettingInfo.h"
#import "SWSETTING.h"

@implementation SWSettingInfo

SW_DEF_SINGLETON(SWSettingInfo, shareInstance);

- (void)loadDataWithDictionary:(NSDictionary *)dictionary {
    self.stepsTarget = [dictionary intForKey:DBSETTING._TARGETSTEP];
    self.startHour = [dictionary intForKey:DBSETTING._DAYTIMESTARTHOUR];
    self.endHour = [dictionary intForKey:DBSETTING._DAYTIMEENDTHOUR];
}

@end
