//
//  SWLOCATION.m
//  SmartWatch
//
//  Created by zhuzhi on 15/1/10.
//
//

#import "SWLOCATION.h"

@implementation SWLOCATION

SW_DEF_SINGLETON(SWLOCATION, shareInstant);

- (NSString *)_tableName {
    return @"LOCATION";
}

- (NSString *)_dateymd {
    return @"DATEYMD";
}

- (NSString *)_longitude {
    return @"LONGITUDE";
}

- (NSString *)_latitude {
    return @"LATITUDE";
}

@end
