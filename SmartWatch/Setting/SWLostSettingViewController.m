//
//  SWLostSettingViewController.m
//  SmartWatch
//
//  Created by zhuzhi on 15/1/12.
//
//

#import "SWLostSettingViewController.h"
#import "SWPickerView.h"
#import "SWSettingModel.h"
#import "SWSettingInfo.h"

@interface SWLostSettingViewController ()<UITableViewDataSource,UITableViewDelegate,SWPickerViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) SWPickerView *stepPickerView;

@end

@implementation SWLostSettingViewController

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
	
	self.navigationItem.title = @"防丢设置";
	
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
		cell.textLabel.text = @"米";
		cell.detailTextLabel.text = @([[SWSettingInfo shareInstance] lostMeters]).stringValue;
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
			for (NSInteger i = 5; i <= 30 ; i ++) {
				[dataSource addObject:@(i).stringValue];
			}
			_stepPickerView.dataSource = dataSource;
			_stepPickerView.titleSuffix = @"米";
		}
		[_stepPickerView showFromView:self.view];
	}
}

#pragma mark - SWPickerViewDelegate

- (void)pickerView:(SWPickerView *)pickerView didFinished:(NSString *)value {
	if (pickerView == _stepPickerView) {
//		if ([[SWBLECenter shareInstance] setLostMeters:value.integerValue]) {
//			[_model saveLostMeter:value.integerValue];
//			[self.tableView reloadData];
//		}
	}
	
	
	[pickerView hideFromView:self.view];
}

- (void)pickerViewDidCancel:(SWPickerView *)pickerView {
	[pickerView hideFromView:self.view];
}

@end
