//
//  HTMutableSQLBuffer.m
//  WristBand
//
//  Created by zhuzhi on 13-8-3.
//  Copyright (c) 2013年 WB. All rights reserved.
//

#import "WBMutableSQLBuffer.h"

@interface WBMutableSQLBuffer () {
    NSMutableArray *sqlBuffers;
}

@end

@implementation WBMutableSQLBuffer


- (id)initWithBatchSqls:(NSArray *)batchSqls {
    
    self = [super init];
    
    if (self) {
        sqlBuffers = [NSMutableArray arrayWithArray:batchSqls];
    }
    
    return self;
}

- (id)init {
    
    self = [super init];
    
    if (self) {
        sqlBuffers = [NSMutableArray array];
    }
    
    return self;
}

- (NSArray *)batchSqls {
    NSMutableArray *sqls = [NSMutableArray arrayWithCapacity:sqlBuffers.count];
    for (WBSQLBuffer *buffer in sqlBuffers) {
		if (buffer.sql.length > 0) {
			[sqls addObject:buffer.sql];
		}
    }
    return sqls;
}

- (void)addBuffer:(WBSQLBuffer *)buffer {
    [sqlBuffers addObject:buffer];
}

@end
