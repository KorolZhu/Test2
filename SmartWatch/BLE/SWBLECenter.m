//
//  SWBLECenter.m
//  SmartWatch
//
//  Created by zhuzhi on 14/12/8.
//
//

#import "SWBLECenter.h"
#import "BLE.h"
#import "SWCmdDefines.h"
#import "SWPacketHeader.h"
#import "SWActivityCountResponse.h"
#import "SWActivityResponse.h"

#import "WBDatabaseService.h"
#import "WBSQLBuffer.h"
#import "SWDAILYSTEPS.h"

NSString *const kSWBLEDataReadCompletionNotification = @"kSWBLEDataReadCompletionNotification";

@interface SWBLECenter ()<BLEDelegate>
{
	SWActivityCountResponse *activityCountResponse;
	int startHour;
}

@property (nonatomic,strong) BLE *ble;

@end

@implementation SWBLECenter

SW_DEF_SINGLETON(SWBLECenter, shareInstance);

- (instancetype)init {
    self = [super init];
    if (self) {
        self.ble = [[BLE alloc] init];
        [self.ble controlSetup];
        self.ble.delegate = self;
    }
    
    return self;
}

- (void)connectDevice {
    if (self.state == CBPeripheralStateConnected) {
        return;
    }
    
    _state = SWPeripheralStateConnecting;
    [self.ble findBLEPeripherals:3];
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scanPeripheraTimer) userInfo:nil repeats:NO];
}

- (void)scanPeripheraTimer {
    if (self.ble.peripherals.count > 0) {
        [self.ble connectPeripheral:[self.ble.peripherals objectAtIndex:0]];
    } else {
        _state = SWPeripheralStateDisconnected;
    }
}

- (void)disconnectDevice {
    if (self.ble.activePeripheral) {
        [self.ble.CM cancelPeripheralConnection:self.ble.activePeripheral];
        _state = SWPeripheralStateDisConnecting;
    }
}

#pragma mark - BLE Request

- (void)sendSetDateTimeRequest {
    UInt8 buf[] = {BLE_CMD_SET_DAY_TIME_REQUEST, 20, 14, 12, 15, 20, 30, 00};
    NSData *data = [[NSData alloc] initWithBytes:buf length:8];
    [self.ble write:data];
}

- (void)sendActivityCountRequest {
    UInt8 buf[] = {BLE_CMD_ACTIVITY_COUNT_REQUEST};
    NSData *data = [[NSData alloc] initWithBytes:buf length:1];
    [self.ble write:data];
}

- (void)sendGetActivityRequestWithIndex:(UInt8)index {
    UInt8 buf[] = {BLE_CMD_ACTIVITY_GETBYSN_REQUEST, index, startHour};
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [self.ble write:data];
}

#pragma mark - BLE Response

- (void)handleActivityCountResponse:(NSData *)data {
    activityCountResponse = [[SWActivityCountResponse alloc] initWithData:data];
    activityCountResponse.currentIndex = activityCountResponse.count - 1;
    if (activityCountResponse.count > 0 && activityCountResponse.currentIndex < activityCountResponse.count && activityCountResponse.currentIndex >= 0) {
        [self sendGetActivityRequestWithIndex:activityCountResponse.currentIndex];
    }
}

- (void)handleGetActivityRequest:(NSData *)data {
	SWActivityResponse *response = [[SWActivityResponse alloc] initWithData:data];
    
    if ([@(response.dateYMD).stringValue hasPrefix:@"20"] && @(response.dateYMD).stringValue.length == 8) {
        BOOL isUpdate = NO;
        WBSQLBuffer *isUpdateSqlBuffer = [[WBSQLBuffer alloc] init];
        isUpdateSqlBuffer.SELECT(@"*").FROM(DBDAILYSTEPS._tableName).WHERE([NSString stringWithFormat:@"%@=%@", DBDAILYSTEPS._DATEYMD, @(response.dateYMD).stringValue]);
        WBDatabaseTransaction *isUpdateTransaction = [[WBDatabaseTransaction alloc] initWithSQLBuffer:isUpdateSqlBuffer];
        [[WBDatabaseService defaultService] readWithTransaction:isUpdateTransaction completionBlock:^{}];
        if (isUpdateTransaction.resultSet.resultArray.count > 0) {
            isUpdate = YES;
        }
        
        WBSQLBuffer *sqlBuffer = [[WBSQLBuffer alloc] init];
        if (isUpdate) {
            sqlBuffer.UPDATE(DBDAILYSTEPS._tableName);
            sqlBuffer.WHERE([NSString stringWithFormat:@"%@=%@", DBDAILYSTEPS._DATEYMD, @(response.dateYMD).stringValue]);
        } else {
            sqlBuffer.INSERT(DBDAILYSTEPS._tableName);
            sqlBuffer.SET(DBDAILYSTEPS._DATEYMD, @(response.dateYMD).stringValue);
        }
        
        sqlBuffer.SET([NSString stringWithFormat:@"%@%d", DBDAILYSTEPS._STEPCOUNT, response.startHour], @(response.value0));
        sqlBuffer.SET([NSString stringWithFormat:@"%@%d", DBDAILYSTEPS._STEPCOUNT, response.startHour + 1], @(response.value1));
        sqlBuffer.SET([NSString stringWithFormat:@"%@%d", DBDAILYSTEPS._STEPCOUNT, response.startHour + 2], @(response.value2));
        sqlBuffer.SET([NSString stringWithFormat:@"%@%d", DBDAILYSTEPS._STEPCOUNT, response.startHour + 3], @(response.value3));
        sqlBuffer.SET([NSString stringWithFormat:@"%@%d", DBDAILYSTEPS._STEPCOUNT, response.startHour + 4], @(response.value4));
        sqlBuffer.SET([NSString stringWithFormat:@"%@%d", DBDAILYSTEPS._STEPCOUNT, response.startHour + 5], @(response.value5));
        WBDatabaseTransaction *transaction = [[WBDatabaseTransaction alloc] initWithSQLBuffer:sqlBuffer];
        [[WBDatabaseService defaultService] writeWithTransaction:transaction completionBlock:^{}];
    }

	startHour += 6;
	if (startHour <= 18) {
		[self sendGetActivityRequestWithIndex:activityCountResponse.currentIndex];
	} else {
        if (activityCountResponse.currentIndex == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kSWBLEDataReadCompletionNotification object:nil];
            
            return;
        }
        
		startHour = 0;
		activityCountResponse.currentIndex--;
		if (activityCountResponse.currentIndex >= 0) {
			[self sendGetActivityRequestWithIndex:activityCountResponse.currentIndex];
		}
	}
}

#pragma mark - BLE delegate

- (void)bleDidConnect {
    _state = SWPeripheralStateConnected;
    
    [self sendActivityCountRequest];
//    [self sendSetDateTimeRequest];
}

- (void)bleDidWriteValue {
    
}

- (void)bleDidDisconnect {
    _state = SWPeripheralStateDisconnected;
	
	activityCountResponse = nil;
}

- (void)bleDidReceiveData:(NSData *)data {
    if (data.length >= 20) {
        SWPacketHeader *response = [[SWPacketHeader alloc] initWithData:data];
        switch (response.cmdID) {
            case BLE_CMD_ACTIVITY_COUNT_RESPONSE:
                [self handleActivityCountResponse:data];
                break;
            case BLE_CMD_ACTIVITY_GETBYSN_RESPONSE:
                [self handleGetActivityRequest:data];
                break;
            case BLE_CMD_SET_DAY_TIME_RESPONSE:
                
                break;
            default:
                break;
        }
    }
}

@end
