//
//  SWHistoryRecordsModel.m
//  SmartWatch
//
//  Created by zhuzhi on 14/12/24.
//
//

#import "SWHistoryRecordsModel.h"
#import "WBDatabaseService.h"
#import "WBSQLBuffer.h"
#import "SWDAILYSTEPS.h"
#import "SWUserInfo.h"
#import "SWSettingInfo.h"

@interface SWHistoryRecordsModel ()
{
	long long currentDayDateymd;
    long long currentWeekDateymd;
    long long currentMonthDateymd;
    long long currentYearDateymd;

    NSMutableDictionary *stepsTempDictionary;
    NSMutableDictionary *calorieTempDictionary;
    
    __block NSInteger tempTotalSteps;
    __block float tempTotalCalorie;
    __block float tempTotalSleep;
}

@end

@implementation SWHistoryRecordsModel

- (void)resetTempData {
    if (!stepsTempDictionary) {
        stepsTempDictionary = [NSMutableDictionary dictionary];
    }
    [stepsTempDictionary removeAllObjects];
    
    if (!calorieTempDictionary) {
        calorieTempDictionary = [NSMutableDictionary dictionary];
    }
    [calorieTempDictionary removeAllObjects];
    
    tempTotalSteps = 0;
    tempTotalCalorie = 0;
    tempTotalSleep = 0;
    
}

- (NSInteger)stepsTarget {
    NSInteger stepsTarget = [[SWSettingInfo shareInstance] stepsTarget];
    if (stepsTarget <= 0) {
        stepsTarget = [[SWSettingInfo shareInstance] defaultStepsTarget];
    }
    
    return stepsTarget;
}

- (float)calorieTarget {
    float calorieTarget = (float)[[SWSettingInfo shareInstance] calorieTarget];
    if (calorieTarget <= 0.0f) {
        calorieTarget = [[SWSettingInfo shareInstance] defaultCalorieTarget];
    }
    
    return calorieTarget;
}

- (NSInteger)sleepTarget {
    NSInteger sleepTarget = [SWSettingInfo shareInstance].sleepTarget;
    if (sleepTarget <= 0) {
        sleepTarget = [[SWSettingInfo shareInstance] defaultSleepTarget];
    }
    
    return sleepTarget;
}

- (void)queryReportWithDateymd:(long long)dateymd {
    [self resetTempData];
    
    WBSQLBuffer *sqlBuffer = [[WBSQLBuffer alloc] init];
    sqlBuffer.SELECT(@"*").FROM(DBDAILYSTEPS._tableName).WHERE([NSString stringWithFormat:@"%@=%@", DBDAILYSTEPS._DATEYMD, @(dateymd).stringValue]);
    WBDatabaseTransaction *transaction = [[WBDatabaseTransaction alloc] initWithSQLBuffer:sqlBuffer];
    [[WBDatabaseService defaultService] readWithTransaction:transaction completionBlock:^{}];
    if (transaction.resultSet.resultArray.count > 0) {
        NSInteger height = [[SWUserInfo shareInstance] height];
        if (height <= 0) {
            height = [[SWUserInfo shareInstance] defaultHeight];
        }
        
        NSInteger weight = [[SWUserInfo shareInstance] weight];
        if (weight <= 0) {
            weight = [[SWUserInfo shareInstance] defaultWeight];
        }
        
        NSDictionary *resultDictionary = transaction.resultSet.resultArray.firstObject;
        [resultDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString *keyString = key;
            if ([keyString hasPrefix:DBDAILYSTEPS._STEPCOUNT]) {
                NSInteger hour = [[keyString stringByReplacingOccurrencesOfString:DBDAILYSTEPS._STEPCOUNT withString:@""] integerValue];
                NSInteger steps = [obj integerValue];
                if (steps >= 65280) {
                    // 睡眠评分
                    NSInteger score = steps - 65280;
                    if (score >= 50) {
                        tempTotalSleep += 1;
                    }
                } else {
                    if (steps > 0) {
                        [stepsTempDictionary setObject:@(steps) forKey:@(hour + 1)];
                        
                        tempTotalSteps += steps;
                        
                        float calorie = 0.53 * height + 0.58 * weight + 0.04 * steps - 135;
                        if (calorie > 0.0f) {
                            [calorieTempDictionary setObject:@(calorie) forKey:@(hour + 1)];
                        }
                    }
                }
            }
        }];
        
        tempTotalCalorie = 0.53 * height + 0.58 * weight + 0.04 * tempTotalSteps - 135;
        if (tempTotalCalorie <= 0) {
            tempTotalCalorie = 0.0f;
//            if (tempTotalSteps > 0) {
//                tempTotalCalorie = 0.1f;
//            }
        }
    }
}

- (BOOL)queryDailyReport {
    NSDate *date = [NSDate date];
    NSString *dateString = [date stringWithFormat:@"yyyyMMdd"];
    long long dateymd = [dateString longLongValue];
//    if (currentDayDateymd == dateymd) {
//        return NO;
//    }
	
    [[GCDQueue globalQueue] queueBlock:^{
        currentDayDateymd = dateymd;
        [self queryReportWithDateymd:currentDayDateymd];
        _dayTotalSteps = tempTotalSteps;
        _dayStepsPercent = tempTotalSteps / (float)[self stepsTarget];
//        if (_dayStepsPercent <= 0.01f && tempTotalSteps > 0) {
//            _dayStepsPercent = 0.01f;
//        }
        
        _dayTotalCalorie = tempTotalCalorie;
        _dayCaloriePercent = tempTotalCalorie / [self calorieTarget];
//        if (_dayCaloriePercent <= 0.01f && tempTotalSteps > 0) {
//            _dayCaloriePercent = 0.01f;
//        }
        
        _dayStepsDictionary = [NSDictionary dictionaryWithDictionary:stepsTempDictionary];
        _dayCalorieDictionary = [NSDictionary dictionaryWithDictionary:calorieTempDictionary];
        
        _dayTotalSleep = tempTotalSleep;
        
        [self respondSelectorOnMainThread:@selector(dayRecordsQueryFinished)];
    }];
    
    return YES;
}

- (BOOL)queryWeeklyReport {
    NSDate *date = [NSDate date];
    NSString *dateString = [date stringWithFormat:@"yyyyMMdd"];
    long long dateymd = [dateString longLongValue];
//    if (currentWeekDateymd == dateymd) {
//        return NO;
//    }
	
    [[GCDQueue globalQueue] queueBlock:^{
        currentWeekDateymd = dateymd;
        
        NSMutableDictionary *tempWeekCalorieDictionary = [NSMutableDictionary dictionary];
        NSMutableDictionary *tempWeekStepsDictionary = [NSMutableDictionary dictionary];
        long tempWeekTotalSteps = 0;
        long tempWeekTotalCalorie = 0;
        float tempWeekTotalSleep = 0;
        
        for (NSInteger i = 1; i <= 7; i++) {
            NSDate *tempDate = [date dateByAddingTimeInterval:-(7 - i) * 24 * 3600];
            NSString *dateString = [tempDate stringWithFormat:@"yyyyMMdd"];
            [self queryReportWithDateymd:[dateString longLongValue]];
            [tempWeekCalorieDictionary setObject:@(tempTotalCalorie) forKey:@(i)];
            [tempWeekStepsDictionary setObject:@(tempTotalSteps) forKey:@(i)];
            tempWeekTotalSteps += tempTotalSteps;
            tempWeekTotalCalorie += tempTotalCalorie;
            tempWeekTotalSleep += tempTotalSleep;
        }
        
        _weekCalorieDictionary = [NSDictionary dictionaryWithDictionary:tempWeekCalorieDictionary];
        _weekStepsDictionary = [NSDictionary dictionaryWithDictionary:tempWeekStepsDictionary];
        _weekStepsPerday = tempWeekTotalSteps / 7.0f;
        _weekStepsPercent = _weekStepsPerday / (float)[self stepsTarget];
        _weekCaloriePerday = tempWeekTotalCalorie / 7.0f;
        _weekCaloriePercent = _weekCaloriePerday / (float)[self calorieTarget];
        _weekSleepPerday = tempWeekTotalSleep / 7.0f;
        
        [self respondSelectorOnMainThread:@selector(weekRecordsQueryFinished)];
    }];
    
    return YES;
}

- (BOOL)queryMonthlyReport {
    NSDate *date = [NSDate date];
    NSString *dateString = [date stringWithFormat:@"yyyyMMdd"];
    long long dateymd = [dateString longLongValue];
//    if (currentMonthDateymd == dateymd) {
//        return NO;
//    }
	
    [[GCDQueue globalQueue] queueBlock:^{
        currentMonthDateymd = dateymd;
        
        NSMutableDictionary *tempMonthCalorieDictionary = [NSMutableDictionary dictionary];
        NSMutableDictionary *tempMonthStepsDictionary = [NSMutableDictionary dictionary];
        long tempMonthTotalSteps = 0;
        long tempMonthTotalCalorie = 0;
        float tempMonthTotalSleep = 0;
        
        for (NSInteger i = 1; i <= 30; i++) {
            NSDate *tempDate = [date dateByAddingTimeInterval:-(30 - i) * 24 * 3600];
            NSString *dateString = [tempDate stringWithFormat:@"yyyyMMdd"];
            [self queryReportWithDateymd:[dateString longLongValue]];
            [tempMonthCalorieDictionary setObject:@(tempTotalCalorie) forKey:@(i)];
            [tempMonthStepsDictionary setObject:@(tempTotalSteps) forKey:@(i)];
            tempMonthTotalSteps += tempTotalSteps;
            tempMonthTotalCalorie += tempTotalCalorie;
            tempMonthTotalSleep += tempTotalSleep;
        }
        
        _monthCalorieDictionary = [NSDictionary dictionaryWithDictionary:tempMonthCalorieDictionary];
        _monthStepsDictionary = [NSDictionary dictionaryWithDictionary:tempMonthStepsDictionary];
        _monthStepsPerday = tempMonthTotalSteps / 30.0f;
        _monthStepsPercent = _monthStepsPerday / (float)[self stepsTarget];
        _monthCaloriePerday = tempMonthTotalCalorie / 30.0f;
        _monthCaloriePercent = _monthCaloriePerday / (float)[self calorieTarget];
        _monthSleepPerday = tempMonthTotalSleep / 30.0f;
        
        [self respondSelectorOnMainThread:@selector(monthRecordsQueryFinished)];
    }];
    
    return YES;
}

- (BOOL)queryAnnualReport {
    NSDate *date = [NSDate date];
    NSString *dateString = [date stringWithFormat:@"yyyyMMdd"];
    long long dateymd = [dateString longLongValue];
//    if (currentYearDateymd == dateymd) {
//        return NO;
//    }
	
    [[GCDQueue globalQueue] queueBlock:^{
       
        currentYearDateymd = dateymd;
        
        NSMutableDictionary *tempYearCalorieDictionary = [NSMutableDictionary dictionary];
        NSMutableDictionary *tempYearStepsDictionary = [NSMutableDictionary dictionary];
        long tempYearTotalSteps = 0;
        long tempYearTotalCalorie = 0;
        float tempYearTotalSleep = 0;
        
        NSInteger currentYear = [[date stringWithFormat:@"yyyy"] integerValue];
        NSInteger currentMonth = [[date stringWithFormat:@"MM"] integerValue];
        for (NSInteger i = 12; i >= 1; i--) {
            long tempMonthTotalSteps = 0;
            long tempMonthTotalCalorie = 0;
            float tempMonthTotalSleep = 0;
            for (int i = 31; i >= 1; i--) {
                long long tempDateymd = currentYear * 10000 + currentMonth * 100 + i;
                [self queryReportWithDateymd:tempDateymd];
                tempMonthTotalCalorie += tempTotalCalorie;
                tempMonthTotalSteps += tempTotalSteps;
                tempMonthTotalSleep += tempTotalSleep;
            }
            [tempYearCalorieDictionary setObject:@(tempMonthTotalCalorie) forKey:@(i)];
            [tempYearStepsDictionary setObject:@(tempMonthTotalSleep) forKey:@(i)];
            tempYearTotalSteps += tempMonthTotalSteps;
            tempYearTotalCalorie += tempMonthTotalCalorie;
            tempYearTotalSleep += tempMonthTotalSleep;
            
            currentMonth--;
            if (currentMonth <= 0) {
                currentMonth = 12;
                currentYear--;
            }
        }
        
        _yearCalorieDictionary = [NSDictionary dictionaryWithDictionary:tempYearCalorieDictionary];
        _yearStepsDictionary = [NSDictionary dictionaryWithDictionary:tempYearStepsDictionary];
        _yearStepsPerday = tempYearTotalSteps / 365.0f;
        _yearStepsPercent = _yearStepsPerday / (float)[self stepsTarget];
        _yearCaloriePerday = tempYearTotalCalorie / 365.0f;
        _yearCaloriePercent = _yearCaloriePerday / (float)[self calorieTarget];
        _yearSleepPerday = tempYearTotalSleep / 30.0f;
        
        [self respondSelectorOnMainThread:@selector(annualRecordsQueryFinished)];
    }];
    
    return YES;
}

@end
