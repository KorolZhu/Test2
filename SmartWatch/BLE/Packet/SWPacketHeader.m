//
//  SWPacketHeader.m
//  SmartWatch
//
//  Created by zhuzhi on 14/12/9.
//
//

#import "SWPacketHeader.h"

@implementation SWPacketHeader

- (instancetype)initWithCmdID:(UInt8)cmdID {
    self = [super init];
    if (self) {
        _cmdID = cmdID;
    }
    
    return self;
}

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        if ([data length] >= 1) {
            [data getBytes:&_cmdID range:NSMakeRange(0,1)];
        }
    }
    
    return self;
}

- (NSData*)formatHeaderToData {
    NSMutableData* headerData = [NSMutableData data];
    [headerData appendBytes:&_cmdID length:1];
    return (NSData*)headerData;
}

@end
