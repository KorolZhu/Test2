//
//  WBSQLBuffer.h
//  WristBand
//
//  Created by zhuzhi on 13-6-22.
//  Copyright (c) 2013年 WB. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WBSQLBuffer;

typedef WBSQLBuffer * (^WBSQLBufferBlockV)(void);
typedef WBSQLBuffer * (^WBSQLBufferBlockS)(NSString *string);
typedef WBSQLBuffer * (^WBSQLBufferBlockSS)(NSString *string1,NSString *stirng2);
typedef WBSQLBuffer * (^WBSQLBufferBlockU)(NSUInteger value);
typedef WBSQLBuffer * (^WBSQLBufferBlockKV)(NSString* key,id value);
typedef WBSQLBuffer * (^WBSQLBufferBlockD)(id params);

typedef WBSQLBuffer * (^WBSQLBufferBlockVaList)(id param,...);

#define HANDLESQL(sql) [WBSQLBuffer handleSpecialSQL:sql]

#define SQLTableField(tableName,field)         [NSString stringWithFormat:@"%@.%@",tableName,field]
#define SQLTableFieldEqual(tableName1,field1,tableName2,field2)         [NSString stringWithFormat:@"%@.%@=%@.%@",tableName1,field1,tableName2,field2]

#define SQLFieldEqual(field1,field2)           [NSString stringWithFormat:@"%@=%@",field1,field2]

#define SQLStringEqual(field,value)            [NSString stringWithFormat:@"%@='%@'",field,value]
#define SQLStringNotEqual(field,value)         [NSString stringWithFormat:@"%@!='%@'",field,value]
#define SQLStringIn(field,array)               [HTSQLBuffer SQLString:field inArray:array]

#define SQLNumberEqual(field,value)            [NSString stringWithFormat:@"%@=%d",field,value]
#define SQLNumberNotEqual(field,value)         [NSString stringWithFormat:@"%@!=%d",field,value]
#define SQLNumberGreater(field,value)          [NSString stringWithFormat:@"%@>%d",field,value]
#define SQLNumberLess(field,value)             [NSString stringWithFormat:@"%@<%d",field,value]
#define SQLNumberGreaterOrEqual(field,value)   [NSString stringWithFormat:@"%@>=%d",field,value]
#define SQLNumberLessOrEqual(field,value)      [NSString stringWithFormat:@"%@<=%d",field,value]
#define SQLNumberBetween(field,value1,value2)  [NSString stringWithFormat:@"(%@=>%d AND %@<=%d)",field,value1,field,value2]
#define SQLNumberIn(field,array)               [HTSQLBuffer SQLNumber:field inArray:array]

#define DESC @"DESC"
#define ASC  @"ASC"

#define LEFT_JOIN @"LEFT JOIN"
#define INNER_JOIN @"INNER JOIN"

@interface WBSQLBuffer : NSObject

@property (nonatomic,readonly) WBSQLBufferBlockS INSERT;
@property (nonatomic,readonly) WBSQLBufferBlockS UPDATE;
@property (nonatomic,readonly) WBSQLBufferBlockS DELELTE;
@property (nonatomic,readonly) WBSQLBufferBlockS REPLACE;

@property (nonatomic,readonly) WBSQLBufferBlockS SELECT;
@property (nonatomic,readonly) WBSQLBufferBlockVaList SELECT_S;
@property (nonatomic,readonly) WBSQLBufferBlockS FROM;
@property (nonatomic,readonly) WBSQLBufferBlockVaList FROM_S;

@property (nonatomic,readonly) WBSQLBufferBlockS WHERE;
@property (nonatomic,readonly) WBSQLBufferBlockS AND;
@property (nonatomic,readonly) WBSQLBufferBlockS OR;
@property (nonatomic,readonly) WBSQLBufferBlockKV LIKE;
@property (nonatomic,readonly) WBSQLBufferBlockKV SET;
@property (nonatomic,readonly) WBSQLBufferBlockKV SET_A;

@property (nonatomic,readonly) WBSQLBufferBlockS GROUPBY;
@property (nonatomic,readonly) WBSQLBufferBlockSS ORDERBY;
@property (nonatomic,readonly) WBSQLBufferBlockU LIMIT;
@property (nonatomic,readonly) WBSQLBufferBlockU OFFSET;
@property (nonatomic) BOOL distinct;

@property (nonatomic) Class entity;
//@property (nonatomic,strong,readonly) NSArray *queryFields;

- (id)initWithSQL:(NSString *)sql;
- (NSString *)sql;

+ (NSString *)handleSpecialSQL:(NSString *)sql;
+ (NSString *)SQLString:(NSString *)field inArray:(NSArray *)array;
+ (NSString *)SQLNumber:(NSString *)field inArray:(NSArray *)array;

@end
