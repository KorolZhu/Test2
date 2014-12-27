//
//  SWHistoryRecordsViewController.m
//  SmartWatch
//
//  Created by zhuzhi on 14/11/16.
//  Copyright (c) 2014年 SW. All rights reserved.
//

#import "SWHistoryRecordsViewController.h"
#import "SWCircleProgressView.h"
#import "SWLineGraphView.h"
#import "SWPlot.h"
#import "SWHistoryRecordsModel.h"
#import "MBProgressHUD.h"

@interface SWHistoryRecordsViewController ()
{
    SWCircleProgressView *progressView1;
    SWCircleProgressView *progressView2;
    SWCircleProgressView *progressView3;
    
    SWLineGraphView *dayGraphView;
    SWLineGraphView *weekGraphView;
    SWLineGraphView *monthGraphView;
    SWLineGraphView *yearGraphView;
    
    UIImageView *dayGraphHeadView;
    UIImageView *weekGraphHeadView;
    UIImageView *monthGraphHeadView;
    UIImageView *yearGraphHeadView;
    
    SWPlot *dayCaloriePlot;
    SWPlot *dayStepsPlot;
    
    SWPlot *weekCaloriePlot;
    SWPlot *weekStepsPlot;
    
    SWPlot *monthCaloriePlot;
    SWPlot *monthStepsPlot;
    
    SWPlot *yearCaloriePlot;
    SWPlot *yearStepsPlot;

    UIButton *dayButton, *weekButton, *monthButton, *yearButton;
    
    SWHistoryRecordsModel *model;
}

@property (nonatomic, strong) MBProgressHUD *HUD;

@property (nonatomic,strong) UIScrollView *scrollView;

@end

@implementation SWHistoryRecordsViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        
        model = [[SWHistoryRecordsModel alloc] initWithResponder:self];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_scrollView];
    
    self.navigationItem.title = @"日报";
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"2背景-ios_01"] forBarMetrics:UIBarMetricsDefault];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"2背景-ios_02"]];
    
    progressView1 = [[SWCircleProgressView alloc] initWithFrame:CGRectMake(14.0f, 27.0f, 0.0f, 0.0f)];
    progressView1.backImage = [UIImage imageNamed:@"1运动记录_70"];
    progressView1.topDesc = NSLocalizedString(@"每日平均", nil);
    progressView1.bottomDesc = NSLocalizedString(@"千卡燃烧", nil);
    [_scrollView addSubview:progressView1];
    
    progressView2 = [[SWCircleProgressView alloc] initWithFrame:CGRectMake(progressView1.right + 10.0f, 35.0f, 0.0f, 0.0f)];
    progressView2.style = SWCircleProgressViewStyleSmall;
    progressView2.backImage = [UIImage imageNamed:@"历史记录_03"];
    progressView2.topDesc = NSLocalizedString(@"每日平均", nil);
    progressView2.bottomDesc = NSLocalizedString(@"歩", nil);
    [_scrollView addSubview:progressView2];
    
    progressView3 = [[SWCircleProgressView alloc] initWithFrame:CGRectMake(progressView1.right - 10.0f, progressView2.bottom + 6.0f, 0.0f, 0.0f)];
    progressView3.style = SWCircleProgressViewStyleSmall;
    progressView3.backImage = [UIImage imageNamed:@"历史记录_03"];
    progressView3.topDesc = NSLocalizedString(@"每日平均", nil);
    progressView3.bottomDesc = NSLocalizedString(@"睡眠", nil);
    progressView3.progress = 0.83;
    progressView3.valueString = @"83%";
    [_scrollView addSubview:progressView3];
    
    
    
    dayGraphView = [[SWLineGraphView alloc] initWithFrame:CGRectMake(0.0f, progressView3.bottom + 10.0f, IPHONE_WIDTH, 166.0f)];
    dayGraphView.backgroundColor = [UIColor clearColor];
    dayGraphView.xAxisValues = @[@{@6 : @"6"},@{@12 : @"12"},@{@18 : @"18"},@{@24 : @"24"}];
    dayGraphView.xIntervalCount = 24;
    dayGraphView.xAxisDescription = @"时间";
    dayGraphView.yAxisRange = 2000;
    dayGraphView.yIntervalCount = 2;
    dayGraphView.yAxisDescription = @"卡路里/步数 走势";
    
    dayCaloriePlot = [[SWPlot alloc] init];
    dayCaloriePlot.plotThemeAttributes = @{
                                        kPlotFillColorKey : [UIColor clearColor],
                                        kPlotStrokeWidthKey : @1,
                                        kPlotStrokeColorKey : RGBFromHex(0x00F0FF),
                                        kPlotPointFillColorKey : RGBFromHex(0x00F0FF)};
    [dayGraphView addPlot:dayCaloriePlot];
    
    dayStepsPlot = [[SWPlot alloc] init];
    dayStepsPlot.plotThemeAttributes = @{
                                           kPlotFillColorKey : [UIColor clearColor],
                                           kPlotStrokeWidthKey : @1,
                                           kPlotStrokeColorKey : RGBFromHex(0xFFDE00),
                                           kPlotPointFillColorKey : RGBFromHex(0xFFDE00)};
    [dayGraphView addPlot:dayStepsPlot];
    dayGraphHeadView = [self graphHeadView];
    [dayGraphView setHeadView:dayGraphHeadView];
    [dayGraphView setupTheView];
    [_scrollView addSubview:dayGraphView];
    
    NSMutableArray *xAxisValues = [NSMutableArray array];
    NSDate *date = [NSDate date];
    for (NSInteger i = 0; i < 7; i++) {
        NSDate *tempDate = [date dateByAddingTimeInterval:-i * 24 * 3600];
        NSString *dateString = [tempDate stringWithFormat:@"MM-dd"];
        [xAxisValues insertObject:@{@(7-i): dateString} atIndex:0];
    }
    
    weekGraphView = [[SWLineGraphView alloc] initWithFrame:dayGraphView.frame];
    weekGraphView.backgroundColor = [UIColor clearColor];
    weekGraphView.xAxisValues = xAxisValues;
    weekGraphView.xIntervalCount = 7;
    weekGraphView.xAxisDescription = @"时间";
    weekGraphView.yAxisRange = 6000;
    weekGraphView.yIntervalCount = 2;
    weekGraphView.yAxisDescription = @"卡路里/步数 走势";
    
    weekCaloriePlot = [[SWPlot alloc] init];
    weekCaloriePlot.plotThemeAttributes = @{
                                           kPlotFillColorKey : [UIColor clearColor],
                                           kPlotStrokeWidthKey : @1,
                                           kPlotStrokeColorKey : RGBFromHex(0x00F0FF),
                                           kPlotPointFillColorKey : RGBFromHex(0x00F0FF)};
    [weekGraphView addPlot:weekCaloriePlot];
    
    weekStepsPlot = [[SWPlot alloc] init];
    weekStepsPlot.plotThemeAttributes = @{
                                         kPlotFillColorKey : [UIColor clearColor],
                                         kPlotStrokeWidthKey : @1,
                                         kPlotStrokeColorKey : RGBFromHex(0xFFDE00),
                                         kPlotPointFillColorKey : RGBFromHex(0xFFDE00)};
    [weekGraphView addPlot:weekStepsPlot];
    weekGraphHeadView = [self graphHeadView];
    [weekGraphView setHeadView:weekGraphHeadView];
    [weekGraphView setupTheView];
    [_scrollView addSubview:weekGraphView];
    weekGraphView.hidden = YES;
    
    NSMutableArray *monthXAxisValues = [NSMutableArray array];
    for (NSInteger i = 0; i < 30; i+=6) {
        NSDate *tempDate = [date dateByAddingTimeInterval:-i * 24 * 3600];
        NSString *dateString = [tempDate stringWithFormat:@"MM-dd"];
        [monthXAxisValues insertObject:@{@(30-i): dateString} atIndex:0];
    }
    
    monthGraphView = [[SWLineGraphView alloc] initWithFrame:dayGraphView.frame];
    monthGraphView.backgroundColor = [UIColor clearColor];
    monthGraphView.xAxisValues = monthXAxisValues;
    monthGraphView.xIntervalCount = 30;
    monthGraphView.xAxisDescription = @"时间";
    monthGraphView.yAxisRange = 6000;
    monthGraphView.yIntervalCount = 2;
    monthGraphView.yAxisDescription = @"卡路里/步数 走势";
    
    monthCaloriePlot = [[SWPlot alloc] init];
    monthCaloriePlot.plotThemeAttributes = @{
                                            kPlotFillColorKey : [UIColor clearColor],
                                            kPlotStrokeWidthKey : @1,
                                            kPlotStrokeColorKey : RGBFromHex(0x00F0FF),
                                            kPlotPointFillColorKey : RGBFromHex(0x00F0FF)};
    [monthGraphView addPlot:monthCaloriePlot];
    
    monthStepsPlot = [[SWPlot alloc] init];
    monthStepsPlot.plotThemeAttributes = @{
                                          kPlotFillColorKey : [UIColor clearColor],
                                          kPlotStrokeWidthKey : @1,
                                          kPlotStrokeColorKey : RGBFromHex(0xFFDE00),
                                          kPlotPointFillColorKey : RGBFromHex(0xFFDE00)};
    [monthGraphView addPlot:monthStepsPlot];
    monthGraphHeadView = [self graphHeadView];
    [monthGraphView setHeadView:monthGraphHeadView];
    [monthGraphView setupTheView];
    [_scrollView addSubview:monthGraphView];
    monthGraphView.hidden = YES;
    
    NSString *dateString = [date stringWithFormat:@"MM"];
    NSInteger currentMonth = [dateString integerValue];
    NSMutableArray *yearXAxisValues = [NSMutableArray array];
    for (NSInteger i = 12; i >= 1; i--) {
        [yearXAxisValues insertObject:@{@(i): @(currentMonth).stringValue} atIndex:0];
        currentMonth--;
        if (currentMonth <= 0) {
            currentMonth = 12;
        }
    }
    
    yearGraphView = [[SWLineGraphView alloc] initWithFrame:dayGraphView.frame];
    yearGraphView.backgroundColor = [UIColor clearColor];
    yearGraphView.xAxisValues = yearXAxisValues;
    yearGraphView.xIntervalCount = 12;
    yearGraphView.xAxisDescription = @"月份";
    yearGraphView.yAxisRange = 15000;
    yearGraphView.yIntervalCount = 2;
    yearGraphView.yAxisDescription = @"卡路里/步数 走势";
    
    yearCaloriePlot = [[SWPlot alloc] init];
    yearCaloriePlot.plotThemeAttributes = @{
                                             kPlotFillColorKey : [UIColor clearColor],
                                             kPlotStrokeWidthKey : @1,
                                             kPlotStrokeColorKey : RGBFromHex(0x00F0FF),
                                             kPlotPointFillColorKey : RGBFromHex(0x00F0FF)};
    [yearGraphView addPlot:yearCaloriePlot];
    
    yearStepsPlot = [[SWPlot alloc] init];
    yearStepsPlot.plotThemeAttributes = @{
                                           kPlotFillColorKey : [UIColor clearColor],
                                           kPlotStrokeWidthKey : @1,
                                           kPlotStrokeColorKey : RGBFromHex(0xFFDE00),
                                           kPlotPointFillColorKey : RGBFromHex(0xFFDE00)};
    [yearGraphView addPlot:yearStepsPlot];
    yearGraphHeadView = [self graphHeadView];
    [yearGraphView setHeadView:yearGraphHeadView];
    [yearGraphView setupTheView];
    [_scrollView addSubview:yearGraphView];
    yearGraphView.hidden = YES;
    
    dayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dayButton addTarget:self action:@selector(dayButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [dayButton setBackgroundImage:[UIImage imageNamed:@"历史记录_18"] forState:UIControlStateNormal];
    [dayButton setBackgroundImage:[UIImage imageNamed:@"历史记录_25"] forState:UIControlStateSelected];
    [dayButton setTitle:@"日" forState:UIControlStateNormal];
    [dayButton.titleLabel setFont:[UIFont systemFontOfSize:11.0f]];
    [dayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [dayButton setTitleColor:RGBFromHex(0x505050) forState:UIControlStateNormal];
    [_scrollView addSubview:dayButton];
    dayButton.frame = CGRectMake((IPHONE_WIDTH - 4 * 74.0f) / 2.0f, dayGraphView.bottom + 24.0f, 74.0f, 39.0f);
    dayButton.selected = YES;
    
    _scrollView.contentSize = CGSizeMake(IPHONE_WIDTH, dayButton.bottom + 24.0f);
    
    weekButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [weekButton addTarget:self action:@selector(weekButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [weekButton setBackgroundImage:[UIImage imageNamed:@"历史记录_20"] forState:UIControlStateNormal];
    [weekButton setBackgroundImage:[UIImage imageNamed:@"历史记录_26"] forState:UIControlStateSelected];
    [weekButton setTitle:@"周" forState:UIControlStateNormal];
    [weekButton.titleLabel setFont:[UIFont systemFontOfSize:11.0f]];
    [weekButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [weekButton setTitleColor:RGBFromHex(0x505050) forState:UIControlStateNormal];
    [_scrollView addSubview:weekButton];
    weekButton.frame = CGRectMake(dayButton.right, dayGraphView.bottom + 24.0f, 74.0f, 39.0f);
    
    monthButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [monthButton addTarget:self action:@selector(monthButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [monthButton setBackgroundImage:[UIImage imageNamed:@"历史记录_20"] forState:UIControlStateNormal];
    [monthButton setBackgroundImage:[UIImage imageNamed:@"历史记录_26"] forState:UIControlStateSelected];
    [monthButton setTitle:@"月" forState:UIControlStateNormal];
    [monthButton.titleLabel setFont:[UIFont systemFontOfSize:11.0f]];
    [monthButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [monthButton setTitleColor:RGBFromHex(0x505050) forState:UIControlStateNormal];
    [_scrollView addSubview:monthButton];
    monthButton.frame = CGRectMake(weekButton.right, dayGraphView.bottom + 24.0f, 74.0f, 39.0f);
    
    yearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [yearButton addTarget:self action:@selector(yearButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [yearButton setBackgroundImage:[UIImage imageNamed:@"历史记录_21"] forState:UIControlStateNormal];
    [yearButton setBackgroundImage:[UIImage imageNamed:@"历史记录_27"] forState:UIControlStateSelected];
    [yearButton setTitle:@"年" forState:UIControlStateNormal];
    [yearButton.titleLabel setFont:[UIFont systemFontOfSize:11.0f]];
    [yearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [yearButton setTitleColor:RGBFromHex(0x505050) forState:UIControlStateNormal];
    [_scrollView addSubview:yearButton];
    yearButton.frame = CGRectMake(monthButton.right, dayGraphView.bottom + 24.0f, 74.0f, 39.0f);
    
    _scrollView.contentSize = CGSizeMake(IPHONE_WIDTH, yearButton.bottom + 24.0f);
    
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    [_HUD show:YES];
    
    [model queryDailyReport];
}

- (UIImageView *)graphHeadView {
    UIImageView *graphHeadView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"历史记录_14"] resizableImageWithCapInsets:UIEdgeInsetsMake(3.0f, 5.0f, 3.0f, 5.0f)]];
    UIImageView *imageview1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"历史记录_07"]];
    UIImageView *imageview2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"历史记录_09"]];
    [graphHeadView addSubview:imageview1];
    [graphHeadView addSubview:imageview2];
    
    UILabel *caloriLabel = [[UILabel alloc] init];
    caloriLabel.textAlignment = NSTextAlignmentCenter;
    caloriLabel.backgroundColor = [UIColor clearColor];
    caloriLabel.font = [UIFont systemFontOfSize:7.0f];
    caloriLabel.textColor = RGBFromHex(0x00F0FF);
    caloriLabel.text = @"卡路里";
    [graphHeadView addSubview:caloriLabel];
    [caloriLabel sizeToFit];
    
    UILabel *stepLabel = [[UILabel alloc] init];
    stepLabel.textAlignment = NSTextAlignmentCenter;
    stepLabel.backgroundColor = [UIColor clearColor];
    stepLabel.font = [UIFont systemFontOfSize:7.0f];
    stepLabel.textColor = RGBFromHex(0xFFDE00);
    stepLabel.text = @"步数";
    [graphHeadView addSubview:stepLabel];
    [stepLabel sizeToFit];
    
    imageview1.centerY = graphHeadView.height / 2.0f;
    imageview1.left = 4.0f;
    caloriLabel.centerY = graphHeadView.height / 2.0f;
    caloriLabel.left = imageview1.right + 3.0f;
    imageview2.centerY = graphHeadView.height / 2.0f;
    imageview2.left = caloriLabel.right + 5.0f;
    stepLabel.centerY = graphHeadView.height / 2.0f;
    stepLabel.left = imageview2.right + 3.0f;
    graphHeadView.width = stepLabel.right + 4.0f;
    
    return graphHeadView;
}

- (void)dayButtonClick {
    if (dayButton.selected) {
        return;
    }
    
    if ([model queryDailyReport]) {
        [_HUD show:YES];
    } else {
        [self reloadDailyReportView];
    }
    
    dayButton.selected = YES;
    weekButton.selected = NO;
    monthButton.selected = NO;
    yearButton.selected = NO;
}

- (void)weekButtonClick {
    if (weekButton.selected) {
        return;
    }
    
    if ([model queryWeeklyReport]) {
        [_HUD show:YES];
    } else {
        [self reloadWeeklyReportView];
    }

    dayButton.selected = NO;
    weekButton.selected = YES;
    monthButton.selected = NO;
    yearButton.selected = NO;
}

- (void)monthButtonClick {
    if (monthButton.selected) {
        return;
    }
    
    if ([model queryMonthlyReport]) {
        [_HUD show:YES];
    } else {
        [self reloadMonthlyReportView];
    }
    
    dayButton.selected = NO;
    weekButton.selected = NO;
    monthButton.selected = YES;
    yearButton.selected = NO;
}

- (void)yearButtonClick {
    if (yearButton.selected) {
        return;
    }
    
    if ([model queryAnnualReport]) {
        [_HUD show:YES];
    } else {
        [self reloadAnnualReportView];
    }
    
    dayButton.selected = NO;
    weekButton.selected = NO;
    monthButton.selected = NO;
    yearButton.selected = YES;
}

- (void)reloadDailyReportView {
    dayGraphView.hidden = NO;
    weekGraphView.hidden = YES;
    monthGraphView.hidden = YES;
    yearGraphView.hidden = YES;
    
    progressView1.progress = model.dayCaloriePercent;
    progressView1.valueString = @(model.dayTotalCalorie).stringValue;
    
    progressView2.progress = model.dayStepsPercent;
    progressView2.valueString = @(model.dayTotalSteps).stringValue;
    
    progressView3.valueString = [NSString stringWithFormat:@"%@h", @(model.dayTotalSleep).stringValue];
    progressView3.progress = model.dayTotalSleep / 7.0f;
    
    dayCaloriePlot.plottingValues = model.dayCalorieDictionary;
    dayStepsPlot.plottingValues = model.dayStepsDictionary;
    [dayGraphView reloadPlot];
}

- (void)reloadWeeklyReportView {
    dayGraphView.hidden = YES;
    weekGraphView.hidden = NO;
    monthGraphView.hidden = YES;
    yearGraphView.hidden = YES;
    
    progressView1.progress = model.weekCaloriePercent;
    progressView1.valueString = @(model.weekCaloriePerday).stringValue;
    
    progressView2.progress = model.weekStepsPercent;
    progressView2.valueString = @(model.weekStepsPerday).stringValue;
    
    progressView3.valueString = [NSString stringWithFormat:@"%.1fh", model.weekSleepPerday];
    progressView3.progress = model.weekSleepPerday / 7.0f;
    
    weekCaloriePlot.plottingValues = model.weekCalorieDictionary;
    weekStepsPlot.plottingValues = model.weekStepsDictionary;
    [weekGraphView reloadPlot];
}

- (void)reloadMonthlyReportView {
    dayGraphView.hidden = YES;
    weekGraphView.hidden = YES;
    monthGraphView.hidden = NO;
    yearGraphView.hidden = YES;
    
    progressView1.progress = model.monthCaloriePercent;
    progressView1.valueString = @(model.monthCaloriePerday).stringValue;
    
    progressView2.progress = model.monthStepsPercent;
    progressView2.valueString = @(model.monthStepsPerday).stringValue;
    
    progressView3.valueString = [NSString stringWithFormat:@"%.1fh", model.monthSleepPerday];
    progressView3.progress = model.monthSleepPerday / 7.0f;
    
    monthCaloriePlot.plottingValues = model.monthCalorieDictionary;
    monthStepsPlot.plottingValues = model.monthStepsDictionary;
    [monthGraphView reloadPlot];
}

- (void)reloadAnnualReportView {
    dayGraphView.hidden = YES;
    weekGraphView.hidden = YES;
    monthGraphView.hidden = YES;
    yearGraphView.hidden = NO;
    
    progressView1.progress = model.yearCaloriePercent;
    progressView1.valueString = @(model.yearCaloriePerday).stringValue;
    
    progressView2.progress = model.yearStepsPercent;
    progressView2.valueString = @(model.yearStepsPerday).stringValue;
    
    progressView3.valueString = [NSString stringWithFormat:@"%.1fh", model.yearSleepPerday];
    progressView3.progress = model.yearSleepPerday / 7.0f;
    
    yearCaloriePlot.plottingValues = model.yearCalorieDictionary;
    yearStepsPlot.plottingValues = model.yearStepsDictionary;
    [yearGraphView reloadPlot];
}

- (void)dayRecordsQueryFinished {
    [self reloadDailyReportView];
    [_HUD hide:YES];
}

- (void)weekRecordsQueryFinished {
    [self reloadWeeklyReportView];
    [_HUD hide:YES];
}

- (void)monthRecordsQueryFinished {
    [self reloadMonthlyReportView];
    [_HUD hide:YES];
}

- (void)annualRecordsQueryFinished {
    [self reloadAnnualReportView];
    [_HUD hide:YES];
}

@end
