//
//  SWProfileModel.h
//  SmartWatch
//
//  Created by zhuzhi on 14/12/13.
//
//

#import "SWModel.h"

@interface SWProfileModel : SWModel

- (void)saveHeadImage:(UIImage *)headImage;
- (void)saveName:(NSString *)name;
- (void)saveBirthday:(NSString *)birthdayString;
- (void)saveSex:(NSInteger)sex;
- (void)saveHeight:(NSInteger)height;
- (void)saveWeight:(NSInteger)weight;

@end
