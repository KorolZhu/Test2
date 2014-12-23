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
            
            UInt8 h0 = 0;
            UInt8 i0 = 0;
            [data getBytes:&h0 range:NSMakeRange(6, 1)];
            [data getBytes:&i0 range:NSMakeRange(7, 1)];
            _value0 = h0 * 256 + i0;
            
            UInt8 h1 = 0;
            UInt8 i1 = 0;
            [data getBytes:&h1 range:NSMakeRange(8, 1)];
            [data getBytes:&i1 range:NSMakeRange(9, 1)];
            _value1 = h1 * 256 + i1;
            
            UInt8 h2 = 0;
            UInt8 i2 = 0;
            [data getBytes:&h2 range:NSMakeRange(10, 1)];
            [data getBytes:&i2 range:NSMakeRange(11, 1)];
            _value2 = h2 * 256 + i2;
            
            UInt8 h3 = 0;
            UInt8 i3 = 0;
            [data getBytes:&h3 range:NSMakeRange(12, 1)];
            [data getBytes:&i3 range:NSMakeRange(13, 1)];
            _value3 = h3 * 256 + i3;
            
            UInt8 h4 = 0;
            UInt8 i4 = 0;
            [data getBytes:&h4 range:NSMakeRange(14, 1)];
            [data getBytes:&i4 range:NSMakeRange(15, 1)];
            _value4 = h4 * 256 + i4;
            
            UInt8 h5 = 0;
            UInt8 i5 = 0;
            [data getBytes:&h5 range:NSMakeRange(16, 1)];
            [data getBytes:&i5 range:NSMakeRange(17, 1)];
            _value5 = h5 * 256 + i5;
        }
    }
    
    return self;
}
@end
