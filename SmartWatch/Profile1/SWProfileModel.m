//
//  SWProfileModel.m
//  SmartWatch
//
//  Created by zhuzhi on 14/12/13.
//
//

#import "SWProfileModel.h"
#import "WBDatabaseService.h"
#import "WBSQLBuffer.h"
#import "SWPROFILE.h"
#import "SWUserInfo.h"
#import "WBPath.h"

@implementation SWProfileModel

- (instancetype)initWithResponder:(id)responder {
    self = [super initWithResponder:responder];
    if (self) {
        WBSQLBuffer *sqlBuffer = [[WBSQLBuffer alloc] init];
        sqlBuffer.SELECT(@"*").FROM(DBPROFILE._tableName);
        WBDatabaseTransaction *transaction = [[WBDatabaseTransaction alloc] initWithSQLBuffer:sqlBuffer];
        [[WBDatabaseService defaultService] readWithTransaction:transaction completionBlock:^{}];
        if (transaction.resultSet.resultArray.count > 0) {
            [[SWUserInfo shareInstance] loadDataWithDictionary:transaction.resultSet.resultArray.firstObject];
        }
    }
    
    return  self;
}

- (void)updateToDB {
    WBMutableSQLBuffer *mutableSqlBuffer = [[WBMutableSQLBuffer alloc] init];
    
    WBSQLBuffer *deleteSqlbuffer = [[WBSQLBuffer alloc] init];
    deleteSqlbuffer.DELELTE(DBPROFILE._tableName).WHERE([NSString stringWithFormat:@"1=1"]);
    [mutableSqlBuffer addBuffer:deleteSqlbuffer];
    
    WBSQLBuffer *sqlBuffer = [[WBSQLBuffer alloc] init];
    sqlBuffer.INSERT(DBPROFILE._tableName);
    if ([SWUserInfo shareInstance].headImagePath.length > 0) {
        sqlBuffer.SET(DBPROFILE._PHOTOPATH, [SWUserInfo shareInstance].headImagePath);
    } else {
        sqlBuffer.SET(DBPROFILE._PHOTOPATH, @"");
    }
    
    if ([SWUserInfo shareInstance].name.length > 0) {
        sqlBuffer.SET(DBPROFILE._NAME, [SWUserInfo shareInstance].name);
    } else {
        sqlBuffer.SET(DBPROFILE._NAME, @"");
    }
    sqlBuffer.SET(DBPROFILE._BIRTHDAY,[[SWUserInfo shareInstance] birthdayString]);
    sqlBuffer.SET(DBPROFILE._SEX,@([[SWUserInfo shareInstance] sex]));
    sqlBuffer.SET(DBPROFILE._HEIGHT,@([[SWUserInfo shareInstance] height]));
    sqlBuffer.SET(DBPROFILE._WEIGHT,@([[SWUserInfo shareInstance] weight]));
    sqlBuffer.SET(DBPROFILE._PHYSIOLOGICALDAYS,@([[SWUserInfo shareInstance] physiologicalDays]));
    sqlBuffer.SET(DBPROFILE._PHYSIOLOGICALDATESTRING,[[SWUserInfo shareInstance] physiologicalDateString]);
    [mutableSqlBuffer addBuffer:sqlBuffer];
    
    WBDatabaseTransaction *transaction = [[WBDatabaseTransaction alloc] initWithMutalbeSQLBuffer:mutableSqlBuffer];

    [[WBDatabaseService defaultService] writeWithTransaction:transaction completionBlock:^{
    }];

}

- (void)saveHeadImage:(UIImage *)headImage {
    NSString *headImageName = @"headImage.jpg";
    NSString *headImagePath = [[WBPath documentPath] stringByAppendingPathComponent:headImageName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:headImagePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:headImagePath error:NULL];
    }
    [UIImageJPEGRepresentation(headImage, 0.7) writeToFile:headImagePath atomically:YES];
    [[SWUserInfo shareInstance] setHeadImagePath:headImageName];
    [self updateToDB];
}

- (void)saveName:(NSString *)name {
    [[SWUserInfo shareInstance] setName:name];
    [self updateToDB];
}

- (void)saveBirthday:(NSString *)birthdayString {
    [[SWUserInfo shareInstance] setBirthdayString:birthdayString];
    [self updateToDB];
}

- (void)saveSex:(NSInteger)sex {
    [[SWUserInfo shareInstance] setSex:sex];
    [self updateToDB];
}

- (void)saveHeight:(NSInteger)height {
    [[SWUserInfo shareInstance] setHeight:height];
    [self updateToDB];
}

- (void)saveWeight:(NSInteger)weight {
    [[SWUserInfo shareInstance] setWeight:weight];
    [self updateToDB];
}

- (void)savePhysiologicalDays:(NSInteger)days {
    [[SWUserInfo shareInstance] setPhysiologicalDays:days];
    [self updateToDB];
}

- (void)savePhysiologicalDate:(NSString *)dateString {
    [[SWUserInfo shareInstance] setPhysiologicalDateString:dateString];
    [self updateToDB];
}

@end
