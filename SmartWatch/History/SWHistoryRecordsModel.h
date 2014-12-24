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
@property (nonatomic,readonly) float daytotalDistance;
@property (nonatomic,readonly) long dayTotalCalorie;

@property (nonatomic,readonly) NSDictionary *weekCalorieDictionary;
@property (nonatomic,readonly) NSDictionary *weekStepsDictionary;
@property (nonatomic,readonly) long weekTotalSteps;
@property (nonatomic,readonly) float weekTotalDistance;
@property (nonatomic,readonly) long weekTotalCalorie;

@property (nonatomic,readonly) NSDictionary *monthCalorieDictionary;
@property (nonatomic,readonly) NSDictionary *monthStepsDictionary;
@property (nonatomic,readonly) long monthTotalSteps;
@property (nonatomic,readonly) float monthTotalDistance;
@property (nonatomic,readonly) long monthTotalCalorie;

@property (nonatomic,readonly) NSDictionary *yearCalorieDictionary;
@property (nonatomic,readonly) NSDictionary *yearStepsDictionary;
@property (nonatomic,readonly) long yearTotalSteps;
@property (nonatomic,readonly) float yearTotalDistance;
@property (nonatomic,readonly) long yearTotalCalorie;

- (void)queryDailyReport;
- (void)queryWeeklyReport;
- (void)queryMonthlyReport;
- (void)queryAnnualReport;

@end
