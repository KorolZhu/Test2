//
//  SWUserInfo.h
//  SmartWatch
//
//  Created by zhuzhi on 14/12/13.
//
//

#import <Foundation/Foundation.h>

#import "SWSingleton.h"

@interface SWUserInfo : NSObject

SW_AS_SINGLETON(SWUserInfo, shareInstance);

@property (nonatomic,strong) NSString *headImagePath;
@property (nonatomic,strong) NSString *name;
@property (nonatomic) NSInteger sex;
@property (nonatomic,strong)NSString *birthdayString;
@property (nonatomic)NSInteger height;
@property (nonatomic)NSInteger weight;
@property (nonatomic,strong)NSString *physiologicalDateString;
@property (nonatomic)NSInteger physiologicalDays;

- (void)loadDataWithDictionary:(NSDictionary *)dictionary;
- (void)setup;

@end
