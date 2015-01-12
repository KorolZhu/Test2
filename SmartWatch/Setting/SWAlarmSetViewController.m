//
//  SWAlarmSetViewController.m
//  SmartWatch
//
//  Created by zhuzhi on 14/12/13.
//
//

#import "SWAlarmSetViewController.h"
#import "SWAlarmCell.h"
#import "SWSettingInfo.h"
#import "SWAlarmEditViewController.h"
#import "SWSettingModel.h"
#import "SWAlarmInfo.h"

static NSString *alarmCellIdentifier = @"alarmCellIdentifier";

@interface SWAlarmSetViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIBarButtonItem *rightBarButtonItem;
    UIButton *addButton;
    UILabel *addLabel;
}

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation SWAlarmSetViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (void)dealloc {
    [[SWSettingInfo shareInstance] removeObserver:self forKeyPath:@"alarmArray"];
}

- (void)viewDidLoad {
    UIBarButtonItem *backButton = [UIBarButtonItem backItemWithTarget:self action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = backButton;
    rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editClick)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"4背景-ios_01"] forBarMetrics:UIBarMetricsDefault];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"4背景-ios_02"]];
    
    self.navigationItem.title = @"智能闹钟";
    
    addLabel = [[UILabel alloc] init];
    addLabel.textAlignment = NSTextAlignmentCenter;
    addLabel.backgroundColor = [UIColor clearColor];
    addLabel.font = [UIFont systemFontOfSize:12.0f];
    addLabel.textColor = [UIColor whiteColor];
    addLabel.text = @"添加闹钟";
    [self.view addSubview:addLabel];
    [addLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:12.0f];
    [addLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [addButton setBackgroundImage:[UIImage imageNamed:@"4设置_21"] forState:UIControlStateNormal];
    [self.view addSubview:addButton];
    [addButton autoSetDimensionsToSize:CGSizeMake(36.0f, 36.0f)];
    [addButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:addLabel withOffset:-5.0f];
    [addButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.allowsSelectionDuringEditing = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    [_tableView registerClass:[SWAlarmCell class] forCellReuseIdentifier:alarmCellIdentifier];
    [self.view addSubview:_tableView];
    [_tableView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [_tableView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_tableView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_tableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:addButton withOffset:-12.0f];
    
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footView;
    
    [[SWSettingInfo shareInstance] addObserver:self forKeyPath:@"alarmArray" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.tableView.editing) {
        [self editClick];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqual:@"alarmArray"]) {
        if ([NSThread isMainThread]) {
            [self.tableView reloadData];
        } else {
            [[GCDQueue mainQueue] queueBlock:^{
                [self.tableView reloadData];
            }];
        }
    }
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editClick {
    [self.tableView setEditing:!self.tableView.editing animated:YES];

    if (self.tableView.isEditing) {
        rightBarButtonItem.title = @"取消";
    } else {
        rightBarButtonItem.title = @"编辑";
    }
}

- (void)addButtonClick {
    SWAlarmEditViewController *viewController = [[SWAlarmEditViewController alloc]init];
    viewController.model = self.model;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:nav animated:YES completion:NULL];
}

- (void)switchChanged:(UISwitch *)stateSwitch event:(UIEvent *)event {
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    SWAlarmInfo *info = [[[SWSettingInfo shareInstance] alarmArray] objectAtIndex:indexPath.row];
    info.state = stateSwitch.on;
    [self.model updateAlarmInfo];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[SWSettingInfo shareInstance] alarmArray].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SWAlarmCell *cell = [tableView dequeueReusableCellWithIdentifier:alarmCellIdentifier forIndexPath:indexPath];
    [cell.stateSwitch addTarget:self action:@selector(switchChanged:event:) forControlEvents:UIControlEventValueChanged];
    cell.alarmInfo = [[SWSettingInfo shareInstance].alarmArray objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!tableView.isEditing) {
        return nil;
    }
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SWAlarmEditViewController *viewController = [[SWAlarmEditViewController alloc]init];
    viewController.model = self.model;
    viewController.alarmInfo = [[[SWSettingInfo shareInstance] alarmArray] objectAtIndex:indexPath.row];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:nav animated:YES completion:NULL];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        SWAlarmInfo *info = [[[SWSettingInfo shareInstance] alarmArray] objectAtIndex:indexPath.row];
        [self.model removeAlarm:info];
    }
}

@end
