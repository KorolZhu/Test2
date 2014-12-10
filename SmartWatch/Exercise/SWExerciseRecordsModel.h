//
//  SWExerciseRecordsModel.h
//  SmartWatch
//
//  Created by zhuzhi on 14/12/10.
//
//

#import <Foundation/Foundation.h>
#import "SWModel.h"

@interface SWExerciseRecordsModel : SWModel

@property (nonatomic,readonly) NSDictionary *calorieDictionary;
@property (nonatomic,readonly) NSDictionary *stepsDictionary;
@property (nonatomic,readonly) NSDictionary *sleepDictionary;

- (void)queryExerciseRecords;

@end
