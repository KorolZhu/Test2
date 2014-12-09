//
//  WBDatabaseTransaction.m
//  WristBand
//
//  Created by zhuzhi on 14/11/24.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import "WBDatabaseTransaction.h"

@implementation WBDatabaseTransaction

- (id)initWithSQLBuffer:(WBSQLBuffer *)sqlBuffer {
    self = [super init];
    
    if (self) {
        self.sqlBuffer = sqlBuffer;
        
        NSString *sql = sqlBuffer.sql;
        if ([sql hasPrefix:@"SELECT"]) {
            self.operationType = HTDatabaseOperationTypeQuery;
        } else if ([sql hasPrefix:@"UPDATE"]) {
            self.operationType = HTDatabaseOperationTypeUpdate;
        } else if ([sql hasPrefix:@"INSERT"]) {
            self.operationType = HTDatabaseOperationTypeInsert;
        } else if ([sql hasPrefix:@"DELETE"]) {
            self.operationType = HTDatabaseOperationTypeDelete;
        }
    }
    
    return self;
}

- (id)initWithMutalbeSQLBuffer:(WBMutableSQLBuffer *)mutableSQLBuffer {
    self = [super init];
    
    if (self) {
        self.batch = YES;
        
        self.mutableSQLBuffer = mutableSQLBuffer;
        
        NSString *sql = [[mutableSQLBuffer batchSqls] lastObject];
        if ([sql hasPrefix:@"SELECT"]) {
            self.operationType = HTDatabaseOperationTypeQuery;
        } else if ([sql hasPrefix:@"UPDATE"]) {
            self.operationType = HTDatabaseOperationTypeUpdate;
        } else if ([sql hasPrefix:@"INSERT"]) {
            self.operationType = HTDatabaseOperationTypeInsert;
        } else if ([sql hasPrefix:@"DELETE"]) {
            self.operationType = HTDatabaseOperationTypeDelete;
        }
    }
    
    return self;
}

- (NSArray *)sqls {
    if (self.batch) {
        return [self.mutableSQLBuffer batchSqls];
    } else {
        return [NSArray arrayWithObject:self.sqlBuffer.sql];
    }
}

@end
