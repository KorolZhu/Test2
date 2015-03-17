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

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sex = -1;
    }
    
    return self;
}

- (void)loadDataWithDictionary:(NSDictionary *)dictionary {
    self.headImagePath = [dictionary stringForKey:DBPROFILE._PHOTOPATH];
    self.name = [dictionary stringForKey:DBPROFILE._NAME];
    self.birthdayString = [dictionary stringForKey:DBPROFILE._BIRTHDAY];
    self.sex = [dictionary intForKey:DBPROFILE._SEX];
    self.height = [dictionary intForKey:DBPROFILE._HEIGHT];
    self.weight = [dictionary intForKey:DBPROFILE._WEIGHT];
    self.physiologicalDays = [dictionary intForKey:DBPROFILE._PHYSIOLOGICALDAYS];
    self.physiologicalDateString = [dictionary stringForKey:DBPROFILE._PHYSIOLOGICALDATESTRING];
}

- (NSInteger)defaultHeight {
    return 170;
}

- (NSInteger)defaultWeight {
    return 55;
}

@end
