//
//  SWBLECenter.m
//  SmartWatch
//
//  Created by zhuzhi on 14/12/8.
//
//

#import "SWBLECenter.h"
#import "BLE.h"

@interface SWBLECenter ()<BLEDelegate>

@property (nonatomic,strong) BLE *ble;

@end

@implementation SWBLECenter

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
    
    _state = CBPeripheralStateConnecting;
    [self.ble findBLEPeripherals:3];
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scanPeripheraTimer) userInfo:nil repeats:NO];
}

- (void)scanPeripheraTimer {
    if (self.ble.peripherals.count > 0) {
        [self.ble connectPeripheral:[self.ble.peripherals objectAtIndex:0]];
    } else {
        _state = CBPeripheralStateDisconnected;
    }
}

- (void)disconnectDevice {
    if (self.ble.activePeripheral) {
        [self.ble.CM cancelPeripheralConnection:self.ble.activePeripheral];
    }
}

#pragma mark - BLE delegate

- (void)bleDidConnect {
    _state = CBPeripheralStateConnected;
}

-(void)write {
    //    int sn = 12;
    //    int hh = 0;
    //    NSMutableData* headerData = [NSMutableData data];
    //    [headerData appendBytes:&_flag length:1];
    
    UInt8 buf[] = {0x13,0,0};
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [self.ble write:data];
}

- (void)bleDidWriteValue {
    
}

- (void)bleDidDisconnect {
    
}

- (void)bleDidReceiveData:(unsigned char *)data length:(int)length {
    if (length >= 3) {
        UInt8 data0 = data[0];
        UInt8 data1 = data[1];
        UInt8 data2 = data[2];
        UInt8 data3 = data[3];
        UInt8 data4 = data[4];
        UInt8 data5 = data[5];
        UInt8 data6 = data[6];
        
        NSLog(@"%d,%d,%d,%d,%d,%d,%d", (int)data0, (int)data1, (int)data2, (int)data3, (int)data4, (int)data5, (int)data6);
        
    }
}

@end
