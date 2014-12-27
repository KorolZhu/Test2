//
//  SWExerciseRecordsModel.m
//  SmartWatch
//
//  Created by zhuzhi on 14/12/10.
//
//

#import "SWExerciseRecordsModel.h"
#import "WBDatabaseService.h"
#import "WBSQLBuffer.h"
#import "SWDAILYSTEPS.h"
#import "SWBLECenter.h"
#import "SWUserInfo.h"
#import "SWSettingInfo.h"

@interface SWExerciseRecordsModel ()
{
}

@end

@implementation SWExerciseRecordsModel

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kSWBLEDataReadCompletionNotification object:nil];
}

- (instancetype)initWithResponder:(id)responder {
	self = [super initWithResponder:responder];
	if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bleDataReadCompletion) name:kSWBLEDataReadCompletionNotification object:nil];
	}
	
	return self;
}

- (void)queryExerciseRecordsWithDate:(NSDate *)date {
	//
	[[GCDQueue globalQueue] queueBlock:^{
        _currentDate = date;
		_currentDateString = [_currentDate stringWithFormat:@"yyyyMMdd"];
		long long currentDateymd = [_currentDateString longLongValue];
		
		WBSQLBuffer *sqlBuffer = [[WBSQLBuffer alloc] init];
		sqlBuffer.SELECT(@"*").FROM(DBDAILYSTEPS._tableName).WHERE([NSString stringWithFormat:@"%@=%@", DBDAILYSTEPS._DATEYMD, @(currentDateymd).stringValue]);
		WBDatabaseTransaction *transaction = [[WBDatabaseTransaction alloc] initWithSQLBuffer:sqlBuffer];
		[[WBDatabaseService defaultService] readWithTransaction:transaction completionBlock:^{}];
        
        NSDictionary *resultDictionary = transaction.resultSet.resultArray.firstObject;
        NSMutableDictionary *stepsTempDictionary = [NSMutableDictionary dictionary];
        NSMutableDictionary *calorieTempDictionary = [NSMutableDictionary dictionary];
        NSMutableDictionary *sleepTempDictionary = [NSMutableDictionary dictionary];
        
        __block NSInteger tempTotalSteps = 0;
        __block float tempTotalCalorie = 0.0f;
        __block NSInteger tempTotalActivityTime = 0;
        __block float tempTotalDeepSleep;
        __block float tempTotalLightSleep;
        __block float tempNightActivityHour;
        
		if (transaction.resultSet.resultArray.count > 0) {
			
			[resultDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
				NSString *keyString = key;
				if ([keyString hasPrefix:DBDAILYSTEPS._STEPCOUNT]) {
					NSInteger hour = [[keyString stringByReplacingOccurrencesOfString:DBDAILYSTEPS._STEPCOUNT withString:@""] integerValue];
					NSInteger steps = [obj integerValue];
					if (steps > 65280) {
						[sleepTempDictionary setObject:@(steps - 65280) forKey:@(hour + 1)];
					} else {
                        if (steps > 0) {
                            [stepsTempDictionary setObject:@(steps) forKey:@(hour + 1)];
                            
                            tempTotalSteps += steps;
                            
                            if (steps > 100) {
                                tempTotalActivityTime += 1;
                            }
                        }
						
						float calorie = 0.53 * [[SWUserInfo shareInstance] height] + 0.58 * [[SWUserInfo shareInstance] weight] + 0.04 * steps - 135;
                        if (calorie > 0.0f) {
                            [calorieTempDictionary setObject:@(calorie) forKey:@(hour + 1)];
                            
                            tempTotalCalorie += calorie;
                        }
					}
                    
                    // 计算睡眠时间
                    NSInteger daylightStartHour = [[SWSettingInfo shareInstance] startHour];
                    NSInteger daylightEndHour = [[SWSettingInfo shareInstance] endHour];
                    BOOL night = NO;
                    if (daylightStartHour > daylightEndHour) {
                        if (hour >= daylightStartHour || hour <= daylightEndHour) {
                            night = NO;
                        } else {
                            night = YES;
                        }
                    } else {
                        if (hour >= daylightStartHour && hour <= daylightEndHour) {
                            night = NO;
                        } else {
                            night = YES;
                        }
                    }
                    
                    if (night) {
                        if (steps <= 10) {
                            tempTotalDeepSleep += 1;
                        } else if (steps <= 50) {
                            tempTotalLightSleep += 1;
                        } else {
                            tempNightActivityHour += 1;
                        }
                    }
                    
				}
			}];
		}
        
        _totalSteps = tempTotalSteps;
        _stepsPercent = _totalSteps / [[SWSettingInfo shareInstance] stepsTarget];
        _stepsPercentString = [NSString stringWithFormat:@"%d%%", (int)(_stepsPercent * 100)];
        
        _totalDistance = tempTotalSteps * [[SWUserInfo shareInstance] height] * 0.45 * 0.01 * 0.001;
        
        _totalCalorie = tempTotalCalorie;
        _caloriePercent = tempTotalCalorie / [[SWSettingInfo shareInstance] calorieTarget];
        _caloriePercentString = [NSString stringWithFormat:@"%d%%", (int)(_caloriePercent * 100)];
        _daylightActivitytime = tempTotalActivityTime;
        
        _deepSleepHour = tempTotalDeepSleep;
        _lightSleepHour = tempTotalLightSleep;
        _nightActivityHour = tempNightActivityHour;
        
        _stepsDictionary = [NSDictionary dictionaryWithDictionary:stepsTempDictionary];
        _sleepDictionary = [NSDictionary dictionaryWithDictionary:sleepTempDictionary];
        _calorieDictionary = [NSDictionary dictionaryWithDictionary:calorieTempDictionary];
        
        [self respondSelectorOnMainThread:@selector(exerciseRecordsQueryFinished)];
	}];
}

- (void)bleDataReadCompletion {
	[self queryExerciseRecordsWithDate:_currentDate];
}

@end
