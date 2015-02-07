//
//  SWSettingInfo.h
//  SmartWatch
//
//  Created by zhuzhi on 14/12/13.
//
//

#import <Foundation/Foundation.h>
#import "SWSingleton.h"

@interface SWSettingInfo : NSObject

SW_AS_SINGLETON(SWSettingInfo, shareInstance);

@property (nonatomic) NSInteger battery;
@property (nonatomic) NSInteger ultravioletIndex;
@property (nonatomic) NSInteger stepsTarget;
@property (nonatomic) float calorieTarget;
@property (nonatomic) NSInteger sleepTarget;
@property (nonatomic) NSInteger startHour;
@property (nonatomic) NSInteger endHour;
@property (nonatomic) NSMutableArray *alarmArray;
@property (nonatomic) NSInteger lostMeters;
@property (nonatomic) NSInteger preventLost;

- (void)loadDataWithDictionary:(NSDictionary *)dictionary;
- (void)updateToDB;

- (NSInteger)defaultStepsTarget;
- (float)defaultCalorieTarget;
- (NSInteger)defaultSleepTarget;

@end
