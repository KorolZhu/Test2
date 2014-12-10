//
//  NSDate+WB.h
//  WristBand
//
//  Created by zhuzhi on 14/11/25.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (WB)

- (NSString *)stringWithFormat:(NSString *)format;

+ (NSInteger)currentHour;

+ (NSString *)detailDate:(NSDate *)date;

+ (NSString *)formatSeconds:(NSTimeInterval)seconds;

@end
