//
//  NSDate+WB.m
//  WristBand
//
//  Created by zhuzhi on 14/11/25.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import "NSDate+WB.h"

@implementation NSDate (WB)

- (NSString *)stringWithFormat:(NSString *)format {
    static NSDateFormatter *formatter;
    GCDExecOnce(^{
        formatter = [[NSDateFormatter alloc] init];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        [formatter setCalendar:calendar];
    });
    
    [formatter setDateFormat:format];
    NSString *formatString = [formatter stringFromDate:self];
    return formatString;
}

+ (NSInteger)currentHour {
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit| NSMinuteCalendarUnit;
    NSCalendar *calendar;
    calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comps = [calendar components:unitFlags fromDate:[NSDate date]];
    NSInteger hour = [comps hour];
    return hour;
}

+ (NSString *)detailDate:(NSDate *)date{
    if (!date) {
        return nil;
    }
    // Initialize the calendar and flags.
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit| NSMinuteCalendarUnit;
    static NSCalendar *calendar;
    if (!calendar) {
        calendar = [NSCalendar currentCalendar];
    }
    
    // Create reference date for supplied date.
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    NSInteger hour = [comps hour];
    NSInteger minute = [comps minute];
    
    NSString *dateStr = [NSString stringWithFormat:@"%02ld:%02ld",(long)hour,(long)minute];

    return dateStr;
}

+ (NSString *)formatSeconds:(NSTimeInterval)seconds {
    NSInteger hour = (NSInteger)seconds / 3600;
    NSInteger minute = (NSInteger)seconds % 3600 / 60;
    NSString *timeCountStr = nil;
    if (hour > 0) {
        timeCountStr = [NSString stringWithFormat:@"%ld h %ld min", (long)hour, (long)minute];
    } else {
        timeCountStr = [NSString stringWithFormat:@"%ld min", (long)minute];
    }
    return timeCountStr;
}

@end
