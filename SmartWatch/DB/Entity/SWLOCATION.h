//
//  SWLOCATION.h
//  SmartWatch
//
//  Created by zhuzhi on 15/1/10.
//
//

#import <Foundation/Foundation.h>
#import "WBEntityBase.h"
#import "SWSingleton.h"

#define DBLOCATION [SWLOCATION shareInstant]

@interface SWLOCATION : WBEntityBase

SW_AS_SINGLETON(SWLOCATION, shareInstant);

@property (nonatomic,readonly)NSString *_dateymd;
@property (nonatomic,readonly)NSString *_longitude;
@property (nonatomic,readonly)NSString *_latitude;

@end
