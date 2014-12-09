//
//  SWActivityCountRequest.m
//  SmartWatch
//
//  Created by zhuzhi on 14/12/9.
//
//

#import "SWActivityCountResponse.h"

@implementation SWActivityCountResponse

- (instancetype)initWithData:(NSData *)data {
    self = [super initWithData:data];
    if (self) {
        if (data.length >= 7) {
            [data getBytes:&_currentIndex range:NSMakeRange(1, 1)];
            [data getBytes:&_count range:NSMakeRange(2, 1)];
            
            UInt8 yy1 = 0, yy2 = 0, month = 0, day = 0;
            [data getBytes:&yy1 range:NSMakeRange(3, 1)];
            [data getBytes:&yy2 range:NSMakeRange(4, 1)];
            [data getBytes:&month range:NSMakeRange(5, 1)];
            [data getBytes:&day range:NSMakeRange(6, 1)];

            _dateYMD = [[NSString stringWithFormat:@"%02d%02d%02d%02d", (int)yy1, (int)yy2, (int)month, (int)day] longLongValue];
        }
    }
    
    return self;
}

@end
