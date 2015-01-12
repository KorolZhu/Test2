//
//  SWSETTING.m
//  SmartWatch
//
//  Created by zhuzhi on 14/12/13.
//
//

#import "SWSETTING.h"

@implementation SWSETTING

SW_DEF_SINGLETON(SWSETTING, shareInstant);

- (NSString *)_tableName {
    return @"SETTING";
}

- (NSString *)_TARGETSTEP {
    return @"TARGETSTEP";
}

- (NSString *)_DAYTIMESTARTHOUR {
    return @"DAYTIMESTARTHOUR";
}

- (NSString *)_DAYTIMEENDTHOUR {
    return @"DAYTIMEENDTHOUR";
}

- (NSString *)_ALARM {
    return @"ALARM";
}

- (NSString *)_LOSTMETERS {
	return @"LOSTMETERS";
}

- (NSString *)_PREVENTLOST {
    return @"PREVENTLOST";
}

@end
