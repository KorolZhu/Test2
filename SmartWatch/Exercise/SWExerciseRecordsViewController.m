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
#import "SWDashboardView.h"
#import "SWShareKit.h"
#import "SWLineGraphView.h"
#import "SWPlot.h"
#import "SWBLECenter.h"
#import "SWExerciseRecordsModel.h"

@interface SWExerciseRecordsViewController ()<BLEDelegate>
{
    SWExerciseRecordsTitleView *titleView;
    SWEnvironmentView *environmentView;
    SWCircleProgressView *progressView;
    SWDashboardView *dashboardView;
    UIButton *curveButton, *trackButton;
    UIButton *calorieButton, *stepButton, *sleepButton;
	
	SWExerciseRecordsModel *model;
}

@property (nonatomic,strong) UIScrollView *scrollView;

@end

@implementation SWExerciseRecordsViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
		
		model = [[SWExerciseRecordsModel alloc] initWithResponder:self];
    }
    
    return self;
}

- (void)dealloc {
    [[SWBLECenter shareInstance] removeObserver:self forKeyPath:@"state" context:NULL];
}

- (void)viewDidLoad {
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_scrollView];
    
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
    [_scrollView addSubview:environmentView];
    
    progressView = [[SWCircleProgressView alloc] initWithFrame:CGRectMake(14.0f, environmentView.bottom + 15.0f, 0.0f, 0.0f)];
    progressView.backImage = [UIImage imageNamed:@"1运动记录_70"];
    progressView.topDesc = NSLocalizedString(@"今日", nil);
    progressView.bottomDesc = NSLocalizedString(@"目标", nil);
    progressView.progress = 0.83;
    progressView.valueString = @"83%";
    [_scrollView addSubview:progressView];
    
    dashboardView = [[SWDashboardView alloc] initWithFrame:CGRectMake(progressView.right + 16.0f, progressView.top + 10.0f, 112.0f, 171.0f)];
    [_scrollView addSubview:dashboardView];
    dashboardView.value1 = 3089;
    dashboardView.unit1 = @"千卡";
    dashboardView.descri1 = @"燃烧";
    dashboardView.value2 = 554;
    dashboardView.unit2 = @"公里";
    dashboardView.descri2 = @"距离";
    dashboardView.value3 = 2565;
    dashboardView.unit3 = @"步";
    dashboardView.descri3 = @"步数";
    
    SWLineGraphView *graphView = [[SWLineGraphView alloc] initWithFrame:CGRectMake(0.0f, progressView.bottom + 10.0f, IPHONE_WIDTH, 166.0f)];
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
                                  kPlotStrokeColorKey : RGBFromHex(0x00F0FF),
                                  kPlotPointFillColorKey : RGBFromHex(0x00F0FF)};
    [graphView addPlot:plot];
    
    [graphView setupTheView];
    [_scrollView addSubview:graphView];
    
    curveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [curveButton addTarget:self action:@selector(curveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [curveButton setBackgroundImage:[UIImage imageNamed:@"button1"] forState:UIControlStateNormal];
    [curveButton setBackgroundImage:[UIImage imageNamed:@"button2"] forState:UIControlStateSelected];
    [curveButton setTitle:@"曲线图" forState:UIControlStateNormal];
    [curveButton.titleLabel setFont:[UIFont systemFontOfSize:9.0f]];
    [curveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [curveButton setTitleColor:RGBFromHex(0x505050) forState:UIControlStateNormal];
    [_scrollView addSubview:curveButton];
    curveButton.frame = CGRectMake(IPHONE_WIDTH - 121.0f, graphView.bottom + 5.0f, 48.0f, 19.0f);
    curveButton.selected = YES;
    
    trackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [trackButton addTarget:self action:@selector(trackButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [trackButton setBackgroundImage:[UIImage imageNamed:@"button1"] forState:UIControlStateNormal];
    [trackButton setBackgroundImage:[UIImage imageNamed:@"button2"] forState:UIControlStateSelected];
    [trackButton setTitle:@"轨迹图" forState:UIControlStateNormal];
    [trackButton.titleLabel setFont:[UIFont systemFontOfSize:9.0f]];
    [trackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [trackButton setTitleColor:RGBFromHex(0x505050) forState:UIControlStateNormal];
    [_scrollView addSubview:trackButton];
    trackButton.frame = CGRectMake(curveButton.right + 5.0f, graphView.bottom + 5.0f, 48.0f, 19.0f);
    
    calorieButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [calorieButton addTarget:self action:@selector(calorieButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [calorieButton setBackgroundImage:[UIImage imageNamed:@"left_1"] forState:UIControlStateNormal];
    [calorieButton setBackgroundImage:[UIImage imageNamed:@"left_2"] forState:UIControlStateSelected];
    [calorieButton setImage:[UIImage imageNamed:@"ico_卡路里1"] forState:UIControlStateNormal];
    [calorieButton setImage:[UIImage imageNamed:@"ico_卡路里2"] forState:UIControlStateSelected];
    [calorieButton setTitle:@"卡路里" forState:UIControlStateNormal];
    calorieButton.titleEdgeInsets = UIEdgeInsetsMake(2.0f, 8.0f, 0.0f, 0.0f);
    [calorieButton.titleLabel setFont:[UIFont systemFontOfSize:11.0f]];
    [calorieButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [calorieButton setTitleColor:RGBFromHex(0x505050) forState:UIControlStateNormal];
    [_scrollView addSubview:calorieButton];
    calorieButton.frame = CGRectMake((IPHONE_WIDTH - 3 * 96.0f) / 2.0f, trackButton.bottom + 13.0f, 96.0f, 39.0f);
    calorieButton.selected = YES;
    
    stepButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [stepButton addTarget:self action:@selector(stepButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [stepButton setBackgroundImage:[UIImage imageNamed:@"m_1"] forState:UIControlStateNormal];
    [stepButton setBackgroundImage:[UIImage imageNamed:@"m_2"] forState:UIControlStateSelected];
    [stepButton setImage:[UIImage imageNamed:@"ico_步数1"] forState:UIControlStateNormal];
    [stepButton setImage:[UIImage imageNamed:@"ico_步数2"] forState:UIControlStateSelected];
    [stepButton setTitle:@"步数" forState:UIControlStateNormal];
    stepButton.titleEdgeInsets = UIEdgeInsetsMake(2.0f, 8.0f, 0.0f, 0.0f);
    [stepButton.titleLabel setFont:[UIFont systemFontOfSize:11.0f]];
    [stepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [stepButton setTitleColor:RGBFromHex(0x505050) forState:UIControlStateNormal];
    [_scrollView addSubview:stepButton];
    stepButton.frame = CGRectMake(calorieButton.right, trackButton.bottom + 13.0f, 96.0f, 39.0f);
    
    sleepButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sleepButton addTarget:self action:@selector(sleepButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [sleepButton setBackgroundImage:[UIImage imageNamed:@"right_1"] forState:UIControlStateNormal];
    [sleepButton setBackgroundImage:[UIImage imageNamed:@"right_2"] forState:UIControlStateSelected];
    [sleepButton setImage:[UIImage imageNamed:@"ico_睡眠1"] forState:UIControlStateNormal];
    [sleepButton setImage:[UIImage imageNamed:@"ico_睡眠2"] forState:UIControlStateSelected];
    [sleepButton setTitle:@"睡眠" forState:UIControlStateNormal];
    sleepButton.titleEdgeInsets = UIEdgeInsetsMake(2.0f, 8.0f, 0.0f, 0.0f);
    [sleepButton.titleLabel setFont:[UIFont systemFontOfSize:11.0f]];
    [sleepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [sleepButton setTitleColor:RGBFromHex(0x505050) forState:UIControlStateNormal];
    [_scrollView addSubview:sleepButton];
    sleepButton.frame = CGRectMake(stepButton.right, trackButton.bottom + 13.0f, 96.0f, 39.0f);
    
    _scrollView.contentSize = CGSizeMake(IPHONE_WIDTH, sleepButton.bottom + 13.0f);
    
    [[SWBLECenter shareInstance] addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:NULL];
	
	[model queryExerciseRecords];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)bleClick {
    [[SWBLECenter shareInstance] connectDevice];
}

- (void)shareClick {
    [[SWShareKit sharedInstance] sendMessage:@"test" WithUrl:@"http://baidu.com" WithType:SWShareTypeWechatSession];
}

- (void)curveButtonClick {
    if (curveButton.selected) {
        return;
    }
    curveButton.selected = YES;
    trackButton.selected = NO;
}

- (void)trackButtonClick {
    if (trackButton.selected) {
        return;
    }
    curveButton.selected = NO;
    trackButton.selected = YES;

}

- (void)calorieButtonClick {
    if (calorieButton.selected) {
        return;
    }
    calorieButton.selected = YES;
    stepButton.selected = NO;
    sleepButton.selected = NO;
}

- (void)stepButtonClick {
    if (stepButton.selected) {
        return;
    }
    calorieButton.selected = NO;
    stepButton.selected = YES;
    sleepButton.selected = NO;
}

- (void)sleepButtonClick {
    if (sleepButton.selected) {
        return;
    }
    calorieButton.selected = NO;
    stepButton.selected = NO;
    sleepButton.selected = YES;
}

#pragma mark - Model

- (void)exerciseRecordsQueryFinished {
//	[self reloadData];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"state"]) {
        NSInteger state = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        switch (state) {
            case SWPeripheralStateDisconnected: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.navigationItem.leftBarButtonItem.enabled = YES;
                });
            }
                break;
                
            default: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.navigationItem.leftBarButtonItem.enabled = NO;
                });
            }
                break;
        }
    }
}

@end
