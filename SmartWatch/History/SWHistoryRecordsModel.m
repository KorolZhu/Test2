//
//  SWHistoryRecordsModel.m
//  SmartWatch
//
//  Created by zhuzhi on 14/12/24.
//
//

#import "SWHistoryRecordsModel.h"

@interface SWHistoryRecordsModel ()
{
	long long currentDateymd;
}

@end

@implementation SWHistoryRecordsModel

- (void)queryDailyReport {
	NSDate *date = [NSDate date];
	NSString *dateString = [date stringWithFormat:@"yyyyMMdd"];
	long long dateymd = [dateString longLongValue];
	
	if (currentDateymd != dateymd) {
		
	}
}

- (void)queryWeeklyReport {
	
}

- (void)queryMonthlyReport {
	
}

- (void)queryAnnualReport {
	
}

@end
