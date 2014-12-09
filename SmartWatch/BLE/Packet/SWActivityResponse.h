//
//  SWActivityResponse.h
//  SmartWatch
//
//  Created by zhuzhi on 14/12/9.
//
//

#import "SWPacketHeader.h"

@interface SWActivityResponse : SWPacketHeader

@property (nonatomic) long long dateYMD;
@property (nonatomic) UInt8 startHour;
@property (nonatomic) UInt16 value0;
@property (nonatomic) UInt16 value1;
@property (nonatomic) UInt16 value2;
@property (nonatomic) UInt16 value3;
@property (nonatomic) UInt16 value4;
@property (nonatomic) UInt16 value5;

@end
