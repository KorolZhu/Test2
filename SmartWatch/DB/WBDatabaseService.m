//
//  HTDatabaseService.m
//  WristBand
//
//  Created by zhuzhi on 14-4-21.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import "WBDatabaseService.h"
#import "FMDatabaseQueue.h"
#import "WBFMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMDatabaseAdditions.h"
#import "WBDatabaseLogicType.h"
#import "WBPath.h"

#define DBNAME @"Model.sqlite"

@interface WBDatabaseService ()
{
	dispatch_queue_t readQueue;
	dispatch_queue_t writeQueue;
	
	dispatch_queue_t completionQueue;

	WBFMDatabase *readDatabase;
	FMDatabaseQueue *writeDatabaseQueue;
}

@end

@implementation WBDatabaseService

static WBDatabaseService *databaseService = nil;

+ (WBDatabaseService *)defaultService {
    if (!databaseService) databaseService = [[self alloc] init];
    if (!databaseService) databaseService = [[self alloc] init];
    if (!databaseService) databaseService = [[self alloc] init];
    
    return databaseService;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *defaultDbPath = [NSString stringWithFormat:@"%@/%@", [WBPath documentPath], DBNAME];
        if (![[NSFileManager defaultManager] fileExistsAtPath:defaultDbPath]) {
            WBFMDatabase *defaultDatabase = [[WBFMDatabase alloc] initWithPath:defaultDbPath];
            BOOL result = [self createTable:defaultDatabase];
            if (result) {
                if ([defaultDatabase open]) {
                    [defaultDatabase setUserVersion:DATABASE_VERSION];
                    [defaultDatabase close];
                }
            } else {
                [[NSFileManager defaultManager] removeItemAtPath:defaultDbPath error:NULL];
            }
        } else {
            WBFMDatabase *defaultDatabase = [[WBFMDatabase alloc] initWithPath:defaultDbPath];
            if ([defaultDatabase open]) {
                unsigned int version = [defaultDatabase userVersion];
                if (version != DATABASE_VERSION) {
                    [[NSFileManager defaultManager] removeItemAtPath:defaultDbPath error:NULL];
                    [defaultDatabase close];
                    return nil;
                }
                [defaultDatabase close];
            }
        }
        
        readDatabase = [[WBFMDatabase alloc] initWithPath:defaultDbPath];
        writeDatabaseQueue = [FMDatabaseQueue databaseQueueWithPath:defaultDbPath];
        
        readQueue = dispatch_queue_create("com.hellotalk.readDbQueue", NULL);
        writeQueue = dispatch_queue_create("com.hellotalk.writeDbQueue", NULL);
        completionQueue = dispatch_queue_create("com.hellotalk.dbCompletionQueue", DISPATCH_QUEUE_CONCURRENT);
        
        [readDatabase open];
    }
    return self;
}

- (BOOL)createTable:(WBFMDatabase *)database
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"default" ofType:@"sql"];
    NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *sqls = [string componentsSeparatedByString:@";"];
    
    BOOL succeed = NO;
    int tryTimes = 3;
    do {
        if ([database open]) {
            [database beginTransaction];
            
            succeed = YES;
            
            for (NSString *sql in sqls) {
                if ([sql length] > 0) {
                    succeed = succeed && [database executeUpdate:sql];
                    if (!succeed) break;
                }
            }
            if (succeed) {
                succeed = succeed && [database commit];
            }
            else{
                NSLog(@"create table error : %d \"%@\"",[database lastErrorCode], [database lastErrorMessage]);
                [database rollback];
            }
            [database close];
        }
        tryTimes--;
    } while (!succeed && tryTimes > 0);
    
    return succeed;
}

- (dispatch_block_t)readBlockWithTransaction:(WBDatabaseTransaction *)transaction {
	dispatch_block_t block = ^{
		if (transaction.operationType == HTDatabaseOperationTypeQuery) {
			FMResultSet *result =  [readDatabase executeQuery:transaction.sqlBuffer.sql];
			NSMutableArray *resultArr;
			while ([result next]){
				if (!resultArr)
					resultArr = [NSMutableArray array];
				if (result.resultDictionary)
					[resultArr addObject:[result resultDictionary]];
			}
			WBDatabaseResultSet *resultSet = [[WBDatabaseResultSet alloc] init];
			resultSet.resultArray = resultArr;
//			resultSet.resultCode = result ? SQLITE_OK : SQLITE_ERROR;
			
			if (result) {
                resultSet.resultCode = HTDatabaseResultSucceed;
			}
            else {
                resultSet.resultCode = HTDatabaseResultFailed;
			}
			transaction.resultSet = resultSet;
		} else if (transaction.operationType == HTDatabaseOperationTypeBatchQuery) {
			NSMutableArray *resultArray = [NSMutableArray array];
			BOOL succeed = YES;
			for (NSString *sql in [transaction.mutableSQLBuffer batchSqls]) {
				FMResultSet *result =  [readDatabase executeQuery:sql];
				NSMutableArray *temp = [NSMutableArray array];
				if (result) {
					while ([result next]){
						if (result.resultDictionary)
							[temp addObject:[result resultDictionary]];
					}
				}
				else{
					succeed = NO;
				}
				[resultArray addObject:temp];
			}
			
			WBDatabaseResultSet *resultSet = [[WBDatabaseResultSet alloc] init];
			resultSet.resultArray = resultArray;
//            resultSet.resultCode = succeed ? SQLITE_OK : SQLITE_ERROR;
			if (succeed)
                resultSet.resultCode = HTDatabaseResultSucceed;
            else{
                resultSet.resultCode = HTDatabaseResultFailed;
            }
			
			transaction.resultSet = resultSet;
		}
	};
	
	return block;
}

- (dispatch_block_t)writeBlockWithTransaction:(WBDatabaseTransaction *)transaction {
	dispatch_block_t block = ^{
		[writeDatabaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
			BOOL succeed = YES;
			for (NSString *sql in [transaction sqls]) {
				succeed &= [db executeUpdate:sql];
				if (!succeed) {
					if (db.lastErrorCode == SQLITE_CONSTRAINT) {
						succeed = YES;
						continue;
					}
					break;
				}
			}
			
			WBDatabaseResultSet *resultSet = [[WBDatabaseResultSet alloc] init];
			if (!succeed) {
				resultSet.resultCode = HTDatabaseResultFailed;
				*rollback = YES;
			}
			else{
				resultSet.resultCode = HTDatabaseResultSucceed;
			}
			transaction.resultSet = resultSet;
		}];
	};
	
	return block;
}

- (void)readWithTransaction:(WBDatabaseTransaction *)transaction completionBlock:(dispatch_block_t)completionBlock {
	dispatch_sync(readQueue, ^{
		@autoreleasepool {
			[self readBlockWithTransaction:transaction]();
		}
	});
	
	completionBlock();
}

- (void)writeWithTransaction:(WBDatabaseTransaction *)transaction completionBlock:(dispatch_block_t)completionBlock {
	dispatch_sync(writeQueue, ^{
		@autoreleasepool {
			[self writeBlockWithTransaction:transaction]();
		}
	});
	
	completionBlock();
}

- (void)asyncReadWithTransaction:(WBDatabaseTransaction *)transaction completionBlock:(dispatch_block_t)completionBlock {
	dispatch_async(readQueue, ^{
		@autoreleasepool {
			[self readBlockWithTransaction:transaction]();
			
			completionBlock();
		}
	});
}

- (void)asyncWriteWithTransaction:(WBDatabaseTransaction *)transaction completionBlock:(dispatch_block_t)completionBlock {
	dispatch_async(writeQueue, ^{
		@autoreleasepool {
			[self writeBlockWithTransaction:transaction]();
			
			completionBlock();
		}
	});
}

@end
