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

@interface SWHistoryRecordsViewController ()
{
    SWCircleProgressView *progressView1;
    SWCircleProgressView *progressView2;
    SWCircleProgressView *progressView3;
    
    UIButton *dayButton, *weekButton, *monthButton, *yearButton;
}

@property (nonatomic,strong) UIScrollView *scrollView;

@end

@implementation SWHistoryRecordsViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
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
    progressView1.bottomDesc = NSLocalizedString(@"目标", nil);
    progressView1.progress = 0.83;
    progressView1.valueString = @"83%";
    [_scrollView addSubview:progressView1];
    
    progressView2 = [[SWCircleProgressView alloc] initWithFrame:CGRectMake(progressView1.right + 10.0f, 35.0f, 0.0f, 0.0f)];
    progressView2.style = SWCircleProgressViewStyleSmall;
    progressView2.backImage = [UIImage imageNamed:@"历史记录_03"];
    progressView2.topDesc = NSLocalizedString(@"每日平均", nil);
    progressView2.bottomDesc = NSLocalizedString(@"目标", nil);
    progressView2.progress = 0.0f;
    progressView2.valueString = @"83%";
    [_scrollView addSubview:progressView2];
    
    progressView3 = [[SWCircleProgressView alloc] initWithFrame:CGRectMake(progressView1.right - 10.0f, progressView2.bottom + 6.0f, 0.0f, 0.0f)];
    progressView3.style = SWCircleProgressViewStyleSmall;
    progressView3.backImage = [UIImage imageNamed:@"历史记录_03"];
    progressView3.topDesc = NSLocalizedString(@"每日平均", nil);
    progressView3.bottomDesc = NSLocalizedString(@"目标", nil);
    progressView3.progress = 0.83;
    progressView3.valueString = @"83%";
    [_scrollView addSubview:progressView3];
    
    SWLineGraphView *graphView = [[SWLineGraphView alloc] initWithFrame:CGRectMake(0.0f, progressView3.bottom + 5.0f, IPHONE_WIDTH, 166.0f)];
    graphView.backgroundColor = [UIColor clearColor];
    graphView.xAxisValues = @[@{@1 : @"10-29"},@{@2 : @"10-30"},@{@3 : @"10-31"},@{@4 : @"11-01"},@{@5 : @"11-02"},@{@6 : @"11-03"},@{@7 : @"11-04"}];
    graphView.xIntervalCount = 7;
    graphView.xAxisDescription = @"时间";
    graphView.yAxisRange = 1.0f;
    graphView.yIntervalCount = 2;
    graphView.yAxisDescription = @"卡路里/步数走势";
    [_scrollView addSubview:graphView];
    
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
    
    graphView.headView = graphHeadView;
    
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
    
    dayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dayButton addTarget:self action:@selector(dayButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [dayButton setBackgroundImage:[UIImage imageNamed:@"历史记录_18"] forState:UIControlStateNormal];
    [dayButton setBackgroundImage:[UIImage imageNamed:@"历史记录_25"] forState:UIControlStateSelected];
    [dayButton setTitle:@"日" forState:UIControlStateNormal];
    [dayButton.titleLabel setFont:[UIFont systemFontOfSize:11.0f]];
    [dayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [dayButton setTitleColor:RGBFromHex(0x505050) forState:UIControlStateNormal];
    [_scrollView addSubview:dayButton];
    dayButton.frame = CGRectMake((IPHONE_WIDTH - 4 * 74.0f) / 2.0f, graphView.bottom + 24.0f, 74.0f, 39.0f);
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
    weekButton.frame = CGRectMake(dayButton.right, graphView.bottom + 24.0f, 74.0f, 39.0f);
    
    monthButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [monthButton addTarget:self action:@selector(monthButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [monthButton setBackgroundImage:[UIImage imageNamed:@"历史记录_20"] forState:UIControlStateNormal];
    [monthButton setBackgroundImage:[UIImage imageNamed:@"历史记录_26"] forState:UIControlStateSelected];
    [monthButton setTitle:@"月" forState:UIControlStateNormal];
    [monthButton.titleLabel setFont:[UIFont systemFontOfSize:11.0f]];
    [monthButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [monthButton setTitleColor:RGBFromHex(0x505050) forState:UIControlStateNormal];
    [_scrollView addSubview:monthButton];
    monthButton.frame = CGRectMake(weekButton.right, graphView.bottom + 24.0f, 74.0f, 39.0f);
    
    yearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [yearButton addTarget:self action:@selector(yearButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [yearButton setBackgroundImage:[UIImage imageNamed:@"历史记录_21"] forState:UIControlStateNormal];
    [yearButton setBackgroundImage:[UIImage imageNamed:@"历史记录_27"] forState:UIControlStateSelected];
    [yearButton setTitle:@"年" forState:UIControlStateNormal];
    [yearButton.titleLabel setFont:[UIFont systemFontOfSize:11.0f]];
    [yearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [yearButton setTitleColor:RGBFromHex(0x505050) forState:UIControlStateNormal];
    [_scrollView addSubview:yearButton];
    yearButton.frame = CGRectMake(monthButton.right, graphView.bottom + 24.0f, 74.0f, 39.0f);
    
    _scrollView.contentSize = CGSizeMake(IPHONE_WIDTH, yearButton.bottom + 24.0f);
    
}

- (void)dayButtonClick {
    if (dayButton.selected) {
        return;
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
    dayButton.selected = NO;
    weekButton.selected = YES;
    monthButton.selected = NO;
    yearButton.selected = NO;
}

- (void)monthButtonClick {
    if (monthButton.selected) {
        return;
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
    dayButton.selected = NO;
    weekButton.selected = NO;
    monthButton.selected = NO;
    yearButton.selected = YES;
}

@end
