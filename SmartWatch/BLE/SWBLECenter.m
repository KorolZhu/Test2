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

@interface SWBLECenter ()<BLEDelegate>

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

- (void)sendActivityCountRequest {
    UInt8 buf[] = {BLE_CMD_ACTIVITY_COUNT_REQUEST};
    NSData *data = [[NSData alloc] initWithBytes:buf length:1];
    [self.ble write:data];
}

- (void)sendGetActivityRequestWithIndex:(UInt8)index startHour:(UInt8)startHour {
    UInt8 buf[] = {BLE_CMD_ACTIVITY_GETBYSN_REQUEST, index, startHour};
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [self.ble write:data];
}

#pragma mark - BLE Response

- (void)handleActivityCountResponse:(NSData *)data {
    SWActivityCountResponse *response = [[SWActivityCountResponse alloc] initWithData:data];
    if (response.count > 0) {
        [self sendGetActivityRequestWithIndex:response.currentIndex - 10 startHour:6];
    }
}

- (void)handleGetActivityRequest:(NSData *)data {
    SWActivityResponse *response = [[SWActivityResponse alloc] initWithData:data];
}

#pragma mark - BLE delegate

- (void)bleDidConnect {
    _state = SWPeripheralStateConnected;
    
    [self sendActivityCountRequest];
}

- (void)bleDidWriteValue {
    
}

- (void)bleDidDisconnect {
    _state = SWPeripheralStateDisconnected;
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
            default:
                break;
        }
    }
}

@end
