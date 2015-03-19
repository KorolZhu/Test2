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

NSString *const kSWBLESynchronizeStartNotification = @"kSWBLESynchronizeStartNotification";
NSString *const kSWBLESynchronizeSuccessNotification = @"kSWBLESynchronizeSuccessNotification";
NSString *const kSWBLESynchronizeFailNotification = @"kSWBLESynchronizeFailNotification";

#define TIMEOUT_5 5
#define TIMEOUT_10 10
#define TIMEOUT_15 15
#define TIMEOUT_20 20
#define TIMEOUT_25 25
#define TIMEOUT_30 30

@interface SWBLECenter ()<BLEDelegate>
{
	SWActivityCountResponse *activityCountResponse;
	int activitystartHour;
    
    NSTimer *timeoutTimer;   // 超时定时器
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

#pragma mark - Time out

- (void)validateTimerWithTimeout:(NSTimeInterval)timeout {
    if ([timeoutTimer isValid]) {
        [self invalidateTimer];
    }
    
    timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:@selector(timeout) userInfo:nil repeats:NO];
}

- (void)invalidateTimer {
    [timeoutTimer invalidate];
    timeoutTimer = nil;
}

- (void)timeout {
    if (self.state == SWPeripheralStateConnecting ||
        self.state == SWPeripheralStateConnected) {
        [self disconnectDevice];
    }
}

#pragma mark -

- (void)scanBLEPeripherals {
    [self.ble findBLEPeripherals];
}

- (void)stopScanBLEPeripherals {
    [self.ble.CM stopScan];
}

- (void)connectPeripheral:(CBPeripheral *)peripheral {
    self.state = SWPeripheralStateConnecting;
    [self.ble connectPeripheral:peripheral];
    [self validateTimerWithTimeout:TIMEOUT_15];
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

- (void)synchronize {
    if (self.state != SWPeripheralStateConnected) {
        return;
    }
    
    [self validateTimerWithTimeout:TIMEOUT_30];
    [self sendSetDateTimeRequest];
    [[NSNotificationCenter defaultCenter] postNotificationName:kSWBLESynchronizeStartNotification object:nil];
}

#pragma mark - BLE Request

- (void)sendSetDateTimeRequest {
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    NSInteger year = [dateComponent year];
    NSInteger month = [dateComponent month];
    NSInteger day = [dateComponent day];
    NSInteger hour = [dateComponent hour];
    NSInteger minute = [dateComponent minute];
    NSInteger second = [dateComponent second];
    
    UInt8 buf[] = {BLE_CMD_SET_DATE_TIME_REQUEST, year / 100, year % 100, month, day, hour, minute, second};
    NSData *data = [[NSData alloc] initWithBytes:buf length:8];
    [self.ble write:data];
}

- (void)sendGetBatteryRequest {
    UInt8 buf[] = {BLE_CMD_GET_BATTERY_REQUEST};
    NSData *data = [[NSData alloc] initWithBytes:buf length:1];
    [self.ble write:data];
}

- (void)sendGetIndexRequest {
    UInt8 buf[] = {BLE_CMD_GET_INDEX_REQUEST};
    NSData *data = [[NSData alloc] initWithBytes:buf length:1];
    [self.ble write:data];
}

- (void)sendGetPreventLostState {
    UInt8 buf[] = {BLE_CMD_PREVENT_LOST_READ_REQUEST, 0x00};
    NSData *data = [[NSData alloc] initWithBytes:buf length:2];
    [self.ble write:data];
}

- (void)sendGetDayModeRequest {
    UInt8 buf[] = {BLE_CMD_GET_DAYMODE_REQUEST};
    NSData *data = [[NSData alloc] initWithBytes:buf length:1];
    [self.ble write:data];
}

- (void)sendGetStepsTargetRequest {
    UInt8 buf[] = {BLE_CMD_SET_STEPTARGET_REQUEST, 0x00};
    NSData *data = [[NSData alloc] initWithBytes:buf length:2];
    [self.ble write:data];
}

- (void)sendGetActivityCountRequest {
    UInt8 buf[] = {BLE_CMD_ACTIVITY_COUNT_REQUEST};
    NSData *data = [[NSData alloc] initWithBytes:buf length:1];
    [self.ble write:data];
}

- (void)sendGetActivityRequestWithIndex:(UInt8)index {
    UInt8 buf[] = {BLE_CMD_ACTIVITY_GETBYSN_REQUEST, index, activitystartHour};
    NSLog(@"%@,%@", @(index).stringValue, @(activitystartHour).stringValue);
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

//- (BOOL)setLostMeters:(NSInteger)meters {
//	if (![self isDeviceConnected]) {
//		return NO;
//	}
//	
//	UInt8 buf[] = {BLE_CMD_SET_STEPTARGET_REQUEST, 0x01};
//	
//	NSMutableData *data = [NSMutableData data];
//	[data appendBytes:buf length:2];
//	
//	[self.ble write:data];
//	return YES;
//}

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
    
    if (dateymd.length != 10) {
        dateymd = @"2015/01/13";
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

- (BOOL)setPreventLostState:(NSInteger)state {
    if (![self isDeviceConnected]) {
        return NO;
    }
    
    UInt8 buf[] = {BLE_CMD_PREVENT_LOST_REQUEST, state};
    
    NSMutableData *data = [NSMutableData data];
    [data appendBytes:buf length:2];
    
    [self.ble write:data];
    return YES;
}

#pragma mark - BLE Response

- (void)handleSetDateTimeResponse:(NSData *)data {
    if (data.length >= 20) {
        UInt8 ret = 0;
        [data getBytes:&ret range:NSMakeRange(1, 1)];
    }
    
    [self sendGetBatteryRequest];
}

- (void)handleGetBatteryReponse:(NSData *)data {
    if (data.length >= 2) {
        UInt8 battery = 0;
        [data getBytes:&battery range:NSMakeRange(1, 1)];
        [SWSettingInfo shareInstance].battery = battery;
    }
    
//    [self sendGetIndexRequest];
    [self sendGetPreventLostState];
}

- (void)handleGetIndexResponse:(NSData *)data {
    if (data.length >= 2) {
        UInt8 index = 0;
        [data getBytes:&index range:NSMakeRange(1, 1)];
        [SWSettingInfo shareInstance].ultravioletIndex = index;
    }
    
    [self sendGetDayModeRequest];
}

- (void)handleGetPreventLostStateResponse:(NSData *)data {
    if (data.length >= 2) {
        UInt8 state = 0;
        [data getBytes:&state range:NSMakeRange(1, 1)];
        
        if ([SWSettingInfo shareInstance].preventLost != state) {
            [self setPreventLostState:[SWSettingInfo shareInstance].preventLost];
        } else {
            [SWSettingInfo shareInstance].preventLost = state;
            [self sendGetDayModeRequest];
        }
    } else {
        [self sendGetDayModeRequest];
    }
}

- (void)handleGetDayModeResponse:(NSData *)data {
    if (data.length >= 3) {
        UInt8 startHour = 0;
        UInt8 endHour = 0;
        [data getBytes:&startHour range:NSMakeRange(1, 1)];
        [data getBytes:&endHour range:NSMakeRange(2, 1)];
        [SWSettingInfo shareInstance].startHour = startHour;
        [SWSettingInfo shareInstance].endHour = endHour;
    }
    
    [self sendGetStepsTargetRequest];
}

- (void)handleGetStepsTargetResponse:(NSData *)data {
    if (data.length >= 5) {
        UInt8 step1 = 0;
        UInt8 step2 = 0;
        [data getBytes:&step1 range:NSMakeRange(3, 1)];
        [data getBytes:&step2 range:NSMakeRange(4, 1)];
        [SWSettingInfo shareInstance].stepsTarget = step2 * 256 + step1;
    }
    [[SWSettingInfo shareInstance] updateToDB];
    activitystartHour = 0;
    [self sendGetActivityCountRequest];
}

- (void)handleGetActivityCountResponse:(NSData *)data {
    activityCountResponse = [[SWActivityCountResponse alloc] initWithData:data];
    if (activityCountResponse.count > 0) {
        activityCountResponse.currentIndex = 0;
        [self sendGetActivityRequestWithIndex:activityCountResponse.currentIndex];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kSWBLESynchronizeSuccessNotification object:nil];
        [self invalidateTimer];
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
        if (activityCountResponse.currentIndex == activityCountResponse.count - 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kSWBLESynchronizeSuccessNotification object:nil];
            [self invalidateTimer];
            
            return;
        }
        
		activitystartHour = 0;
		activityCountResponse.currentIndex++;
		if (activityCountResponse.currentIndex <= activityCountResponse.count - 1) {
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

- (void)handleSetStepsTargetResponse:(NSData *)data {
    if (data.length >= 20) {
        UInt8 ret = 0;
        [data getBytes:&ret range:NSMakeRange(2, 1)];
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

- (void)handleSetPreventLostState:(NSData *)data {
    if (data.length >= 20) {
        UInt8 ret = 0;
        [data getBytes:&ret range:NSMakeRange(1, 1)];
        
        if ([timeoutTimer isValid]) {
            [SWSettingInfo shareInstance].preventLost = ret;
            [self sendGetDayModeRequest];
        }
    }
}

#pragma mark - BLE delegate

//- (void)bleDidUpdateRSSI:(NSNumber *)rssi {
//	NSLog(@"%@", rssi);
//}

- (void)bleDidConnect {
    [self validateTimerWithTimeout:TIMEOUT_30];
    NSString *uuid = self.ble.activePeripheral.identifier.UUIDString;
    if (uuid.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:LASTPERIPHERALUUID];
    }
    
    NSString *name = self.ble.activePeripheral.name;
    if (name.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:name forKey:LASTPERIPHERALNAME];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.state = SWPeripheralStateConnected;
    [self sendSetDateTimeRequest];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kSWBLESynchronizeStartNotification object:nil];
    
//    [self sendGetBatteryRequest];
//    [self sendGetIndexRequest];
//    [self getDaylightInfo];
//    [self getStepsTarget];
//    [self sendActivityCountRequest];
//	[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(readRSSI) userInfo:nil repeats:YES];
}

//- (void)readRSSI {
//	[self.ble readRSSI];
//}

- (void)bleDidWriteValue {
    
}

- (void)bleDidDisconnect {
    [self invalidateTimer];
    
    self.state = SWPeripheralStateDisconnected;
	activityCountResponse = nil;
}

- (void)bleDidReceiveData:(NSData *)data {
    if (data.length >= 20) {
        SWPacketHeader *response = [[SWPacketHeader alloc] initWithData:data];
        switch (response.cmdID) {
            case BLE_CMD_SET_DATE_TIME_RESPONSE:
                [self handleSetDateTimeResponse:data];
                break;
            case BLE_CMD_GET_BATTERY_RESPONSE:
                [self handleGetBatteryReponse:data];
                break;
            case BLE_CMD_GET_INDEX_RESPONSE:
                [self handleGetIndexResponse:data];
                break;
            case BLE_CMD_GET_DAYMODE_RESPONSE:
                [self handleGetDayModeResponse:data];
                break;
            case BLE_CMD_SET_STEPTARGET_RESPONSE: {
                if (data.length >= 2) {
                    UInt8 tag = 0;
                    [data getBytes:&tag range:NSMakeRange(1, 1)];
                    if (tag == 0) {
                        [self handleGetStepsTargetResponse:data];
                    } else if (tag == 1) {
                        [self handleSetStepsTargetResponse:data];
                    }
                }
                
            }
                break;
            case BLE_CMD_ACTIVITY_COUNT_RESPONSE:
                [self handleGetActivityCountResponse:data];
                break;
            case BLE_CMD_ACTIVITY_GETBYSN_RESPONSE:
                [self handleGetActivityRequest:data];
                break;
            case BLE_CMD_SET_ALARM_RESPONSE:
                [self handleSetAlarmResponse:data];
                break;
            case BLE_CMD_SET_BODY_RESPONSE:
                [self handleSetUserInfoResponse:data];
                break;
            case BLE_CMD_SET_WOMEN_RESPONSE:
                [self handleSetPhysiologicalInfo:data];
                break;
            case BLE_CMD_PREVENT_LOST_RESPONSE:
                [self handleSetPreventLostState:data];
                break;
            case BLE_CMD_PREVENT_LOST_READ_RESPONSE:
                [self handleGetPreventLostStateResponse:data];
                break;
            default:
                break;
        }
    }
}

@end
