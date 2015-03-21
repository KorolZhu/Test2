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
#import "SWLOCATION.h"
#import "SWBLECenter.h"
#import "SWUserInfo.h"
#import "SWSettingInfo.h"
#import <CoreLocation/CoreLocation.h>
#import "SBJSON.h"
#import "ASIFormDataRequest.h"
#import <XMLDictionary.h>
#import "SWSettingModel.h"

@interface SWExerciseRecordsModel ()<CLLocationManagerDelegate>
{
	NSString *cityCode;
	NSString *cityName;
	CLLocation *currentLocation;
	CLPlacemark *placemark;
	BOOL isRequestWeathering;
	__block NSArray *cityIDArray;
}

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation SWExerciseRecordsModel

- (void)dealloc {
	
}

- (instancetype)initWithResponder:(id)responder {
	self = [super initWithResponder:responder];
	if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stepsTargetChangedNotification) name:kSWStepsTargetChangedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sleepTargetChangedNotification) name:kSWSleepTargetChangedNotification object:nil];
	}
	
	return self;
}

- (void)stepsTargetChangedNotification {
    NSInteger stepsTarget = [[SWSettingInfo shareInstance] stepsTarget];
    if (stepsTarget <= 0) {
        stepsTarget = [[SWSettingInfo shareInstance] defaultStepsTarget];
    }
    
    _stepsPercent = _totalSteps / (float)stepsTarget;
    if (_stepsPercent <= 0.0f && _totalSteps > 0) {
        _stepsPercent = 0.01f;
    }
    _stepsPercentString = [NSString stringWithFormat:@"%d%%", (int)(_stepsPercent * 100)];
    
    // 计算总得卡路里
    float calorieTarget = (float)[[SWSettingInfo shareInstance] calorieTarget];
    if (calorieTarget <= 0.0f) {
        calorieTarget = [[SWSettingInfo shareInstance] defaultCalorieTarget];
    }
    
    _caloriePercent = _totalCalorie / (float)calorieTarget;
//    if (_caloriePercent <= 0.0f && _totalSteps > 0) {
//        _caloriePercent = 0.01f;
//    }
    _caloriePercentString = [NSString stringWithFormat:@"%d%%", (int)(_caloriePercent * 100)];
    
    [self respondSelectorOnMainThread:@selector(exerciseRecordsQueryFinished)];
}

- (void)sleepTargetChangedNotification {
    NSInteger sleepTarget = [SWSettingInfo shareInstance].sleepTarget;
    if (sleepTarget <= 0) {
        sleepTarget = [[SWSettingInfo shareInstance] defaultSleepTarget];
    }
    _sleepPercent = (_deepSleepHour + _lightSleepHour) /(float)sleepTarget;
    
    [self respondSelectorOnMainThread:@selector(exerciseRecordsQueryFinished)];
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
        __block NSInteger tempTotalActivityTime = 0;
        __block float tempTotalDeepSleep = 0.0f;
        __block float tempTotalLightSleep = 0.0f;
        __block float tempNightActivityHour = 0.0f;
        
        NSInteger height = [[SWUserInfo shareInstance] height];
        if (height <= 0) {
            height = [[SWUserInfo shareInstance] defaultHeight];
        }
        
        NSInteger weight = [[SWUserInfo shareInstance] weight];
        if (weight <= 0) {
            weight = [[SWUserInfo shareInstance] defaultWeight];
        }
        
		if (transaction.resultSet.resultArray.count > 0) {
			
			[resultDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
				NSString *keyString = key;
				if ([keyString hasPrefix:DBDAILYSTEPS._STEPCOUNT]) {
					NSInteger hour = [[keyString stringByReplacingOccurrencesOfString:DBDAILYSTEPS._STEPCOUNT withString:@""] integerValue];
					NSInteger steps = [obj integerValue];
					if (steps >= 65280) {
                        NSInteger score = steps - 65280;
                        if (score >= 80) {
                            tempTotalDeepSleep += 1;
                        } else if (score >= 50) {
                            tempTotalLightSleep += 1;
                        } else {
                            tempNightActivityHour += 1;
                        }
                        
						[sleepTempDictionary setObject:@(steps - 65280) forKey:@(hour + 1)];
					} else {
                        if (steps > 0) {
                            [stepsTempDictionary setObject:@(steps) forKey:@(hour + 1)];
                            
                            tempTotalSteps += steps;
                            
                            if (steps >= 100) {
                                tempTotalActivityTime += 1;
                            }
                            
                            float calorie = 0.53 * height + 0.58 * weight + 0.04 * steps - 135;
                            if (calorie > 0.0f) {
                                [calorieTempDictionary setObject:@(calorie) forKey:@(hour + 1)];
                            }
                        }
					}
				}
			}];
		}
        
        // 计算总得卡路里
        float calorieTarget = (float)[[SWSettingInfo shareInstance] calorieTarget];
        if (calorieTarget <= 0.0f) {
            calorieTarget = [[SWSettingInfo shareInstance] defaultCalorieTarget];
        }
        
        float tempTotalCalorie = 0.53 * height + 0.58 * weight + 0.04 * tempTotalSteps - 135;
        if (tempTotalCalorie <= 0) {
            tempTotalCalorie = 0.0f;
//            if (tempTotalSteps > 0) {
//                tempTotalCalorie = 1.0f;
//            }
        }
        _totalCalorie = tempTotalCalorie;
        _caloriePercent = tempTotalCalorie / (float)calorieTarget;
//        if (_caloriePercent <= 0.01f && tempTotalSteps > 0) {
//            _caloriePercent = 0.01f;
//        }
        _caloriePercentString = [NSString stringWithFormat:@"%d%%", (int)(_caloriePercent * 100)];
        
        _daylightActivitytime = tempTotalActivityTime;
        
        NSInteger stepsTarget = [[SWSettingInfo shareInstance] stepsTarget];
        if (stepsTarget <= 0) {
            stepsTarget = [[SWSettingInfo shareInstance] defaultStepsTarget];
        }
        
        _totalSteps = tempTotalSteps;
        _stepsPercent = _totalSteps / (float)stepsTarget;
//        if (_stepsPercent <= 0.01f && tempTotalSteps > 0) {
//            _stepsPercent = 0.01f;
//        }
        _stepsPercentString = [NSString stringWithFormat:@"%d%%", (int)(_stepsPercent * 100)];
        
        _totalDistance = tempTotalSteps * height * 0.45 * 0.01 * 0.001;
        if (_totalDistance < 0.1f && tempTotalSteps > 0) {
            _totalDistance = 0.1f;
        }
        
        _deepSleepHour = tempTotalDeepSleep;
        _lightSleepHour = tempTotalLightSleep;
        _nightActivityHour = tempNightActivityHour;
        NSInteger sleepTarget = [SWSettingInfo shareInstance].sleepTarget;
        if (sleepTarget <= 0) {
            sleepTarget = [[SWSettingInfo shareInstance] defaultSleepTarget];
        }
        _sleepPercent = (_deepSleepHour + _lightSleepHour) /(float)sleepTarget;
        
        _stepsDictionary = [NSDictionary dictionaryWithDictionary:stepsTempDictionary];
        _sleepDictionary = [NSDictionary dictionaryWithDictionary:sleepTempDictionary];
        _calorieDictionary = [NSDictionary dictionaryWithDictionary:calorieTempDictionary];
        
        [self respondSelectorOnMainThread:@selector(exerciseRecordsQueryFinished)];
	}];
}

- (void)queryLocationWithDate:(NSDate *)date {
    [[GCDQueue globalQueue] queueBlock:^{
        _currentDate = date;
        _currentDateString = [_currentDate stringWithFormat:@"yyyyMMdd"];
        long long currentDateymd = [_currentDateString longLongValue];
        WBSQLBuffer *sqlBuffer = [[WBSQLBuffer alloc] init];
        sqlBuffer.SELECT(@"*").FROM(DBLOCATION._tableName).WHERE([NSString stringWithFormat:@"%@=%@", DBLOCATION._dateymd, @(currentDateymd).stringValue]);
        WBDatabaseTransaction *transaction = [[WBDatabaseTransaction alloc] initWithSQLBuffer:sqlBuffer];
        [[WBDatabaseService defaultService] readWithTransaction:transaction completionBlock:^{}];
        
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *dic in transaction.resultSet.resultArray) {
            double latitude = [dic doubleForKey:DBLOCATION._latitude];
            double longitude = [dic doubleForKey:DBLOCATION._longitude];
            CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
            [tempArray addObject:location];
        }
        _locationArray = [NSArray arrayWithArray:tempArray];
        
        [self respondSelectorOnMainThread:@selector(locationQueryFinished)];

    }];
}

- (void)bleDataReadCompletion {
	[self queryExerciseRecordsWithDate:_currentDate];
}

#pragma mark - Weather

- (void)queryWeatherInfo {
	if (isRequestWeathering) {
		return;
	}
	
	isRequestWeathering = YES;
	
	if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
		[self requestWeatherInfo];
		return;
	}
	
	currentLocation = nil;
	
	if (!_locationManager) {
		_locationManager = [[CLLocationManager alloc] init];
		_locationManager.delegate = self;
		_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
		_locationManager.distanceFilter = 100.0f;
		
		if(IOS8) {
			[_locationManager requestAlwaysAuthorization];
		}
	}
	
	[_locationManager startUpdatingLocation];
}

- (void)getCityCode {
	[[GCDQueue lowPriorityGlobalQueue] queueBlock:^{
		NSString *locality = placemark.locality;
		if (locality.length == 0) {
			locality = placemark.administrativeArea;
		}
//		if (locality.length > 0) {
//			cityName = locality;
//			[[NSUserDefaults standardUserDefaults] setObject:locality forKey:LASTCITYNAME];
//			[[NSUserDefaults standardUserDefaults] synchronize];
//		}
		
		if (!cityIDArray) {
			cityIDArray = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CityID" ofType:@"plist"]];
		}
		
		for (NSDictionary *cityID in cityIDArray) {
			NSString *namecn = [cityID stringForKey:@"NAMECN"];
			NSString *nameen = [cityID stringForKey:@"NAMEEN"];
			
			if ([locality containString:namecn] ||
				[locality containString:nameen]) {
				NSString *areaID = [cityID stringForKey:@"AREAID"];
				cityCode = [areaID copy];
				[[NSUserDefaults standardUserDefaults] setObject:cityCode forKey:LASTCITYCODE];
				[[NSUserDefaults standardUserDefaults] synchronize];
				break;
			}
		}
		
		[self requestWeatherInfo];
	}];
}

- (void)requestWeatherInfo {
	[[GCDQueue lowPriorityGlobalQueue] queueBlock:^{
		if (cityCode.length == 0) {
			cityCode = [[NSUserDefaults standardUserDefaults] stringForKey:LASTCITYCODE];
		}
		
		if (cityCode == 0) {
			isRequestWeathering = NO;
			return ;
		}
		
		//http://wthrcdn.etouch.cn/WeatherApi?citykey=101280601
		NSString *path = [NSString stringWithFormat:@"http://wthrcdn.etouch.cn/WeatherApi?citykey=%@", cityCode];
		ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:path]];
		[request startSynchronous];
		if (request.responseStatusCode == 200) {
			NSString *responseStr = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
			NSDictionary *dic = [[XMLDictionaryParser sharedInstance] dictionaryWithString:responseStr];
			NSString *wendu = [dic stringForKey:@"wendu"];
			if (wendu.length > 0) {
				_temp = [NSString stringWithFormat:@"%@℃", wendu];
			}
			
			NSString *shidu = [dic stringForKey:@"shidu"];
			if (shidu.length > 0) {
				_shidu = [shidu copy];
			}
			
			NSDictionary *zhishus = [dic dictionaryForKey:@"zhishus"];
			NSArray *zhishuArr = [zhishus arrayForKey:@"zhishu"];
			for (NSDictionary *tempdic in zhishuArr) {
				NSString *name = [tempdic stringForKey:@"name"];
				if ([name isEqualToString:@"紫外线强度"]) {
					NSString *value = [tempdic stringForKey:@"value"];
					_uvLevel = [value copy];
					break;
				}
			}
			
			[self respondSelectorOnMainThread:@selector(weatherInfoUpdated)];
			
			isRequestWeathering = NO;
		} else {
			/*
			//中国天气网解析地址；
			NSString *path= [NSString stringWithFormat:@"http://m.weather.com.cn/data/%@.html", cityCode];
			
			ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:path]];
			[request startSynchronous];
			if (request.responseStatusCode == 200) {
				NSDictionary *resultInfo = [request.responseString jsonValue];
				if ([resultInfo isKindOfClass:[NSDictionary class]]) {
					NSDictionary *weatherinfo = [resultInfo objectForKey:@"weatherinfo"];
					if (weatherinfo) {
						NSString *temp = [weatherinfo stringForKey:@"temp"];
						if (temp.length > 0) {
							_temp = [NSString stringWithFormat:@"%@℃", temp];
						}
						
						NSString *sd = [weatherinfo stringForKey:@"SD"];
						if (sd.length > 0) {
							_shidu = sd;
						}
					}
					
				}
				
				[self respondSelectorOnMainThread:@selector(weatherInfoUpdated)];
				
				isRequestWeathering = NO;
			}
			 */
		}
		
	}];
}

#pragma mark - CLLocationManagerDelegate Methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
	if (currentLocation) {
		[manager stopUpdatingLocation];
		return;
	}
	
	currentLocation = locations.lastObject;
	CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//	CLLocation *location = [[CLLocation alloc] initWithLatitude:28.68 longitude:115.89];
	[geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error) {
		 if (array.count > 0) {
			 placemark = array.firstObject;
			 [self getCityCode];
		 } else {
			 [self requestWeatherInfo];
		 }
	 }];
}

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error {
	if (currentLocation) {
		return;
	}
	
	[manager stopUpdatingLocation];
	[self requestWeatherInfo];
}

@end
