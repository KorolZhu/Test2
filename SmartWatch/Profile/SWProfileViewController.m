//
//  SWProfileViewController.m
//  SmartWatch
//
//  Created by zhuzhi on 14/12/3.
//
//

#import "SWProfileViewController.h"
#import "SWHeadImageCell.h"
#import "SWProfileInfoCell.h"

@implementation SWProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人资料";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"3背景-ios_01"] forBarMetrics:UIBarMetricsDefault];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"3背景-ios_02"]];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 17.0f);
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * headImageCellIdentifier = @"headImageCellIdentifier";
    static NSString * otherCellIdentifier = @"otherCellIdentifier";
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:headImageCellIdentifier];
        if (!cell) {
            cell = [[SWHeadImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headImageCellIdentifier];
        }
        return cell;
    }
    
    SWProfileInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:otherCellIdentifier];
    if (!cell) {
        cell = [[SWProfileInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:otherCellIdentifier];
    }
    
    if (indexPath.row == 1) {
        cell.title = @"性别";
        cell.value = @"男";
    } else if (indexPath.row == 2) {
        cell.title = @"生日";
        cell.value = @"1988/09/17";
    } else if (indexPath.row == 3) {
        cell.title = @"身高";
        cell.value = @"176cm";
    } else if (indexPath.row == 4) {
        cell.title = @"体重";
        cell.value = @"50kg";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 168.0f;
    }
    
    return 45.0f;
}

@end
