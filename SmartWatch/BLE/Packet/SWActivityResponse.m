//
//  SWActivityResponse.m
//  SmartWatch
//
//  Created by zhuzhi on 14/12/9.
//
//

#import "SWActivityResponse.h"

@implementation SWActivityResponse

- (instancetype)initWithData:(NSData *)data {
    self = [super initWithData:data];
    if (self) {
        if (data.length >= 18) {
            UInt8 yy1 = 0, yy2 = 0, month = 0, day = 0;
            [data getBytes:&yy1 range:NSMakeRange(1, 1)];
            [data getBytes:&yy2 range:NSMakeRange(2, 1)];
            [data getBytes:&month range:NSMakeRange(3, 1)];
            [data getBytes:&day range:NSMakeRange(4, 1)];
            
            _dateYMD = [[NSString stringWithFormat:@"%02d%02d%02d%02d", (int)yy1, (int)yy2, (int)month, (int)day] longLongValue];
            
            [data getBytes:&_startHour range:NSMakeRange(5, 1)];
            [data getBytes:&_value0 range:NSMakeRange(6, 2)];
            [data getBytes:&_value1 range:NSMakeRange(8, 2)];
            [data getBytes:&_value2 range:NSMakeRange(10, 2)];
            [data getBytes:&_value3 range:NSMakeRange(12, 2)];
            [data getBytes:&_value4 range:NSMakeRange(14, 2)];
            [data getBytes:&_value5 range:NSMakeRange(16, 2)];

        }
    }
    
    return self;
}
@end
