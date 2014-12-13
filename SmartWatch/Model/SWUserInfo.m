//
//  SWUserInfo.m
//  SmartWatch
//
//  Created by zhuzhi on 14/12/13.
//
//

#import "SWUserInfo.h"
#import "SWPROFILE.h"

@implementation SWUserInfo

SW_DEF_SINGLETON(SWUserInfo, shareInstance);

- (void)loadDataWithDictionary:(NSDictionary *)dictionary {
    self.headImagePath = [dictionary stringForKey:DBPROFILE._PHOTOPATH];
    self.name = [dictionary stringForKey:DBPROFILE._NAME];
    self.birthdayString = [dictionary stringForKey:DBPROFILE._BIRTHDAY];
    self.sex = [dictionary intForKey:DBPROFILE._SEX];
    self.height = [dictionary intForKey:DBPROFILE._HEIGHT];
    self.weight = [dictionary intForKey:DBPROFILE._WEIGHT];
    [self setup];
}

- (void)setup {
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
//    NSString *dateString = [dateFormatter stringFromDate:date];
//    _birthdayString = [
}

@end
