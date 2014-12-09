//
//  HTMutableSQLBuffer.h
//  WristBand
//
//  Created by zhuzhi on 13-8-3.
//  Copyright (c) 2013年 WB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBSQLBuffer.h"

@interface WBMutableSQLBuffer : NSObject

@property (nonatomic) Class entity;

- (id)initWithBatchSqls:(NSArray *)batchSqls;
- (NSArray *)batchSqls;

- (void)addBuffer:(WBSQLBuffer *)buffer;

@end
