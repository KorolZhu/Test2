//
//  SWSettingViewController.m
//  SmartWatch
//
//  Created by zhuzhi on 14/11/16.
//
//

#import "SWSettingViewController.h"

@interface SWSettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation SWSettingViewController

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
    } else if (indexPath.row == 4) {
        cell.imageView.image = [UIImage imageNamed:@"4设置_37"];
        cell.textLabel.text = @"遥控拍照";
    } else if (indexPath.row == 5) {
        cell.imageView.image = [UIImage imageNamed:@"4设置_41"];
        cell.textLabel.text = @"关于我们";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0f;
}


@end
