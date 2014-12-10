//
//  SWDAILYSTEPS.h
//  SmartWatch
//
//  Created by zhuzhi on 14/12/10.
//
//

#import "WBEntityBase.h"
#import "SWSingleton.h"

#define DBDAILYSTEPS [SWDAILYSTEPS shareInstant]

@interface SWDAILYSTEPS : WBEntityBase

SW_AS_SINGLETON(SWDAILYSTEPS, shareInstant);

@property (nonatomic,readonly)NSString *_DATEYMD;
@property (nonatomic,readonly)NSString *_STEPCOUNT0;
@property (nonatomic,readonly)NSString *_STEPCOUNT1;
@property (nonatomic,readonly)NSString *_STEPCOUNT2;
@property (nonatomic,readonly)NSString *_STEPCOUNT3;
@property (nonatomic,readonly)NSString *_STEPCOUNT4;
@property (nonatomic,readonly)NSString *_STEPCOUNT5;
@property (nonatomic,readonly)NSString *_STEPCOUNT6;
@property (nonatomic,readonly)NSString *_STEPCOUNT7;
@property (nonatomic,readonly)NSString *_STEPCOUNT8;
@property (nonatomic,readonly)NSString *_STEPCOUNT9;
@property (nonatomic,readonly)NSString *_STEPCOUNT10;
@property (nonatomic,readonly)NSString *_STEPCOUNT11;
@property (nonatomic,readonly)NSString *_STEPCOUNT12;
@property (nonatomic,readonly)NSString *_STEPCOUNT13;
@property (nonatomic,readonly)NSString *_STEPCOUNT14;
@property (nonatomic,readonly)NSString *_STEPCOUNT15;
@property (nonatomic,readonly)NSString *_STEPCOUNT16;
@property (nonatomic,readonly)NSString *_STEPCOUNT17;
@property (nonatomic,readonly)NSString *_STEPCOUNT18;
@property (nonatomic,readonly)NSString *_STEPCOUNT19;
@property (nonatomic,readonly)NSString *_STEPCOUNT20;
@property (nonatomic,readonly)NSString *_STEPCOUNT21;
@property (nonatomic,readonly)NSString *_STEPCOUNT22;
@property (nonatomic,readonly)NSString *_STEPCOUNT23;

@property (nonatomic,readonly)NSString *_STEPCOUNT;

@end
