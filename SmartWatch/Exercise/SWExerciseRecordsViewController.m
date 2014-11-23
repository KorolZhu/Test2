//
//  SWExerciseRecordsViewController.m
//  SmartWatch
//
//  Created by zhuzhi on 14/11/16.
//  Copyright (c) 2014年 SW. All rights reserved.
//

#import "SWExerciseRecordsViewController.h"
#import "SWExerciseRecordsTitleView.h"
#import "SWEnvironmentView.h"
#import "SWCircleProgressView.h"
#import "SWShareKit.h"
#import "SWLineGraphView.h"
#import "SWPlot.h"

@interface SWExerciseRecordsViewController ()
{
    SWExerciseRecordsTitleView *titleView;
    SWEnvironmentView *environmentView;
    SWCircleProgressView *progressView;
}

@end
@implementation SWExerciseRecordsViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
    }
    
    return self;
}

- (void)viewDidLoad {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1背景-ios_01"] forBarMetrics:UIBarMetricsDefault];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"1背景-ios_02"]];
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"蓝牙"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(bleClick)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"分享"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(shareClick)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    titleView = [[SWExerciseRecordsTitleView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 220.0f, 44.0f)];
    titleView.date = [NSDate date];
    self.navigationItem.titleView = titleView;
    
    
    environmentView = [[SWEnvironmentView alloc] initWithFrame:CGRectMake(14.0f, 12.0f, IPHONE_WIDTH - 28.0f, 25.0f)];
    environmentView.uvLevel = 5;
    environmentView.temperature = 25;
    environmentView.humidity = 66;
    environmentView.leftPower = 77;
    [self.view addSubview:environmentView];
    
    progressView = [[SWCircleProgressView alloc] initWithFrame:CGRectMake(14.0f, environmentView.bottom + 15.0f, 0.0f, 0.0f)];
    progressView.backImage = [UIImage imageNamed:@"1运动记录_70"];
    progressView.topDesc = NSLocalizedString(@"今日", nil);
    progressView.bottomDesc = NSLocalizedString(@"目标", nil);
    progressView.progress = 0.83;
    progressView.valueString = @"83%";
    [self.view addSubview:progressView];
    
    SWLineGraphView *graphView = [[SWLineGraphView alloc] initWithFrame:CGRectMake(0.0f, progressView.bottom + 10.0f, 320.0f, 200.0f)];
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)bleClick {
    
}

- (void)shareClick {
    [[SWShareKit sharedInstance] sendMessage:@"test" WithUrl:@"http://baidu.com" WithType:SWShareTypeWechatSession];
}

@end
