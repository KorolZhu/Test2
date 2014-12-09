//
//  HTDatabaseService.h
//  WristBand
//
//  Created by zhuzhi on 14-4-21.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBDatabaseTransaction.h"

@interface WBDatabaseService : NSObject

+ (WBDatabaseService *)defaultService;

- (void)readWithTransaction:(WBDatabaseTransaction *)transaction
			completionBlock:(dispatch_block_t)completionBlock;

- (void)writeWithTransaction:(WBDatabaseTransaction *)transaction
				 completionBlock:(dispatch_block_t)completionBlock;

- (void)asyncReadWithTransaction:(WBDatabaseTransaction *)transaction
				 completionBlock:(dispatch_block_t)completionBlock;

- (void)asyncWriteWithTransaction:(WBDatabaseTransaction *)transaction
					  completionBlock:(dispatch_block_t)completionBlock;

@end
