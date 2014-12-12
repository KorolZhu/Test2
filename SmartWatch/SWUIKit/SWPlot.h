//
//  ZZPlot.h
//  LineChart
//
//  Created by zhuzhi on 14/11/17.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWPlot : NSObject

/**
 *  NSDictionary, where the key is the same as the one which you specified in the `xAxisValues` in `SHLineGraphView`,
 *  the value is the number which will determine the point location along the y-axis line. make sure the values are not
 *  greater than the `yAxisRange` specified in `SHLineGraphView`.
 */
@property (nonatomic, strong) NSDictionary *plottingValues;

/**
 *  the dictionary which you can use to assing the theme attributes of the plot. if this property is nil, a default theme
 *  is applied selected and the graph is plotted with those default settings.
 */
@property (nonatomic, strong) NSDictionary *plotThemeAttributes;


//following are the theme keys that you will be using to create the theme of the your grpah plot

/**
 *  plot fill color key. use this to define the fill color of the plot (UIColor*)
 */
UIKIT_EXTERN NSString *const kPlotFillColorKey;

/**
 *  plot stroke width key. use this to define the width of the plotting stroke line (in pixels)
 */
UIKIT_EXTERN NSString *const kPlotStrokeWidthKey;

/**
 *  plot stroke color key. use this to define the stroke color of the plotting line (UIColor*)
 */
UIKIT_EXTERN NSString *const kPlotStrokeColorKey;

/**
 *  plot point fill color key. use this to define the fill color of the point in plot (UIColor*)
 */
UIKIT_EXTERN NSString *const kPlotPointFillColorKey;

@end
