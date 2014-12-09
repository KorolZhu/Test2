//
//  SWBLECenter.h
//  SmartWatch
//
//  Created by zhuzhi on 14/12/8.
//
//

#import <Foundation/Foundation.h>
#import "SWSingleton.h"

typedef NS_ENUM(NSInteger, SWPeripheralState) {
    SWPeripheralStateDisconnected = 0,
    SWPeripheralStateConnecting,
    SWPeripheralStateConnected,
    SWPeripheralStateDisConnecting,
};

@interface SWBLECenter : NSObject

SW_AS_SINGLETON(SWBLECenter, shareInstance);

@property(readonly) SWPeripheralState state;

- (void)connectDevice;
- (void)disconnectDevice;

@end
