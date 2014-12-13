//
//  SWDaylightSetViewController.m
//  SmartWatch
//
//  Created by zhuzhi on 14/12/13.
//
//

#import "SWDaylightSetViewController.h"
#import "SWPickerView2.h"
#import "SWSettingInfo.h"
#import "SWSettingModel.h"

@interface SWDaylightSetViewController ()<UITableViewDataSource,UITableViewDelegate,SWPickerView2Delegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) SWPickerView2 *pickerView;

@end

@implementation SWDaylightSetViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    UIBarButtonItem *backButton = [UIBarButtonItem backItemWithTarget:self action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"4背景-ios_01"] forBarMetrics:UIBarMetricsDefault];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"4背景-ios_02"]];
    
    self.navigationItem.title = @"白天时间";
    
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

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
        
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:16.0f];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"时间";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d:00 ~ %d:00", [[SWSettingInfo shareInstance] startHour], [[SWSettingInfo shareInstance] endHour]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!_pickerView) {
        self.pickerView = [[SWPickerView2 alloc] init];
        self.pickerView.delegate = self;
        self.pickerView.hidden = YES;
        
        NSMutableArray *datasource1 = [[NSMutableArray alloc] init];
        for (int i = 0; i < 24; i++) {
            [datasource1 addObject:@(i).stringValue];
        }
        
        NSMutableArray *datasource2 = [[NSMutableArray alloc] init];
        for (int i = 0; i < 24; i++) {
            [datasource2 addObject:@(i).stringValue];
        }
        
        self.pickerView.dataSource1 = datasource1;
        self.pickerView.titleSuffix1 = @"时";
        self.pickerView.dataSource2 = datasource2;
        self.pickerView.titleSuffix2 = @"时";
        
    }
    
    self.tableView.userInteractionEnabled = NO;
    [self.pickerView showFromView:self.view];
}

#pragma mark - SWPickerView2Delegate

- (void)pickerView2:(SWPickerView2 *)pickerView didFinishedWithValue1:(NSString *)value1 value2:(NSString *)value2 {
    [self.model saveDaylightTimeWithStartHour:value1.integerValue endHour:value2.integerValue];
    [self.tableView reloadData];
    [pickerView hideFromView:self.view];
    self.tableView.userInteractionEnabled = YES;
}

- (void)pickerView2DidCancel:(SWPickerView2 *)pickerView {
    [pickerView hideFromView:self.view];
    self.tableView.userInteractionEnabled = YES;
}

@end
