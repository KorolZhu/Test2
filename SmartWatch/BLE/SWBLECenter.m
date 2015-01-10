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

#import "SWAlarmInfo.h"
#import "SWUserInfo.h"

NSString *const kSWBLEDataReadCompletionNotification = @"kSWBLEDataReadCompletionNotification";

@interface SWBLECenter ()<BLEDelegate>
{
	SWActivityCountResponse *activityCountResponse;
	int activitystartHour;
}

@end

@implementation SWBLECenter

SW_DEF_SINGLETON(SWBLECenter, shareInstance);

- (instancetype)init {
    self = [super init];
    if (self) {
        _ble = [[BLE alloc] init];
        [self.ble controlSetup];
        self.ble.delegate = self;
    }
    
    return self;
}

- (void)scanBLEPeripherals {
    [self.ble findBLEPeripherals];
}

- (void)stopScanBLEPeripherals {
    [self.ble.CM stopScan];
}

- (void)connectPeripheral:(CBPeripheral *)eripheral {
    self.state = SWPeripheralStateConnecting;
    [self.ble connectPeripheral:[self.ble.peripherals objectAtIndex:0]];
}

- (void)connectDevice {
    if (self.state == CBPeripheralStateConnected) {
        return;
    }
    
    self.state = SWPeripheralStateConnecting;
    [self.ble findBLEPeripherals:3];
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scanPeripheraTimer) userInfo:nil repeats:NO];
}

- (void)scanPeripheraTimer {
    if (self.ble.peripherals.count > 0) {
        [self.ble connectPeripheral:[self.ble.peripherals objectAtIndex:0]];
    } else {
        self.state = SWPeripheralStateDisconnected;
    }
}

- (void)disconnectDevice {
    if (self.ble.activePeripheral) {
        [self.ble.CM cancelPeripheralConnection:self.ble.activePeripheral];
        self.state = SWPeripheralStateDisConnecting;
    }
}

- (NSMutableArray *)peripherals {
    return _ble.peripherals;
}

- (CBPeripheral *)activePeripheral {
    return _ble.activePeripheral;
}

- (BOOL)isDeviceConnected {
    if (self.state != SWPeripheralStateConnected) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"请连接蓝牙设备", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    return YES;
}

#pragma mark - BLE Request

- (void)sendSetDateTimeRequest {
    UInt8 buf[] = {BLE_CMD_SET_DAY_TIME_REQUEST, 20, 14, 12, 23, 21, 29, 00};
    NSData *data = [[NSData alloc] initWithBytes:buf length:8];
    [self.ble write:data];
}

- (void)sendGetBatteryRequest {
    UInt8 buf[] = {BLE_CMD_SET_RESET_REQUEST};
    NSData *data = [[NSData alloc] initWithBytes:buf length:1];
    [self.ble write:data];
}

- (void)sendGetIndexRequest {
    UInt8 buf[] = {BLE_CMD_SET_INDEX_REQUEST};
    NSData *data = [[NSData alloc] initWithBytes:buf length:1];
    [self.ble write:data];
}

- (void)sendActivityCountRequest {
    UInt8 buf[] = {BLE_CMD_ACTIVITY_COUNT_REQUEST};
    NSData *data = [[NSData alloc] initWithBytes:buf length:1];
    [self.ble write:data];
}

- (void)sendGetActivityRequestWithIndex:(UInt8)index {
    UInt8 buf[] = {BLE_CMD_ACTIVITY_GETBYSN_REQUEST, index, activitystartHour};
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [self.ble write:data];
}

- (BOOL)setDaylightWithStartHour:(NSInteger)startHour endHour:(NSInteger)endHour {
    if (![self isDeviceConnected]) {
        return NO;
    }
    
    UInt8 buf[] = {BLE_CMD_SET_DAYMODE_REQUEST, startHour, endHour};
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [self.ble write:data];
    return YES;
}

- (BOOL)getDaylightInfo {
    if (![self isDeviceConnected]) {
        return NO;
    }
    
    UInt8 buf[] = {BLE_CMD_GET_DAYMODE_REQUEST};
    NSData *data = [[NSData alloc] initWithBytes:buf length:1];
    [self.ble write:data];
    return YES;
}

- (BOOL)setAlarmWithAlarmInfo:(SWAlarmInfo *)alarmInfo {
    if (![self isDeviceConnected]) {
        return NO;
    }
    
    UInt8 buf[] = {BLE_CMD_SET_ALARM_REQUEST, alarmInfo.hour, alarmInfo.minute, alarmInfo.state == 0 ? 255 : alarmInfo.repeat};
    NSData *data = [[NSData alloc] initWithBytes:buf length:4];
    [self.ble write:data];
    return YES;
}

- (BOOL)setStepTargets:(NSInteger)steps {
    if (![self isDeviceConnected]) {
        return NO;
    }
    
    UInt8 buf[] = {BLE_CMD_SET_STEPTARGET_REQUEST, 0x01};
    
    NSMutableData *data = [NSMutableData data];
    [data appendBytes:buf length:2];
    [data appendBytes:&steps length:2];
    
    [self.ble write:data];
    return YES;
}

- (BOOL)getStepsTarget {
    if (![self isDeviceConnected]) {
        return NO;
    }
    
    UInt8 buf[] = {BLE_CMD_SET_STEPTARGET_REQUEST, 0x00};
    NSData *data = [[NSData alloc] initWithBytes:buf length:2];
    [self.ble write:data];
    return YES;
}

- (BOOL)setUserInfoWithHeight:(NSInteger)height weight:(NSInteger)weight sex:(NSInteger)sex {
    if (![self isDeviceConnected]) {
        return NO;
    }
    
    UInt8 buf[] = {BLE_CMD_SET_BODY_REQUEST, height, weight, sex};
    
    NSMutableData *data = [NSMutableData data];
    [data appendBytes:buf length:4];
    
    [self.ble write:data];
    return YES;
}

- (BOOL)setphysiologicalInfoWithDateymd:(NSString *)dateymd physiologicalDay:(NSInteger)physiologicalDay {
    if (![self isDeviceConnected]) {
        return NO;
    }
    
    if (dateymd.length != 8) {
        return NO;
    }
    
    NSString *dateString = [dateymd stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
    NSInteger year = [dateString substringWithRange:NSMakeRange(0, 4)].integerValue;
    NSInteger month = [dateString substringWithRange:NSMakeRange(4, 2)].integerValue;
    NSInteger day = [dateString substringWithRange:NSMakeRange(6, 2)].integerValue;
    
    NSInteger yy1 = year / 100;
    NSInteger yy2 = year % 100;
    
    UInt8 buf[] = {BLE_CMD_SET_WOMEN_REQUEST, yy1, yy2, month, day, physiologicalDay};
    
    NSMutableData *data = [NSMutableData data];
    [data appendBytes:buf length:6];
    
    [self.ble write:data];
    return YES;
}

#pragma mark - BLE Response

- (void)handleResetReponse:(NSData *)data {
    if (data.length >= 2) {
        UInt8 battery = 0;
        [data getBytes:&battery range:NSMakeRange(1, 1)];
        
    }
}

- (void)handleIndexResponse:(NSData *)data {
    if (data.length >= 2) {
        UInt8 index = 0;
        [data getBytes:&index range:NSMakeRange(1, 1)];
        
    }
}

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

	activitystartHour += 6;
	if (activitystartHour <= 18) {
		[self sendGetActivityRequestWithIndex:activityCountResponse.currentIndex];
	} else {
        if (activityCountResponse.currentIndex == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kSWBLEDataReadCompletionNotification object:nil];
            
            return;
        }
        
		activitystartHour = 0;
		activityCountResponse.currentIndex--;
		if (activityCountResponse.currentIndex >= 0) {
			[self sendGetActivityRequestWithIndex:activityCountResponse.currentIndex];
		}
	}
}

- (void)handleSetAlarmResponse:(NSData *)data {
    if (data.length >= 20) {
        UInt8 ret = 0;
        [data getBytes:&ret range:NSMakeRange(1, 1)];
    }
}

- (void)handleStepsTargetResponse:(NSData *)data {
    if (data.length >= 20) {
        UInt8 ret = 0;
        [data getBytes:&ret range:NSMakeRange(1, 1)];
    }
}

- (void)handleGetDaylightInfoResponse:(NSData *)data {
    if (data.length >= 20) {
        UInt8 ret = 0;
        [data getBytes:&ret range:NSMakeRange(1, 1)];
    }
}

- (void)handleSetUserInfoResponse:(NSData *)data {
    if (data.length >= 20) {
        UInt8 ret = 0;
        [data getBytes:&ret range:NSMakeRange(1, 1)];
    }
}

- (void)handleSetPhysiologicalInfo:(NSData *)data {
    if (data.length >= 20) {
        UInt8 ret = 0;
        [data getBytes:&ret range:NSMakeRange(1, 1)];
    }
}

#pragma mark - BLE delegate

- (void)bleDidConnect {
    self.state = SWPeripheralStateConnected;
    
    
    [self sendGetBatteryRequest];
    [self sendGetIndexRequest];
    [self getDaylightInfo];
    [self getStepsTarget];
    [self sendActivityCountRequest];
//    [self sendSetDateTimeRequest];
}

- (void)bleDidWriteValue {
    
}

- (void)bleDidDisconnect {
    self.state = SWPeripheralStateDisconnected;
	
	activityCountResponse = nil;
}

- (void)bleDidReceiveData:(NSData *)data {
    if (data.length >= 20) {
        SWPacketHeader *response = [[SWPacketHeader alloc] initWithData:data];
        switch (response.cmdID) {
            case BLE_CMD_SET_RESET_RESPONSE:
                [self handleResetReponse:data];
                break;
            case BLE_CMD_SET_INDEX_RESPONSE:
                [self handleIndexResponse:data];
                break;
            case BLE_CMD_ACTIVITY_COUNT_RESPONSE:
                [self handleActivityCountResponse:data];
                break;
            case BLE_CMD_ACTIVITY_GETBYSN_RESPONSE:
                [self handleGetActivityRequest:data];
                break;
            case BLE_CMD_SET_DAY_TIME_RESPONSE:
                [self handleGetDaylightInfoResponse:data];
                break;
            case BLE_CMD_SET_ALARM_RESPONSE:
                [self handleSetAlarmResponse:data];
                break;
            case BLE_CMD_SET_STEPTARGET_RESPONSE:
                [self handleStepsTargetResponse:data];
                break;
            case BLE_CMD_SET_BODY_RESPONSE:
                [self handleSetUserInfoResponse:data];
                break;
            case BLE_CMD_SET_WOMEN_RESPONSE:
                [self handleSetPhysiologicalInfo:data];
                break;
            default:
                break;
        }
    }
}

@end
