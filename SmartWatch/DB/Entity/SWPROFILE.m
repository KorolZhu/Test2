//
//  SWPROFILE.m
//  SmartWatch
//
//  Created by zhuzhi on 14/12/13.
//
//

#import "SWPROFILE.h"

@implementation SWPROFILE

SW_DEF_SINGLETON(SWPROFILE, shareInstant);

- (NSString *)_tableName {
    return @"PROFILE";
}

- (NSString *)_NAME {
    return @"NAME";
}

- (NSString *)_PHOTOPATH {
    return @"PHOTOPATH";
}

- (NSString *)_SEX {
    return @"SEX";
}

- (NSString *)_BIRTHDAY {
    return @"BIRTHDAY";
}

- (NSString *)_HEIGHT {
    return @"HEIGHT";
}

- (NSString *)_WEIGHT {
    return @"WEIGHT";
}

@end
