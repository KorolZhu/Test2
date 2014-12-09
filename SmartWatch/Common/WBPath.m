//
//  WBPath.m
//  WristBand
//
//  Created by zhuzhi on 14/11/24.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import "WBPath.h"

@implementation WBPath

+ (NSString *)documentPath {
    static NSString *documentPath;
    if (!documentPath) {
        NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentPath = [[searchPaths objectAtIndex:0] copy];
    }
    return documentPath;
}

@end
