//
//  SWPROFILE.h
//  SmartWatch
//
//  Created by zhuzhi on 14/12/13.
//
//

#import "WBEntityBase.h"
#import "SWSingleton.h"

#define DBPROFILE [SWPROFILE shareInstant]

@interface SWPROFILE : WBEntityBase

SW_AS_SINGLETON(SWPROFILE, shareInstant);

@property (nonatomic,readonly)NSString *_NAME;
@property (nonatomic,readonly)NSString *_PHOTOPATH;
@property (nonatomic,readonly)NSString *_SEX;
@property (nonatomic,readonly)NSString *_BIRTHDAY;
@property (nonatomic,readonly)NSString *_HEIGHT;
@property (nonatomic,readonly)NSString *_WEIGHT;


@end
