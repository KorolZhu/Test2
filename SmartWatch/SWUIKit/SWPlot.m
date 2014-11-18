//
//  ZZPlot.m
//  LineChart
//
//  Created by zhuzhi on 14/11/17.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//

#import "SWPlot.h"

NSString *const kPlotFillColorKey           = @"kPlotFillColorKey";
NSString *const kPlotStrokeWidthKey         = @"kPlotStrokeWidthKey";
NSString *const kPlotStrokeColorKey         = @"kPlotStrokeColorKey";
NSString *const kPlotPointFillColorKey      = @"kPlotPointFillColorKey";
NSString *const kPlotPointValueFontKey      = @"kPlotPointValueFontKey";

@implementation SWPlot

- (instancetype)init {
    if((self = [super init])) {
        [self loadDefaultTheme];
    }
    return self;
}

- (void)loadDefaultTheme {
    _plotThemeAttributes = @{
                             kPlotFillColorKey : [UIColor clearColor],
                             kPlotStrokeWidthKey : @1,
                             kPlotStrokeColorKey : [UIColor yellowColor],
                             kPlotPointFillColorKey : [UIColor yellowColor]};
}

@end
