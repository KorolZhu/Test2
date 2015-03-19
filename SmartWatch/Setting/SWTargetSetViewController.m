//
//  SWTargetSetViewController.m
//  SmartWatch
//
//  Created by zhuzhi on 14/12/13.
//
//

#import "SWTargetSetViewController.h"
#import "SWPickerView.h"
#import "SWSettingModel.h"
#import "SWSettingInfo.h"
#import "SWUserInfo.h"

@interface SWTargetSetViewController ()<UITableViewDataSource,UITableViewDelegate,SWPickerViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) SWPickerView *stepPickerView;
@property (nonatomic,strong) SWPickerView *caloriePickerView;
@property (nonatomic,strong) SWPickerView *sleepPickerView;

@end

@implementation SWTargetSetViewController

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
    
    self.navigationItem.title = @"设置目标";
    
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
    return 3;
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
        cell.textLabel.text = @"步数";
		if ([[SWSettingInfo shareInstance] stepsTarget] > 0) {
			cell.detailTextLabel.text = @([[SWSettingInfo shareInstance] stepsTarget]).stringValue;
		} else {
			cell.detailTextLabel.text = @"";
		}
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"卡路里";
        float calorieTarget = [[SWSettingInfo shareInstance] calorieTarget];
        if (calorieTarget > 0) {
            cell.detailTextLabel.text = @([[SWSettingInfo shareInstance] calorieTarget]).stringValue;
        } else {
            cell.detailTextLabel.text = @"0";
        }
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"睡眠";
		if ([[SWSettingInfo shareInstance] sleepTarget] > 0) {
			cell.detailTextLabel.text = @([[SWSettingInfo shareInstance] sleepTarget]).stringValue;
		} else {
			cell.detailTextLabel.text = @"";
		}
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        if (!_stepPickerView) {
            _stepPickerView = [[SWPickerView alloc] init];
            _stepPickerView.hidden = YES;
            _stepPickerView.delegate = self;
            
            NSMutableArray *dataSource = [NSMutableArray array];
            for (NSInteger i = 500; i < 20001 ; i += 500) {
                [dataSource addObject:@(i).stringValue];
            }
            _stepPickerView.dataSource = dataSource;
            _stepPickerView.titleSuffix = @"步/天";
        }
        NSUInteger index = [_stepPickerView.dataSource indexOfObject:@([SWSettingInfo shareInstance].stepsTarget).stringValue];
        if (index != NSNotFound) {
            [_stepPickerView selectRow:index inComponent:0 animated:NO];
        } else {
            NSUInteger index2 = [_stepPickerView.dataSource indexOfObject:@(5000).stringValue];
            if (index2 != NSNotFound) {
                [_stepPickerView selectRow:index2 inComponent:0 animated:NO];
            }
        }
        
        [_stepPickerView showFromView:self.view];
    } else if (indexPath.row == 1) {
        if (!_caloriePickerView) {
            _caloriePickerView = [[SWPickerView alloc] init];
            _caloriePickerView.hidden = YES;
            _caloriePickerView.delegate = self;
            
            NSMutableArray *dataSource = [NSMutableArray array];
            for (NSInteger i = 10; i < 10000 ; i++) {
                [dataSource addObject:@(i).stringValue];
            }
            _caloriePickerView.dataSource = dataSource;
            _caloriePickerView.titleSuffix = @"千卡";
        }
        
        NSUInteger index = [_caloriePickerView.dataSource indexOfObject:@([SWSettingInfo shareInstance].calorieTarget).stringValue];
        if (index != NSNotFound) {
            [_caloriePickerView selectRow:index inComponent:0 animated:NO];
        } else {
            NSUInteger index2 = [_caloriePickerView.dataSource indexOfObject:@(100).stringValue];
            if (index2 != NSNotFound) {
                [_caloriePickerView selectRow:index2 inComponent:0 animated:NO];
            }
        }
        
        [_caloriePickerView showFromView:self.view];
    } else if (indexPath.row == 2) {
        if (!_sleepPickerView) {
            _sleepPickerView = [[SWPickerView alloc] init];
            _sleepPickerView.hidden = YES;
            _sleepPickerView.delegate = self;
            
            NSMutableArray *dataSource = [NSMutableArray array];
            for (NSInteger i = 1; i < 24 ; i++) {
                [dataSource addObject:@(i).stringValue];
            }
            _sleepPickerView.dataSource = dataSource;
            _sleepPickerView.titleSuffix = @"小时";
        }
        
        NSUInteger index = [_sleepPickerView.dataSource indexOfObject:@([SWSettingInfo shareInstance].sleepTarget).stringValue];
        if (index != NSNotFound) {
            [_sleepPickerView selectRow:index inComponent:0 animated:NO];
        } else {
            NSUInteger index2 = [_sleepPickerView.dataSource indexOfObject:@(8).stringValue];
            if (index2 != NSNotFound) {
                [_sleepPickerView selectRow:index2 inComponent:0 animated:NO];
            }
        }
        
        [_sleepPickerView showFromView:self.view];
    }
}

#pragma mark - SWPickerViewDelegate



- (void)pickerView:(SWPickerView *)pickerView didFinished:(NSString *)value {
    if (pickerView == _stepPickerView) {
        if ([[SWBLECenter shareInstance] setStepTargets:value.integerValue]) {
            [_model saveStepsTarget:value.integerValue];
            [self.tableView reloadData];
        }
    } else if (pickerView == _caloriePickerView) {
        NSInteger height = [[SWUserInfo shareInstance] height];
        if (height <= 0) {
            height = [[SWUserInfo shareInstance] defaultHeight];
        }
        
        NSInteger weight = [[SWUserInfo shareInstance] weight];
        if (weight <= 0) {
            weight = [[SWUserInfo shareInstance] defaultWeight];
        }
        
        NSInteger steps = (value.integerValue - 0.53 * height - 0.58 * weight + 135) * 25;
        if ([[SWBLECenter shareInstance] setStepTargets:steps]) {
            [_model saveStepsTarget:steps];
            [self.tableView reloadData];
        }
    } if (pickerView == _sleepPickerView) {
        [_model saveSleepTarget:value.integerValue];
        [self.tableView reloadData];
    }
    
    
    [pickerView hideFromView:self.view];
}

- (void)pickerViewDidCancel:(SWPickerView *)pickerView {
    [pickerView hideFromView:self.view];
}

@end
