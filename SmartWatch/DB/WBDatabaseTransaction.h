//
//  WBDatabaseTransaction.h
//  WristBand
//
//  Created by zhuzhi on 14/11/24.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBDatabaseLogicType.h"
#import "WBSQLBuffer.h"
#import "WBMutableSQLBuffer.h"
#import "WBDatabaseResultSet.h"

@interface WBDatabaseTransaction : NSObject

@property (nonatomic) HTDatabaseOperationType operationType;
@property (nonatomic) HTDatabaseLogicType logicType;
@property (nonatomic, strong) WBSQLBuffer *sqlBuffer;
@property (nonatomic, strong) WBMutableSQLBuffer *mutableSQLBuffer;
@property (nonatomic, strong) WBDatabaseResultSet *resultSet;
// 是否批量操作
@property (nonatomic) BOOL batch;

- (id)initWithSQLBuffer:(WBSQLBuffer *)sqlBuffer;
- (id)initWithMutalbeSQLBuffer:(WBMutableSQLBuffer *)mutableSQLBuffer;

- (NSArray *)sqls;

@end
