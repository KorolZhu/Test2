//
//  SWHistoryRecordsModel.h
//  SmartWatch
//
//  Created by zhuzhi on 14/12/24.
//
//

#import "SWModel.h"

@interface SWHistoryRecordsModel : SWModel

@property (nonatomic,readonly) NSDictionary *dayCalorieDictionary;
@property (nonatomic,readonly) NSDictionary *dayStepsDictionary;
@property (nonatomic,readonly) long dayTotalSteps;
@property (nonatomic,readonly) float dayStepsPercent;
@property (nonatomic,readonly) long dayTotalCalorie;
@property (nonatomic,readonly) float dayCaloriePercent;
@property (nonatomic,readonly) float dayTotalSleep;

@property (nonatomic,readonly) NSDictionary *weekCalorieDictionary;
@property (nonatomic,readonly) NSDictionary *weekStepsDictionary;
@property (nonatomic,readonly) long weekStepsPerday;
@property (nonatomic,readonly) float weekStepsPercent;
@property (nonatomic,readonly) long weekCaloriePerday;
@property (nonatomic,readonly) float weekCaloriePercent;
@property (nonatomic,readonly) float weekSleepPerday;

@property (nonatomic,readonly) NSDictionary *monthCalorieDictionary;
@property (nonatomic,readonly) NSDictionary *monthStepsDictionary;
@property (nonatomic,readonly) long monthStepsPerday;
@property (nonatomic,readonly) float monthStepsPercent;
@property (nonatomic,readonly) long monthCaloriePerday;
@property (nonatomic,readonly) float monthCaloriePercent;
@property (nonatomic,readonly) float monthSleepPerday;

@property (nonatomic,readonly) NSDictionary *yearCalorieDictionary;
@property (nonatomic,readonly) NSDictionary *yearStepsDictionary;
@property (nonatomic,readonly) long yearStepsPerday;
@property (nonatomic,readonly) float yearStepsPercent;
@property (nonatomic,readonly) long yearCaloriePerday;
@property (nonatomic,readonly) float yearCaloriePercent;
@property (nonatomic,readonly) float yearSleepPerday;

- (BOOL)queryDailyReport;
- (BOOL)queryWeeklyReport;
- (BOOL)queryMonthlyReport;
- (BOOL)queryAnnualReport;

@end
