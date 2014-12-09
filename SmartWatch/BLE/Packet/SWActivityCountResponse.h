//
//  SWActivityCountRequest.h
//  SmartWatch
//
//  Created by zhuzhi on 14/12/9.
//
//

#import "SWPacketHeader.h"

@interface SWActivityCountResponse : SWPacketHeader

@property (nonatomic) UInt8 currentIndex;
@property (nonatomic) UInt8 count;
@property (nonatomic) long long dateYMD;

@end
