//
//  HTEntity.h
//  WristBand
//
//  Created by zhuzhi on 13-6-21.
//  Copyright (c) 2013年 WB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWSingleton.h"

@interface WBEntityBase : NSObject

@property(nonatomic,assign)NSInteger ID;

@property(nonatomic,readonly)NSString *_ID;
@property(nonatomic,readonly)NSString *_tableName;

@end
