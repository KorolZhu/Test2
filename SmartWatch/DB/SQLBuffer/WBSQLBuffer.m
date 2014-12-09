//
//  WBSQLBuffer.m
//  WristBand
//
//  Created by zhuzhi on 13-6-22.
//  Copyright (c) 2013年 WB. All rights reserved.
//

#import "WBSQLBuffer.h"

@interface WBSQLBuffer ()

@property (nonatomic, strong) NSString *sqlString;

@property (nonatomic, strong) NSString  *insert;
@property (nonatomic, strong) NSString  *update;
@property (nonatomic, strong) NSString  *delete;
@property (nonatomic, strong) NSString  *replace;

@property (nonatomic, strong) NSMutableDictionary *set;

@property (nonatomic, strong) NSMutableArray *select;

@property (nonatomic, strong) NSMutableArray *from;

@property (nonatomic, strong) NSMutableArray    *where;
@property (nonatomic, strong) NSMutableArray    *like;
@property (nonatomic, strong) NSMutableArray    *groupby;
@property (nonatomic, strong) NSMutableArray    *orderby;

@property (nonatomic) NSInteger limit;
@property (nonatomic) NSInteger offset;




@end

@implementation WBSQLBuffer

- (id)init {
    self = [super init];

    if (self) {
        self.select = [NSMutableArray array];
        self.from = [NSMutableArray array];
        self.where = [NSMutableArray array];
        self.like = [NSMutableArray array];
        self.groupby = [NSMutableArray array];
        self.orderby = [NSMutableArray array];
        self.set = [NSMutableDictionary dictionary];
    }

    return self;
}

- (id)initWithSQL:(NSString *)sql {
    self = [super init];

    if (self) {
        self.sqlString = sql;
    }

    return self;
}

- (WBSQLBufferBlockS)INSERT {
    WBSQLBufferBlockS block = ^WBSQLBuffer *(NSString *string) {
        self.insert = [string uppercaseString];
        return self;
    };

    return [block copy];
}

- (WBSQLBufferBlockS)REPLACE{
    WBSQLBufferBlockS block = ^WBSQLBuffer *(NSString *string) {
        self.replace = [string uppercaseString];
        return self;
    };
    
    return [block copy];
}

- (WBSQLBufferBlockS)UPDATE {
    WBSQLBufferBlockS block = ^WBSQLBuffer *(NSString *string) {
        self.update = [string uppercaseString];
        return self;
    };

    return [block copy];
}

- (WBSQLBufferBlockS)DELELTE {
    WBSQLBufferBlockS block = ^WBSQLBuffer *(NSString *string) {
        self.delete = [string uppercaseString];
        return self;
    };

    return [block copy];
}

- (WBSQLBufferBlockS)SELECT {
    WBSQLBufferBlockS block = ^WBSQLBuffer *(NSString *string) {
        if ([string containString:@","]) {
            NSArray *array = [string componentsSeparatedByString:@","];

            [self.select addObjectsFromArray:array];
        } else {
            [self.select addObject:string];
        }

        return self;
    };

    return [block copy];
}

- (WBSQLBufferBlockVaList)SELECT_S {
    WBSQLBufferBlockVaList block = ^WBSQLBuffer *(NSString *param,...) {
        
        NSMutableArray *array = [NSMutableArray array];
        
        va_list argList;
        va_start(argList, param);
        
        NSString *arg = param;
        [array addObject:param];
        
        while ((arg = va_arg(argList,id)))
        {
            if ([arg isKindOfClass:[NSString class]]) {
                [array addObject:arg];
            }
        }
        
        if (arg) {
            [NSException raise:@"SELECTS多参数错误" format:@"SELECT多参数时需要以nil结束!传入参数为%@",array];
        }
        
        va_end(argList);
        
        [self.select addObject:[array componentsJoinedByString:@","]];
        return self;
    };
    
    return [block copy];
}

- (WBSQLBufferBlockS)FROM {
    WBSQLBufferBlockS block = ^WBSQLBuffer *(NSString *string) {
        if ([string containString:@","]) {
            NSArray *array = [string componentsSeparatedByString:@","];

            [self.from addObjectsFromArray:array];
        } else {
            [self.from addObject:string];
        }

        return self;
    };

    return [block copy];
}


- (WBSQLBufferBlockVaList)FROM_S {
    WBSQLBufferBlockVaList block = ^WBSQLBuffer *(NSString *param,... ) {
        
        NSMutableArray *array = [NSMutableArray array];
        
        va_list argList;
        va_start(argList, param);
        
        NSString *arg = param;
        [array addObject:param];
        
        while ((arg = va_arg(argList,id)))
        {
            [array addObject:arg];
        }
        
        va_end(argList);
        
        [self.from addObject:[array componentsJoinedByString:@","]];
        
        return self;
    };
    
    return [block copy];
}



- (WBSQLBufferBlockS)WHERE {
    WBSQLBufferBlockS block = ^WBSQLBuffer *(NSString *string) {
        if (self.where.count > 0) {
            [self.where addObject:[NSString stringWithFormat:@" AND %@", string]];
        } else {
            [self.where addObject:string];
        }

        return self;
    };

    return [block copy];
}

- (WBSQLBufferBlockS)AND {
    WBSQLBufferBlockS block = ^WBSQLBuffer *(NSString *string) {
        if (self.where.count > 0) {
            [self.where addObject:[NSString stringWithFormat:@" AND %@", string]];
        } else {
            [self.where addObject:self.where];
        }

        return self;
    };

    return [block copy];
}

- (WBSQLBufferBlockS)OR {
    WBSQLBufferBlockS block = ^WBSQLBuffer *(NSString *string) {
        [self.where addObject:[NSString stringWithFormat:@" OR %@",string]];
        return self;
    };

    return [block copy];
}

- (WBSQLBufferBlockKV)LIKE {
    WBSQLBufferBlockKV block = ^WBSQLBuffer *(NSString *key, NSString *value) {
        [self.like addObject:[NSString stringWithFormat:@" %@ LIKE '%@'", key, value]];
        return self;
    };

    return [block copy];
}

- (WBSQLBufferBlockKV)SET {
    WBSQLBufferBlockKV block = ^WBSQLBuffer *(NSString *key, id value) {
        
        id object = nil;
        
        if ([value isKindOfClass:[NSString class]]) {
            NSString *val = value;
            object = [NSString stringWithFormat:@"'%@'",HANDLESQL(val)];
        } else if ([value isKindOfClass:[NSNumber class]]) {
            if (!value) {
                object = @"0";
            } else {
                object = [(NSNumber *)value stringValue];
            }
        } else {
            if (!value) {
                object = @"''";
            } else {
                object = [NSString stringWithFormat:@"'%@'",value];
            }
        }
        
        [self.set setObject:object forKey:key];
        return self;
    };

    return [block copy];
}

- (WBSQLBufferBlockKV)SET_A {
    WBSQLBufferBlockKV block = ^WBSQLBuffer *(NSString *key, id value) {
        
        id object = nil;
        
        if ([value isKindOfClass:[NSString class]]) {
            NSString *val = value;
            object = [NSString stringWithFormat:@"%@ + %@",key,HANDLESQL(val)];
        } else if ([value isKindOfClass:[NSNumber class]]) {
            object = [NSString stringWithFormat:@"%@ + %@",key,[(NSNumber *)value stringValue]];
        } else {
            object = [NSString stringWithFormat:@"%@ + %@",key,value];
        }
        
        [self.set setObject:object forKey:key];
        return self;
    };
    
    return [block copy];
}

- (WBSQLBufferBlockS)GROUPBY {
    WBSQLBufferBlockS block = ^WBSQLBuffer *(NSString *string) {
        if ([string containString:@","]) {
            NSArray *array = [string componentsSeparatedByString:@","];

            [self.groupby addObjectsFromArray:array];
        } else {
            [self.groupby addObject:string];
        }

        return self;
    };

    return [block copy];
}

- (WBSQLBufferBlockSS)ORDERBY {
    WBSQLBufferBlockSS block = ^WBSQLBuffer *(NSString *field, NSString *direction) {
        [self.orderby addObject:[NSString stringWithFormat:@"%@ %@ ", field, direction]];
        return self;
    };

    return [block copy];
}

- (WBSQLBufferBlockU)LIMIT {
    WBSQLBufferBlockU block = ^WBSQLBuffer *(NSUInteger limit) {
        self.limit = limit;
        return self;
    };

    return [block copy];
}

- (WBSQLBufferBlockU)OFFSET {
    WBSQLBufferBlockU block = ^WBSQLBuffer *(NSUInteger offset) {
        self.offset = offset;
        return self;
    };

    return [block copy];
}

- (NSString *)insertString {
    NSMutableString *sql = [NSMutableString string];

    [sql appendFormat:@"INSERT INTO %@ (", self.insert];

    NSArray         *allKeys = self.set.allKeys;
    NSMutableArray  *allValues = [NSMutableArray array];

    NSString    *field = nil;
    NSString    *value = nil;

    for (int i = 0; i < allKeys.count; i++) {
        NSString *key = [allKeys objectAtIndex:i];

        field = key;
        value = [self.set objectForKey:key];

        if (0 == i) {
            [sql appendString:field];
        } else {
            [sql appendFormat:@", %@", field];
        }

        [allValues addObject:value];
    }

    [sql appendString:@") VALUES ("];

    for (int i = 0; i < allValues.count; i++) {
        value = [allValues objectAtIndex:i];

        if (0 == i) {
            [sql appendString:value];
        } else {
            [sql appendFormat:@", %@", value];
        }
    }

    [sql appendString:@")"];

    return sql;
}

- (NSString *)replaceString{
    NSMutableString *sql = [NSMutableString string];
    
    [sql appendFormat:@"REPLACE INTO %@ (", self.replace];
    
    NSArray         *allKeys = self.set.allKeys;
    NSMutableArray  *allValues = [NSMutableArray array];
    
    NSString    *field = nil;
    NSString    *value = nil;
    
    for (int i = 0; i < allKeys.count; i++) {
        NSString *key = [allKeys objectAtIndex:i];
        
        field = key;
        value = [self.set objectForKey:key];
        
        if (0 == i) {
            [sql appendString:field];
        } else {
            [sql appendFormat:@", %@", field];
        }
        
        [allValues addObject:value];
    }
    
    [sql appendString:@") VALUES ("];
    
    for (int i = 0; i < allValues.count; i++) {
        value = [allValues objectAtIndex:i];
        
        if (0 == i) {
            [sql appendString:value];
        } else {
            [sql appendFormat:@", %@", value];
        }
    }
    
    [sql appendString:@")"];
    
    return sql;
}

- (NSString *)updateString {
    NSMutableString *sql = [NSMutableString string];
    NSArray         *allKeys = self.set.allKeys;
    NSMutableArray  *allValues = [NSMutableArray array];

    NSString    *field = nil;
    NSObject    *value = nil;

    [sql appendFormat:@"UPDATE %@ SET ", self.update];

    for (int i = 0; i < allKeys.count; ++i) {
        NSString *key = [allKeys objectAtIndex:i];

        field = key;
        value = [self.set objectForKey:key];

        if (value) {
            [allValues addObject:value];

            if (0 == i) {
                [sql appendFormat:@"%@ = %@", field, value];
            } else {
                [sql appendFormat:@", %@ = %@", field, value];
            }
        }
    }

    if (self.where.count) {
        [sql appendString:@" WHERE"];

        for (NSString *where in self.where) {
            [sql appendFormat:@" %@", where];
        }
    }

    if (self.groupby.count) {
        [sql appendString:@" GROUP BY "];

        for (NSInteger i = 0; i < self.groupby.count; ++i) {
            NSString *by = [self.groupby objectAtIndex:i];

            if (0 == i) {
                [sql appendString:by];
            } else {
                [sql appendFormat:@", %@", by];
            }
        }
    }

    if (self.orderby.count) {
        [sql appendString:@" ORDER BY "];

        for (NSInteger i = 0; i < self.orderby.count; ++i) {
            NSString *by = [self.orderby objectAtIndex:i];

            if (0 == i) {
                [sql appendString:by];
            } else {
                [sql appendFormat:@", %@", by];
            }
        }
    }

    if (self.limit) {
        [sql appendFormat:@" LIMIT %ld", (long)self.limit];
    }

    return sql;
}

- (NSString *)deleteString {
    if ((0 == self.where.count) && (0 == self.like.count)) {
        NSLog(@"删除表 %@ 没有条件!", self.delete);

        return nil;
    }

    NSMutableString *sql = [NSMutableString string];
    
    [sql appendFormat:@"DELETE FROM %@",self.delete];

    if (self.where.count || self.like.count) {
        [sql appendString:@" WHERE "];

        if (self.where.count) {
            for (NSString *where in self.where) {
                [sql appendFormat:@" %@ ", where];
            }
        }

        if (self.like.count) {
            if (self.where.count) {
                [sql appendString:@" AND "];
            }

            for (NSString *like in self.like) {
                [sql appendFormat:@" %@ ", like];
            }
        }
    }

    if (self.limit) {
        [sql appendFormat:@" LIMIT %ld", (long)self.limit];
    }

    return sql;
}

- (NSString *)selectString {
    NSMutableString *sql = [NSMutableString string];

    if (self.distinct) {
        [sql appendString:@"SELECT DISTINCT "];
    } else {
        [sql appendString:@"SELECT "];
    }

//    NSMutableArray *queryFields = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.select.count; i++) {
        NSString    *param = [[self.select objectAtIndex:i] trim];
        NSString    *string = nil;

        if ([param containString:@"."]) {
            NSArray     *params = [param componentsSeparatedByString:@"."];
            NSString    *table = [params objectAtIndex:0];
            NSString    *field = [params.lastObject uppercaseString];
            
//            [queryFields addObject:params.lastObject];
            string = [NSString stringWithFormat:@"%@.%@", table, field];
        } else {
            string = [param uppercaseString];
        }

        if (i == 0) {
            [sql appendFormat:@"%@ ", string];
        } else {
            [sql appendFormat:@", %@ ", string];
        }
    }
    
//    _queryFields = queryFields;

    [sql appendString:@"FROM "];

    for (int i = 0; i < self.from.count; i++) {
        NSString *param = [[self.from objectAtIndex:i] trim];

        NSString *string = nil;

        if ([param containString:@"."]) {
            NSArray     *params = [param componentsSeparatedByString:@"."];
            NSString    *table = [params objectAtIndex:0];
            NSString    *field = [params.lastObject uppercaseString];
            string = [NSString stringWithFormat:@"%@.%@", table, field];
        } else {
            string = [param uppercaseString];
        }

        if (i == 0) {
            [sql appendFormat:@"%@ ", string];
        } else {
            [sql appendFormat:@",%@ ", string];
        }
    }

    if (self.where.count || self.like.count) {
        [sql appendString:@" WHERE"];
    }

    if (self.where.count) {
        for (NSString *where in self.where) {
            [sql appendFormat:@" %@ ",where];
        }
    }

    if (self.like.count) {
        if (self.where.count) {
            [sql appendString:@" AND "];
        }

        for (NSString *like in self.like) {
            [sql appendFormat:@" %@ ", like];
        }
    }

    if (self.groupby.count) {
        [sql appendString:@" GROUP BY "];

        for (NSInteger i = 0; i < self.groupby.count; ++i) {
            NSString *by = [self.groupby objectAtIndex:i];

            if (0 == i) {
                [sql appendString:by];
            } else {
                [sql appendFormat:@", %@", by];
            }
        }
    }

    if (self.orderby.count) {
        [sql appendString:@" ORDER BY "];

        for (NSInteger i = 0; i < self.orderby.count; ++i) {
            NSString *by = [self.orderby objectAtIndex:i];

            if (0 == i) {
                [sql appendString:by];
            } else {
                [sql appendFormat:@", %@", by];
            }
        }
    }

    if (self.limit) {
        if (self.offset) {
            [sql appendFormat:@" LIMIT %ld, %ld", (long)self.offset, (long)self.limit];
        } else {
            [sql appendFormat:@" LIMIT %ld", (long)self.limit];
        }
    }

    return sql;
}

- (NSString *)sql {
    if (self.sqlString) {
        return self.sqlString;
    }

    if (self.insert) {
        self.sqlString = [self insertString];
    } else if (self.replace){
        self.sqlString = [self replaceString];
    } else if (self.update) {
        self.sqlString = [self updateString];
    } else if (self.delete) {
        self.sqlString = [self deleteString];
    } else {
        self.sqlString = [self selectString];
    }
    
    NSLog(@"%@", self.sqlString);

    return self.sqlString;
}

+ (NSString *)handleSpecialSQL:(NSString *)sql {
    
    if (sql.length == 0) {
        return @"";
    }
    
    NSString *string = [sql stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    string = [string stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    
    return string;
}

+ (NSString *)SQLString:(NSString *)field inArray:(NSArray *)array {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSString *value in array) {
        [tempArray addObject:[NSString stringWithFormat:@"'%@'",value]];
    }
    NSString *string = [NSString stringWithFormat:@"%@ in (%@) ",field,[tempArray componentsJoinedByString:@","]];
    return string;
}

+ (NSString *)SQLNumber:(NSString *)field inArray:(NSArray *)array {
    NSString *string = [NSString stringWithFormat:@"%@ in (%@) ",field,[array componentsJoinedByString:@","]];
    return string;
}


@end