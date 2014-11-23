//
//  SWHistoryRecordsViewController.m
//  SmartWatch
//
//  Created by zhuzhi on 14/11/16.
//  Copyright (c) 2014年 SW. All rights reserved.
//

#import "SWHistoryRecordsViewController.h"
#import "SWLineGraphView.h"
#import "SWPlot.h"

@implementation SWHistoryRecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"2背景-ios_01"] forBarMetrics:UIBarMetricsDefault];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"2背景-ios_02"]];
    
    SWLineGraphView *graphView = [[SWLineGraphView alloc] initWithFrame:CGRectMake(0.0f, 100.0f, 320.0f, 200.0f)];
    graphView.backgroundColor = [UIColor clearColor];
    graphView.xAxisValues = @[@{@1 : @"10-29"},@{@2 : @"10-30"},@{@3 : @"10-31"},@{@4 : @"11-01"},@{@5 : @"11-02"},@{@6 : @"11-03"},@{@7 : @"11-04"}];
    graphView.xIntervalCount = 7;
    graphView.xAxisDescription = @"时间";
    graphView.yAxisRange = 1.0f;
    graphView.yIntervalCount = 2;
    graphView.yAxisDescription = @"卡路里/步数走势";
    
    SWPlot *plot = [[SWPlot alloc] init];
    plot.plottingValues = @[
                            @{ @1 : @0.2f },
                            @{ @2 : @0.3f },
                            @{ @3 : @0.4f },
                            @{ @4 : @0.2f },
                            @{ @5 : @0.8f },
                            @{ @6 : @0.0f },
                            @{ @7 : @0.7f },
                            ];
    [graphView addPlot:plot];
    
    SWPlot *plot2 = [[SWPlot alloc] init];
    plot2.plottingValues = @[
                             @{ @1 : @1.0f },
                             @{ @2 : @0.5f },
                             @{ @3 : @0.6f },
                             @{ @4 : @0.4f },
                             @{ @5 : @0.7f },
                             @{ @6 : @0.2f },
                             @{ @7 : @0.3f },
                             ];
    plot2.plotThemeAttributes = @{
                                  kPlotFillColorKey : [UIColor clearColor],
                                  kPlotStrokeWidthKey : @1,
                                  kPlotStrokeColorKey : [UIColor blueColor],
                                  kPlotPointFillColorKey : [UIColor blueColor]};
    [graphView addPlot:plot2];
    
    [graphView setupTheView];
    [self.view addSubview:graphView];
}

@end
