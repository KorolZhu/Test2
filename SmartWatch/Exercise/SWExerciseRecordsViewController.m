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
#import "SWAccessoryPickerView.h"
#import "MBProgressHUD.h"
#import <MapKit/MapKit.h>
#import "LocationTracker.h"

@interface SWExerciseRecordsViewController ()<BLEDelegate,SWAccessoryPickerViewDelegate,MKMapViewDelegate>
{
    UIButton *leftBarButton;
    SWExerciseRecordsTitleView *titleView;
    SWEnvironmentView *environmentView;
    SWCircleProgressView *progressView;
    SWDashboardView *dashboardView;
    UIButton *curveButton, *trackButton;
    UIButton *calorieButton, *stepButton, *sleepButton;
    
    SWLineGraphView *calorieGraphView;
    SWLineGraphView *stepsGraphView;
    SWLineGraphView *sleepGraphView;
    SWLineGraphView *currentGraphView;
    
    SWPlot *caloriePlot;
    SWPlot *stepsPlot;
    SWPlot *sleepPlot;
	SWExerciseRecordsModel *model;
    
    SWAccessoryPickerView *accessoryPickerView;
	
    MKPolyline *polyline;
    MKPolylineView *polylineView;
	UIButton *connectPointButton;
	UIButton *fullScreenButton;
	
	NSArray *annotations;
	NSArray *images;
	MKMapRect visibleRect;
    
    NSTimer *scanTimer;
    MBProgressHUD *progressHUD;
}

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) MKMapView *mapView;

@end

@implementation SWExerciseRecordsViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
		
		model = [[SWExerciseRecordsModel alloc] initWithResponder:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(synchronizeStart) name:kSWBLESynchronizeStartNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(synchronizeSucceed) name:kSWBLESynchronizeSuccessNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(synchronizeFailed) name:kSWBLESynchronizeFailNotification object:nil];
    }
    
    return self;
}

- (void)dealloc {
    [[SWBLECenter shareInstance] removeObserver:self forKeyPath:@"state" context:NULL];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_scrollView];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1背景-ios_01"] forBarMetrics:UIBarMetricsDefault];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"1背景-ios_02"]];
    
    leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarButton.frame = CGRectMake(0.0f, 0.0f, 44.0f, 44.0f);
    [leftBarButton setImage:[UIImage imageNamed:@"蓝牙"] forState:UIControlStateNormal];
    [leftBarButton addTarget:self action:@selector(bleClick) forControlEvents:UIControlEventTouchUpInside];
    leftBarButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    leftBarButton.titleLabel.minimumScaleFactor = 10.f/13.0f;
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    self.navigationItem.leftBarButtonItem = leftBtn;

    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"分享"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(shareClick)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    titleView = [[SWExerciseRecordsTitleView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 220.0f, 44.0f)];
    [titleView.lastButton addTarget:self action:@selector(preDateClick) forControlEvents:UIControlEventTouchUpInside];
    [titleView.nextButton addTarget:self action:@selector(nextDateClick) forControlEvents:UIControlEventTouchUpInside];
    titleView.date = [NSDate date];
    self.navigationItem.titleView = titleView;
    
    
    environmentView = [[SWEnvironmentView alloc] initWithFrame:CGRectMake(14.0f, 12.0f, IPHONE_WIDTH - 28.0f, 25.0f)];
    environmentView.temperature = 0;
    environmentView.humidity = 0;
    environmentView.leftPower = [SWSettingInfo shareInstance].battery;
    [_scrollView addSubview:environmentView];
    
    progressView = [[SWCircleProgressView alloc] initWithFrame:CGRectMake(14.0f, environmentView.bottom + 15.0f, 0.0f, 0.0f)];
    progressView.backImage = [UIImage imageNamed:@"1运动记录_70"];
    progressView.topDesc = NSLocalizedString(@"今日", nil);
    progressView.bottomDesc = NSLocalizedString(@"目标", nil);
    [_scrollView addSubview:progressView];
    
    dashboardView = [[SWDashboardView alloc] initWithFrame:CGRectMake(progressView.right + 11.0f, progressView.top + 10.0f, 107.0f, 171.0f)];
    [_scrollView addSubview:dashboardView];
    dashboardView.value1 = 0;
    dashboardView.unit1 = @"千卡";
    dashboardView.descri1 = @"燃烧";
    dashboardView.value2 = 0;
    dashboardView.unit2 = @"公里";
    dashboardView.descri2 = @"距离";
    dashboardView.value3 = 0;
    dashboardView.unit3 = @"步";
    dashboardView.descri3 = @"步数";
    
    calorieGraphView = [[SWLineGraphView alloc] initWithFrame:CGRectMake(0.0f, progressView.bottom + 10.0f, IPHONE_WIDTH, 166.0f)];
    calorieGraphView.backgroundColor = [UIColor clearColor];
    calorieGraphView.xAxisValues = @[@{@6 : @"6"},@{@12 : @"12"},@{@18 : @"18"},@{@24 : @"24"}];
    calorieGraphView.xIntervalCount = 24;
    calorieGraphView.xAxisDescription = @"时间";
    calorieGraphView.yAxisRange = 100;
    calorieGraphView.yIntervalCount = 2;
    calorieGraphView.yAxisDescription = @"卡路里（千卡）";
		
	caloriePlot = [[SWPlot alloc] init];
	caloriePlot.plotThemeAttributes = @{
										kPlotFillColorKey : [UIColor clearColor],
										kPlotStrokeWidthKey : @1,
										kPlotStrokeColorKey : RGBFromHex(0x00F0FF),
										kPlotPointFillColorKey : RGBFromHex(0x00F0FF)};
	[calorieGraphView addPlot:caloriePlot];
	[calorieGraphView setupTheView];
	[_scrollView addSubview:calorieGraphView];

    currentGraphView = calorieGraphView;
    
//    SWPlot *plot = [[SWPlot alloc] init];
//    plot.plottingValues = @[
//                              @{ @6 : @20.0f },
//                              @{ @7 : @70.0f },
//                              @{ @8 : @50.0f },
//                              @{ @9 : @40.0f },
//                              @{ @10 : @15.0f },
//                              @{ @11 : @10.0f },
//                              @{ @12 : @13.0f },
//                              @{ @13 : @20.0f },
//                              @{ @14 : @14.0f },
//                              @{ @15 : @10.0f },
//                              @{ @16 : @6.0f },
//                              @{ @18 : @25.0f },
//                              @{ @19 : @40.0f },
//                              @{ @20 : @30.0f },
//                              @{ @21 : @20.0f }];
	
    curveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [curveButton addTarget:self action:@selector(curveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [curveButton setBackgroundImage:[UIImage imageNamed:@"button1"] forState:UIControlStateNormal];
    [curveButton setBackgroundImage:[UIImage imageNamed:@"button2"] forState:UIControlStateSelected];
    [curveButton setTitle:@"曲线图" forState:UIControlStateNormal];
    [curveButton.titleLabel setFont:[UIFont systemFontOfSize:9.0f]];
    [curveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [curveButton setTitleColor:RGBFromHex(0x505050) forState:UIControlStateNormal];
    [_scrollView addSubview:curveButton];
    curveButton.frame = CGRectMake(IPHONE_WIDTH - 121.0f, calorieGraphView.bottom + 5.0f, 48.0f, 19.0f);
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
    trackButton.frame = CGRectMake(curveButton.right + 5.0f, calorieGraphView.bottom + 5.0f, 48.0f, 19.0f);
    
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
    
    [model queryExerciseRecordsWithDate:[NSDate date]];
    titleView.nextButton.enabled = NO;
    
    if (!progressHUD) {
        progressHUD = [[MBProgressHUD alloc] initWithView:self.tabBarController.view];
        [self.tabBarController.view addSubview:progressHUD];
    }
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newLocationProduced:) name:KNewLocationProducedNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationWillBecomeActive)
												 name:UIApplicationDidBecomeActiveNotification
											   object:nil];
	
	[model queryWeatherInfo];
}

- (void)applicationWillBecomeActive {
	[model queryWeatherInfo];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - Synchronize

- (void)synchronizeStart {
    if ([NSThread isMainThread]) {
        progressHUD.detailsLabelText = NSLocalizedString(@"同步中...", nil);
    } else {
        [[GCDQueue mainQueue] queueBlock:^{
            progressHUD.detailsLabelText = NSLocalizedString(@"同步中...", nil);
        }];
    }
}

- (void)synchronizeSucceed {
    if ([NSThread isMainThread]) {
        [progressHUD hide:YES];
        environmentView.leftPower = [SWSettingInfo shareInstance].battery;
        [model queryExerciseRecordsWithDate:[NSDate date]];
        [titleView setDate:[NSDate date]];
		titleView.nextButton.enabled = NO;
    } else {
        [[GCDQueue mainQueue] queueBlock:^{
            [progressHUD hide:YES];
            environmentView.leftPower = [SWSettingInfo shareInstance].battery;
            [model queryExerciseRecordsWithDate:[NSDate date]];
            [titleView setDate:[NSDate date]];
			titleView.nextButton.enabled = NO;
        }];
    }
    
}

- (void)synchronizeFailed {
    if ([NSThread isMainThread]) {
        [progressHUD hide:YES];
    } else {
        [[GCDQueue mainQueue] queueBlock:^{
            [progressHUD hide:YES];
        }];
    }
}

#pragma mark - Ble 

- (void)bleClick {
    if ([SWBLECenter shareInstance].state == SWPeripheralStateDisconnected) {
        NSString *lastuuid = [[NSUserDefaults standardUserDefaults] stringForKey:LASTPERIPHERALUUID];
        if (lastuuid.length > 0) {
            progressHUD.detailsLabelText = NSLocalizedString(@"扫描中...", nil);
            [progressHUD show:NO];
            
            scanTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(scanTimeout) userInfo:nil repeats:YES];
        } else {
            [self scanTimeout];
        }
        
        [[SWBLECenter shareInstance] scanBLEPeripherals];
        [[SWBLECenter shareInstance].ble addObserver:self forKeyPath:@"peripherals" options: NSKeyValueObservingOptionNew context:NULL];
    } else {
        [[SWBLECenter shareInstance] disconnectDevice];
    }
}

- (void)scanTimeout {
    [scanTimer invalidate];
    scanTimer = nil;
    
    [progressHUD hide:NO];
    
    if (!accessoryPickerView) {
        accessoryPickerView = [[SWAccessoryPickerView alloc] initWithFrame:CGRectMake(22.0f, 100.0f, IPHONE_WIDTH - 44.0f, IPHONE_HEIGHT - 200.0f)];
        accessoryPickerView.title = NSLocalizedString(@"请选择蓝牙设备", nil);
        accessoryPickerView.delegate = self;
    }
    
    [accessoryPickerView show];
    [accessoryPickerView setDataSource:[NSArray arrayWithArray:[SWBLECenter shareInstance].ble.peripherals]];
}

- (void)accessoryPickerView:(SWAccessoryPickerView *)pickerView didSelectPeripheral:(CBPeripheral *)peripheral {
    [[SWBLECenter shareInstance].ble removeObserver:self forKeyPath:@"peripherals"];
    [[SWBLECenter shareInstance] stopScanBLEPeripherals];
    if (accessoryPickerView.isVisible) {
        [accessoryPickerView hide];
    }
    [[SWBLECenter shareInstance] connectPeripheral:peripheral];
}

- (void)accessoryPickerViewDidCancel:(SWAccessoryPickerView *)pickerView {
    [[SWBLECenter shareInstance].ble removeObserver:self forKeyPath:@"peripherals"];
    [[SWBLECenter shareInstance] stopScanBLEPeripherals];
    if (accessoryPickerView.isVisible) {
        [accessoryPickerView hide];
    }
}

#pragma mark -

- (void)shareClick {
    UIView *view = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [[SWShareKit sharedInstance] sendImage:image withType:SWShareTypeWechatTimeline];
}

- (void)preDateClick {
    NSDate *preDate = [model.currentDate dateByAddingTimeInterval:-24 * 3600];
    [model queryExerciseRecordsWithDate:preDate];
    [titleView setDate:preDate];
	
	if (self.mapView) {
		[model queryLocationWithDate:titleView.date];
	}
    
    if (!titleView.nextButton.enabled) {
        titleView.nextButton.enabled = YES;
    }
}

- (void)nextDateClick {
    if ([[NSDate date] timeIntervalSinceDate:model.currentDate] < 2 * 24 * 3600) {
        titleView.nextButton.enabled = NO;
    }
    
    NSDate *nextDate = [model.currentDate dateByAddingTimeInterval:24 * 3600];
    [model queryExerciseRecordsWithDate:nextDate];
    [titleView setDate:nextDate];
	
	if (self.mapView) {
		[model queryLocationWithDate:titleView.date];
	}
}

- (void)curveButtonClick {
    if (curveButton.selected) {
        return;
    }
    curveButton.selected = YES;
    trackButton.selected = NO;
    
    if (self.mapView.superview) {
        [self.mapView removeFromSuperview];
    }
    
    currentGraphView.hidden = NO;
}

- (void)connectPointButtonClick:(UIButton *)button {
	if (!button.selected) {
		button.selected = YES;
		[button setBackgroundColor:[UIColor whiteColor]];
		for (MKPointAnnotation *annotation in self.mapView.annotations) {
			MKAnnotationView *annotationView = [self.mapView viewForAnnotation:annotation];
			NSInteger index = [annotations indexOfObject:annotation];
			if (images.count > index) {
				annotationView.image = [images objectAtIndex:index];
			}
		}
		if (nil != polyline) {
			[self.mapView addOverlay:polyline];
		}
		[self.mapView setVisibleMapRect:visibleRect];
	} else {
		button.selected = NO;
		[button setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.2f]];
		for (MKPointAnnotation *annotation in self.mapView.annotations) {
			MKAnnotationView *annotationView = [self.mapView viewForAnnotation:annotation];
			annotationView.image = [UIImage imageNamed:@"mainMap_SmallBlue"];
		}
		if (nil != polyline) {
			[self.mapView removeOverlay:polyline];
		}
	}
}

- (void)fullScreenButtonClick:(UIButton *)button {
	if (!button.selected) {
		[UIView animateWithDuration:0.2f animations:^{
			self.mapView.frame = self.scrollView.bounds;
			connectPointButton.frame = CGRectMake(self.mapView.width - 45.0f, 15.0f, 30.0f, 30.0f);
		} completion:^(BOOL finished) {
			button.selected = YES;
			self.scrollView.scrollsToTop = NO;
		}];
	} else {
		[UIView animateWithDuration:0.2f animations:^{
			self.mapView.frame = CGRectMake(12.0f, progressView.bottom + 10.0f, IPHONE_WIDTH - 24.0f, 166.0f);
			connectPointButton.frame = CGRectMake(self.mapView.width - 45.0f, 15.0f, 30.0f, 30.0f);
		} completion:^(BOOL finished) {
			button.selected = NO;
			self.scrollView.scrollsToTop = YES;
		}];
	}
}

- (void)trackButtonClick {
    if (trackButton.selected) {
        return;
    }
    curveButton.selected = NO;
    trackButton.selected = YES;
    
    if (!self.mapView) {
        self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(12.0f, progressView.bottom + 10.0f, IPHONE_WIDTH - 24.0f, 166.0f)];
		self.mapView.rotateEnabled = NO;
        self.mapView.delegate = self;
        self.mapView.layer.cornerRadius = 3.5f;
		
		connectPointButton = [UIButton buttonWithType:UIButtonTypeCustom];
		connectPointButton.frame = CGRectMake(self.mapView.width - 45.0f, 15.0f, 30.0f, 30.0f);
		[connectPointButton setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.2f]];
		[connectPointButton setImage:[UIImage imageNamed:@"aw_mapview_track_line"] forState:UIControlStateNormal];
		[connectPointButton setImage:[UIImage imageNamed:@"aw_mapview_track_line_selected"] forState:UIControlStateSelected];
		connectPointButton.layer.cornerRadius = 3.0f;
		[connectPointButton addTarget:self action:@selector(connectPointButtonClick:) forControlEvents:UIControlEventTouchUpInside];
		[self.mapView addSubview:connectPointButton];
		
		fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
		fullScreenButton.frame = CGRectMake(15.0f, 15.0f, 30.0f, 30.0f);
		[fullScreenButton setBackgroundColor:[UIColor clearColor]] ;
		[fullScreenButton setImage:[UIImage imageNamed:@"map_001"] forState:UIControlStateNormal];
		[fullScreenButton setImage:[UIImage imageNamed:@"map_002"] forState:UIControlStateSelected];
		fullScreenButton.layer.cornerRadius = 3.0f;
		[fullScreenButton addTarget:self action:@selector(fullScreenButtonClick:) forControlEvents:UIControlEventTouchUpInside];
		[self.mapView addSubview:fullScreenButton];

        [model queryLocationWithDate:titleView.date];
    }
    
    if (!self.mapView.superview) {
        [_scrollView addSubview:self.mapView];
    }
    
    currentGraphView.hidden = YES;
}

- (void)calorieButtonClick {
    if (calorieButton.selected) {
        return;
    }
    calorieButton.selected = YES;
    stepButton.selected = NO;
    sleepButton.selected = NO;

    [self reloadProgressData];

	calorieGraphView.hidden = NO;
	stepsGraphView.hidden = YES;
	sleepGraphView.hidden = YES;
    
    currentGraphView = calorieGraphView;
    [self curveButtonClick];
}

- (void)stepButtonClick {
    if (stepButton.selected) {
        return;
    }
    calorieButton.selected = NO;
    stepButton.selected = YES;
    sleepButton.selected = NO;
	
	if (!stepsGraphView) {
		stepsGraphView = [[SWLineGraphView alloc] initWithFrame:calorieGraphView.frame];
		stepsGraphView.backgroundColor = [UIColor clearColor];
		stepsGraphView.xAxisValues = @[@{@6 : @"6"},@{@12 : @"12"},@{@18 : @"18"},@{@24 : @"24"}];
		stepsGraphView.xIntervalCount = 24;
		stepsGraphView.xAxisDescription = @"时间";
		stepsGraphView.yAxisRange = 2000.0;
		stepsGraphView.yIntervalCount = 2;
		stepsGraphView.yAxisDescription = @"步数";
		
		stepsPlot = [[SWPlot alloc] init];
		stepsPlot.plottingValues = model.stepsDictionary;
		stepsPlot.plotThemeAttributes = @{
											kPlotFillColorKey : [UIColor clearColor],
											kPlotStrokeWidthKey : @1,
											kPlotStrokeColorKey : RGBFromHex(0x00F0FF),
											kPlotPointFillColorKey : RGBFromHex(0x00F0FF)};
		[stepsGraphView addPlot:stepsPlot];
		[stepsGraphView setupTheView];
		[_scrollView addSubview:stepsGraphView];
	}
	
    [self reloadProgressData];

	calorieGraphView.hidden = YES;
	stepsGraphView.hidden = NO;
	sleepGraphView.hidden = YES;
    
    currentGraphView = stepsGraphView;
    [self curveButtonClick];
}

- (void)sleepButtonClick {
    if (sleepButton.selected) {
        return;
    }
    calorieButton.selected = NO;
    stepButton.selected = NO;
    sleepButton.selected = YES;
	
	if (!sleepGraphView) {
		sleepGraphView = [[SWLineGraphView alloc] initWithFrame:calorieGraphView.frame];
		sleepGraphView.backgroundColor = [UIColor clearColor];
		sleepGraphView.xAxisValues = @[@{@6 : @"6"},@{@12 : @"12"},@{@18 : @"18"},@{@24 : @"24"}];
		sleepGraphView.xIntervalCount = 24;
		sleepGraphView.xAxisDescription = @"时间";
		sleepGraphView.yAxisRange = 100;
		sleepGraphView.yIntervalCount = 2;
		sleepGraphView.yAxisDescription = @"睡眠";
		
		sleepPlot = [[SWPlot alloc] init];
		sleepPlot.plottingValues = model.sleepDictionary;
		sleepPlot.plotThemeAttributes = @{
										  kPlotFillColorKey : [UIColor clearColor],
										  kPlotStrokeWidthKey : @1,
										  kPlotStrokeColorKey : RGBFromHex(0x00F0FF),
										  kPlotPointFillColorKey : RGBFromHex(0x00F0FF)};
		[sleepGraphView addPlot:sleepPlot];
		[sleepGraphView setupTheView];
		[_scrollView addSubview:sleepGraphView];
	}
    
    [self reloadProgressData];
	
	calorieGraphView.hidden = YES;
	stepsGraphView.hidden = YES;
	sleepGraphView.hidden = NO;
    
    currentGraphView = sleepGraphView;
    [self curveButtonClick];
}

- (void)reloadProgressData {
    if (calorieButton.selected) {
        progressView.topDesc = NSLocalizedString(@"今日", nil);
        progressView.bottomDesc = NSLocalizedString(@"目标", nil);
        progressView.progress = model.caloriePercent;
        progressView.valueString = model.caloriePercentString;
        dashboardView.value1 = @((int)model.totalCalorie).stringValue;
        dashboardView.unit1 = @"千卡";
        dashboardView.descri1 = @"燃烧";
        dashboardView.value2 = [NSString stringWithFormat:@"%.1f", model.totalDistance];
        dashboardView.unit2 = @"公里";
        dashboardView.descri2 = @"距离";
        dashboardView.value3 = @(model.totalSteps).stringValue;
        dashboardView.unit3 = @"";
        dashboardView.descri3 = @"步数";
    } else if (stepButton.selected) {
        progressView.topDesc = NSLocalizedString(@"今日", nil);
        progressView.bottomDesc = NSLocalizedString(@"步", nil);
        progressView.progress = model.stepsPercent;
        progressView.valueString = @(model.totalSteps).stringValue;
        dashboardView.value1 = @(model.daylightActivitytime).stringValue;
        dashboardView.unit1 = @"小时";
        dashboardView.descri1 = @"活动";
        dashboardView.value2 = @(24 - model.daylightActivitytime).stringValue;
        dashboardView.unit2 = @"小时";
        dashboardView.descri2 = @"非活动";
        dashboardView.unit3 = @"";
        dashboardView.value3 = model.stepsPercentString;
        dashboardView.descri3 = @"目标百分比";
    } else {
        progressView.topDesc = NSLocalizedString(@"今日", nil);
        progressView.bottomDesc = NSLocalizedString(@"睡眠", nil);
        progressView.progress = model.sleepPercent;
        progressView.valueString = [NSString stringWithFormat:@"%@h", @(model.deepSleepHour + model.lightSleepHour).stringValue];
        dashboardView.value1 = @(model.deepSleepHour).stringValue;
        dashboardView.unit1 = @"小时";
        dashboardView.descri1 = @"深睡";
        dashboardView.value2 = @(model.lightSleepHour).stringValue;
        dashboardView.unit2 = @"小时";
        dashboardView.descri2 = @"浅睡";
        dashboardView.unit3 = @"小时";
        dashboardView.value3 = @(model.nightActivityHour).stringValue;
        dashboardView.descri3 = @"活动";
    }
    
}

- (void)reloadGraphData {
    
}

- (void)newLocationProduced:(NSNotification *)notification {
	if (self.mapView) {
		NSString * dateString = [[NSDate date] stringWithFormat:@"yyyyMMdd"];
		if ([dateString isEqualToString:model.currentDateString]) {
			[model queryLocationWithDate:titleView.date];
		}
	}
	
}

#pragma mark - Mpa view

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
	if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
		static NSString *reuseIndetifier = @"annotationReuseIndetifier";
		MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
		if (annotationView == nil)
		{
			annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
														  reuseIdentifier:reuseIndetifier];
			annotationView.canShowCallout = NO;
		}
		if (connectPointButton.selected) {
			NSInteger index = [annotations indexOfObject:annotation];
			if (images.count > index) {
				annotationView.image = [images objectAtIndex:index];
			}
		} else {
			annotationView.image = [UIImage imageNamed:@"mainMap_SmallBlue"];
		}
		return annotationView;
	}
	
	return nil;
}

- (void)mapView:(MKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews
{
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKOverlayView* overlayView = nil;
    
    if(overlay == polyline)
    {
        //if we have not yet created an overlay view for this overlay, create it now.
        if (polylineView) {
            [polylineView removeFromSuperview];
        }
        
        polylineView = [[MKPolylineView alloc] initWithPolyline:polyline];
        polylineView.fillColor = RGBFromHex(0x00F0FF);
        polylineView.strokeColor = RGBFromHex(0x00F0FF);
        polylineView.lineWidth = 5.0;
        
        overlayView = polylineView;
    }
    
    return overlayView;
}

- (double)getRadiansWithPoint:(CGPoint)point {
	double radians;
	
	if (point.x == 0 && point.y <= 0) {
		radians = 0.0f;
	} else if (point.x == 0 && point.y > 0){
		radians = M_PI;
	} else if (point.y == 0 && point.x < 0) {
		radians = M_PI / 2.0f;
	} else if (point.y == 0 && point.x > 0) {
		radians = M_PI_2 * 3;
	} else {
		radians = atan(ABS(point.x) / ABS(point.y));
		
		if (point.x < 0 && point.y < 0) {
			
		} else if (point.x < 0 && point.y > 0) {
			radians = M_PI - radians;
		} else if (point.x > 0 && point.y > 0) {
			radians += M_PI;
		} else if (point.x > 0 && point.y < 0){
			radians *= M_PI_2 * 3;
		}
	}
	
	return radians;
}

#pragma mark - Model

- (void)exerciseRecordsQueryFinished {
    [self reloadProgressData];

	caloriePlot.plottingValues = model.calorieDictionary;
	stepsPlot.plottingValues = model.stepsDictionary;
	sleepPlot.plottingValues = model.sleepDictionary;
	[calorieGraphView reloadPlot];
	[stepsGraphView reloadPlot];
	[sleepGraphView reloadPlot];
    
    [progressHUD hide:YES];
}

- (void)locationQueryFinished {
	if (self.mapView.annotations.count > 0) {
		[self.mapView removeAnnotations:annotations];
	}
	
	MKMapPoint northEastPoint = MKMapPointMake(0.f, 0.f);
	MKMapPoint southWestPoint = MKMapPointMake(0.f, 0.f);
	
	MKMapPoint* pointArray = malloc(sizeof(CLLocationCoordinate2D) * model.locationArray.count);
	
	NSMutableArray *tempAnnotations = [NSMutableArray array];
	
	for(int idx = 0; idx < model.locationArray.count; idx++)
	{
		CLLocation *location = [model.locationArray objectAtIndex:idx];
		
		MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
		pointAnnotation.coordinate = location.coordinate;
		[tempAnnotations addObject:pointAnnotation];
		
		// create our coordinate and add it to the correct spot in the array
		MKMapPoint point = MKMapPointForCoordinate(location.coordinate);
		pointArray[idx] = point;
		
		// if it is the first point, just use them, since we have nothing to compare to yet.
		if (idx == 0) {
			northEastPoint = point;
			southWestPoint = point;
		} else {
			if (point.x > northEastPoint.x)
				northEastPoint.x = point.x;
			if(point.y > northEastPoint.y)
				northEastPoint.y = point.y;
			if (point.x < southWestPoint.x)
				southWestPoint.x = point.x;
			if (point.y < southWestPoint.y)
				southWestPoint.y = point.y;
		}
		
	}
	
	NSMutableArray *tempImages = [NSMutableArray array];
	
	for (NSInteger i = 0; i < tempAnnotations.count; i++) {
		if (i == tempAnnotations.count - 1) {
			[tempImages addObject:[UIImage imageNamed:@"ic_marker_end"]];
		} else {
			MKPointAnnotation *annotation = [tempAnnotations objectAtIndex:i];
			MKPointAnnotation *nextAnnotation = [tempAnnotations objectAtIndex:i + 1];
			CGPoint point = [_mapView convertCoordinate:[annotation coordinate] toPointToView:_mapView];
			CGPoint nextPoint = [_mapView convertCoordinate:nextAnnotation.coordinate toPointToView:_mapView];
			CGPoint temp = CGPointMake(nextPoint.x - point.x, nextPoint.y - point.y);
			
			double radians = [self getRadiansWithPoint:temp];
			UIImage *rotatedImage = [[UIImage imageNamed:@"ic_marker_direct"] rotateImagePixelsInRadians:radians];
			[tempImages addObject:rotatedImage];
		}
	}
	
	annotations = [NSArray arrayWithArray:tempAnnotations];
	images = [NSArray arrayWithArray:tempImages];
	
	[_mapView addAnnotations:annotations];
	
	if (polyline) {
		[self.mapView removeOverlay:polyline];
	}
	polyline = [MKPolyline polylineWithPoints:pointArray count:model.locationArray.count];

	if (connectPointButton.selected) {
		if (nil != polyline) {
			[self.mapView addOverlay:polyline];
		}
	}
	
	free(pointArray);
	
	double width = northEastPoint.x - southWestPoint.x;
	double height = northEastPoint.y - southWestPoint.y;
	
	MKMapRect routeRect = MKMapRectMake(southWestPoint.x, southWestPoint.y, width, height);
	visibleRect = routeRect;
	
	[self.mapView setVisibleMapRect:routeRect];
}

- (void)weatherInfoUpdated {
	environmentView.uvLevel = model.uvLevel;
	environmentView.humidity = model.shidu;
	environmentView.temperature = model.temp;
	environmentView.leftPower = [SWSettingInfo shareInstance].battery;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"state"]) {
        NSInteger state = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        switch (state) {
            case SWPeripheralStateDisconnected: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [progressHUD hide:NO];
                    leftBarButton.enabled = YES;
                    [leftBarButton setImage:[UIImage imageNamed:@"蓝牙"] forState:UIControlStateNormal];
                    [leftBarButton setTitle:nil forState:UIControlStateNormal];
                });
            }
                break;
            case SWPeripheralStateConnected: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    leftBarButton.enabled = YES;
                    [leftBarButton setImage:nil forState:UIControlStateNormal];
                    [leftBarButton setTitle:NSLocalizedString(@"已连接", nil) forState:UIControlStateNormal];
                });
            }
                break;
            default: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    leftBarButton.enabled = NO;
                    [leftBarButton setImage:[UIImage imageNamed:@"蓝牙"] forState:UIControlStateNormal];
                    [leftBarButton setTitle:nil forState:UIControlStateNormal];
                    
                    if (state == SWPeripheralStateConnecting) {
                        if (progressHUD.hidden || progressHUD.alpha == 0.0f) {
                            [progressHUD show:NO];
                        }
                        progressHUD.detailsLabelText = NSLocalizedString(@"连接中...", nil);
                    }
                });

            }
                break;
        }
    } else if ([keyPath isEqualToString:@"peripherals"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (accessoryPickerView.isVisible) {
                [accessoryPickerView setDataSource:[NSArray arrayWithArray:[SWBLECenter shareInstance].ble.peripherals]];
            } else {
                NSString *lastuuid = [[NSUserDefaults standardUserDefaults] stringForKey:LASTPERIPHERALUUID];
                if (lastuuid.length > 0) {
                    NSArray *array = [NSArray arrayWithArray:[SWBLECenter shareInstance].ble.peripherals];
                    for (CBPeripheral *peripheral in array) {
                        if ([peripheral.identifier.UUIDString isEqualToString:lastuuid]) {
                            if ([scanTimer isValid] && ![accessoryPickerView isVisible]) {
                                [self accessoryPickerView:nil didSelectPeripheral:peripheral];
                                [scanTimer invalidate];
                                scanTimer = nil;
                            }
                            
                            break;
                        }
                    }
                }
            }

        });
    }
}

@end
