//
//  SWPacketHeader.h
//  SmartWatch
//
//  Created by zhuzhi on 14/12/9.
//
//

#import <Foundation/Foundation.h>

@interface SWPacketHeader : NSObject

@property (nonatomic) UInt8 cmdID;

- (instancetype)initWithData:(NSData *)data;
- (instancetype)initWithCmdID:(UInt8)cmdID;

@end
