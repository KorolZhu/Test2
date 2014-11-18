//
//  SWExerciseRecordsViewController.m
//  SmartWatch
//
//  Created by zhuzhi on 14/11/16.
//  Copyright (c) 2014年 SW. All rights reserved.
//

#import "SWExerciseRecordsViewController.h"
#import "SWShareKit.h"
#import "SWLineGraphView.h"
#import "SWPlot.h"

@implementation SWExerciseRecordsViewController

- (void)viewDidLoad {
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"分享", nil) style:UIBarButtonItemStylePlain target:self action:@selector(shareClick)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    SWLineGraphView *graphView = [[SWLineGraphView alloc] initWithFrame:CGRectMake(0.0f, 100.0f, 320.0f, 200.0f)];
    graphView.backgroundColor = [UIColor clearColor];
    graphView.xAxisValues = @[@{@6 : @"6"},@{@12 : @"12"},@{@18 : @"18"},@{@24 : @"24"}];
    graphView.xIntervalCount = 24;
    graphView.xAxisDescription = @"时间";
    graphView.yAxisRange = 100.0f;
    graphView.yIntervalCount = 2;
    graphView.yAxisDescription = @"卡路里（千卡）";
    
    SWPlot *plot = [[SWPlot alloc] init];
    plot.plottingValues = @[
                              @{ @6 : @20.0f },
                              @{ @7 : @70.0f },
                              @{ @8 : @50.0f },
                              @{ @9 : @40.0f },
                              @{ @10 : @15.0f },
                              @{ @11 : @10.0f },
                              @{ @12 : @13.0f },
                              @{ @13 : @20.0f },
                              @{ @14 : @14.0f },
                              @{ @15 : @10.0f },
                              @{ @16 : @6.0f },
                              @{ @18 : @25.0f },
                              @{ @19 : @40.0f },
                              @{ @20 : @30.0f },
                              @{ @21 : @20.0f }];
    
    plot.plotThemeAttributes = @{
                                  kPlotFillColorKey : [UIColor clearColor],
                                  kPlotStrokeWidthKey : @1,
                                  kPlotStrokeColorKey : [UIColor blueColor],
                                  kPlotPointFillColorKey : [UIColor blueColor]};
    [graphView addPlot:plot];
    
    [graphView setupTheView];
    [self.view addSubview:graphView];
}

- (void)shareClick {
    [[SWShareKit sharedInstance] sendMessage:@"test" WithUrl:@"http://baidu.com" WithType:SWShareTypeWechatSession];
}

@end
