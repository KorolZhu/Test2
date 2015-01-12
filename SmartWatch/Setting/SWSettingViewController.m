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
    }
    
    return self;
}

- (void)viewDidLoad {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"4背景-ios_01"] forBarMetrics:UIBarMetricsDefault];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"4背景-ios_02"]];
    
    self.navigationItem.title = @"设置";
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"4设置_08"];
        cell.textLabel.text = @"我的设备";
    } else if (indexPath.row == 1) {
        cell.imageView.image = [UIImage imageNamed:@"4设置_25"];
        cell.textLabel.text = @"智能闹钟";
    } else if (indexPath.row == 2) {
        cell.imageView.image = [UIImage imageNamed:@"4设置_30"];
        cell.textLabel.text = @"白天时间设置";
    } else if (indexPath.row == 3) {
        cell.imageView.image = [UIImage imageNamed:@"4设置_32"];
        cell.textLabel.text = @"目标设置";
    }
    else if (indexPath.row == 4) {
        cell.imageView.image = [UIImage imageNamed:@"4设置_37"];
        cell.textLabel.text = @"防丢设置";
    }
    else if (indexPath.row == 5) {
        cell.imageView.image = [UIImage imageNamed:@"4设置_41"];
        cell.textLabel.text = @"关于我们";
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
		SWLostSettingViewController *lostSetViewController = [[SWLostSettingViewController alloc] init];
		lostSetViewController.model = model;
		[self.navigationController pushViewController:lostSetViewController animated:YES];
    }
    else if (indexPath.row == 5) {
        
    }
}

@end
