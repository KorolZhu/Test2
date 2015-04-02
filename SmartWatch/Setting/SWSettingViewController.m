//
//  SWSettingViewController.m
//  SmartWatch
//
//  Created by zhuzhi on 14/11/16.
//
//

#import "SWSettingViewController.h"
#import "SWTargetSetViewController.h"
#import "SWLostSettingViewController.h"
#import "SWDaylightSetViewController.h"
#import "SWSettingModel.h"
#import "SWAlarmSetViewController.h"
#import "SWDeviceConnectdViewController.h"

@interface SWSettingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    SWSettingModel *model;
    UISwitch *preventLostSwitch;
}

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation SWSettingViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        model = [[SWSettingModel alloc] initWithResponder:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(synchronizeSucceed) name:kSWBLESynchronizeSuccessNotification object:nil];
    }
    
    return self;
}

- (void)viewDidLoad {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"4背景-ios_01"] forBarMetrics:UIBarMetricsDefault];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"4背景-ios_02"]];
    
    self.navigationItem.title = NSLocalizedString(@"Settings", nil);
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    [self.view addSubview:_tableView];
    
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.tableView.indexPathForSelectedRow) {
        [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    }
}

- (void)preventLostSwitchValueChanged:(UISwitch *)switc {
    if ([[SWBLECenter shareInstance] setPreventLostState:switc.on]) {
        [model savePreventLost:switc.on];
    } else {
        switc.on = !switc.on;
    }
}

- (void)trackSwitchValueChanged:(UISwitch *)switc {
	[[NSUserDefaults standardUserDefaults] setInteger:switc.on forKey:@"TrackEnable"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)synchronizeSucceed {
    if ([NSThread isMainThread]) {
        preventLostSwitch.on = ([SWSettingInfo shareInstance].preventLost == 1);
    } else {
        [[GCDQueue mainQueue] queueBlock:^{
            preventLostSwitch.on = ([SWSettingInfo shareInstance].preventLost == 1);
        }];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    static NSString *lostCellIdentifier = @"lostCellIdentifier";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indexPath.row == 4 ? lostCellIdentifier : cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indexPath.row == 4 ? lostCellIdentifier : cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        
        if (indexPath.row == 4) {
			cell.accessoryType = UITableViewCellAccessoryNone;
			
            preventLostSwitch = [[UISwitch alloc] init];
            [preventLostSwitch addTarget:self action:@selector(preventLostSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
            preventLostSwitch.right = IPHONE_WIDTH - 12.0f;
            preventLostSwitch.centerY = 22.0f;
            [cell.contentView addSubview:preventLostSwitch];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
		} else if (indexPath.row == 5) {
			cell.accessoryType = UITableViewCellAccessoryNone;

			UISwitch *switc = [[UISwitch alloc] init];
			[switc addTarget:self action:@selector(trackSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
			switc.right = IPHONE_WIDTH - 12.0f;
			switc.centerY = 22.0f;
			[cell.contentView addSubview:switc];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			switc.on = ([[NSUserDefaults standardUserDefaults] integerForKey:@"TrackEnable"] == 1);
		}
    }
	
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"4设置_08"];
        cell.textLabel.text = NSLocalizedString(@"Watch ID", nil);
    } else if (indexPath.row == 1) {
        cell.imageView.image = [UIImage imageNamed:@"4设置_25"];
        cell.textLabel.text = NSLocalizedString(@"Alarm Clock", nil);
    } else if (indexPath.row == 2) {
        cell.imageView.image = [UIImage imageNamed:@"4设置_30"];
        cell.textLabel.text = NSLocalizedString(@"DayTime Set", nil);
    } else if (indexPath.row == 3) {
        cell.imageView.image = [UIImage imageNamed:@"4设置_32"];
        cell.textLabel.text = NSLocalizedString(@"Target Set", nil);
    }
    else if (indexPath.row == 4) {
        cell.imageView.image = [UIImage imageNamed:@"4设置_37"];
        cell.textLabel.text = NSLocalizedString(@"Anti Loss Set", nil);
        preventLostSwitch.on = ([SWSettingInfo shareInstance].preventLost == 1);
    }
	else if (indexPath.row == 5) {
		cell.imageView.image = [UIImage imageNamed:@"4设置_37"];
		cell.textLabel.text = NSLocalizedString(@"Track Record", nil);
	}
    else if (indexPath.row == 6) {
        cell.imageView.image = [UIImage imageNamed:@"4设置_41"];
        cell.textLabel.text = NSLocalizedString(@"About us", nil);
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        SWDeviceConnectdViewController *viewController = [[SWDeviceConnectdViewController alloc] init];
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    } else if (indexPath.row == 1) {
        SWAlarmSetViewController *alarmViewController = [[SWAlarmSetViewController alloc] init];
        alarmViewController.model = model;
        [self.navigationController pushViewController:alarmViewController animated:YES];
    } else if (indexPath.row == 2) {
        SWDaylightSetViewController *daylightSetViewController = [[SWDaylightSetViewController alloc] init];
        daylightSetViewController.model = model;
        [self.navigationController pushViewController:daylightSetViewController animated:YES];
    } else if (indexPath.row == 3) {
        SWTargetSetViewController *targetSetViewController = [[SWTargetSetViewController alloc] init];
        targetSetViewController.model = model;
        [self.navigationController pushViewController:targetSetViewController animated:YES];
        
    }
    else if (indexPath.row == 4) {
//		SWLostSettingViewController *lostSetViewController = [[SWLostSettingViewController alloc] init];
//		lostSetViewController.model = model;
//		[self.navigationController pushViewController:lostSetViewController animated:YES];
    }
    else if (indexPath.row == 5) {
        
    }
}

@end
