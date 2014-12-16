//
//  SWAlarmInfo.h
//  SmartWatch
//
//  Created by zhuzhi on 14/12/16.
//
//

#import <Foundation/Foundation.h>

@interface SWAlarmInfo : NSObject

@property (nonatomic) NSInteger hour;
@property (nonatomic) NSInteger minute;
@property (nonatomic) NSInteger state;
@property (nonatomic) NSInteger repeat;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
