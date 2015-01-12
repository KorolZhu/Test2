//
//  SWBLECenter.h
//  SmartWatch
//
//  Created by zhuzhi on 14/12/8.
//
//

#import <Foundation/Foundation.h>
#import "SWSingleton.h"

extern NSString *const kSWBLEDataReadCompletionNotification;

@class SWAlarmInfo;

typedef NS_ENUM(NSInteger, SWPeripheralState) {
    SWPeripheralStateDisconnected = 0,
    SWPeripheralStateConnecting,
    SWPeripheralStateConnected,
    SWPeripheralStateDisConnecting,
};

@interface SWBLECenter : NSObject

SW_AS_SINGLETON(SWBLECenter, shareInstance);

@property (nonatomic,readonly) BLE *ble;
@property(nonatomic) SWPeripheralState state;
@property (strong, readonly) CBPeripheral *activePeripheral;

- (void)scanBLEPeripherals;
- (void)stopScanBLEPeripherals;

- (void)connectPeripheral:(CBPeripheral *)eripheral;
- (void)connectDevice;
- (void)disconnectDevice;

- (BOOL)setDaylightWithStartHour:(NSInteger)startHour endHour:(NSInteger)endHour;
- (BOOL)setAlarmWithAlarmInfo:(SWAlarmInfo *)alarmInfo;
- (BOOL)setStepTargets:(NSInteger)steps;
- (BOOL)setLostMeters:(NSInteger)meters;
- (BOOL)setUserInfoWithHeight:(NSInteger)height
                       weight:(NSInteger)weight
                          sex:(NSInteger)sex;

- (BOOL)setphysiologicalInfoWithDateymd:(NSString *)dateymd
                    physiologicalDay:(NSInteger)physiologicalDay;

@end
