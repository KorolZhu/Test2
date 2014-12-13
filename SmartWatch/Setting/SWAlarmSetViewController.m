//
//  SWAlarmSetViewController.m
//  SmartWatch
//
//  Created by zhuzhi on 14/12/13.
//
//

#import "SWAlarmSetViewController.h"

@interface SWAlarmSetViewController ()<UITableViewDataSource,UITableViewDelegate>
{
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

- (void)viewDidLoad {
    UIBarButtonItem *backButton = [UIBarButtonItem backItemWithTarget:self action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = backButton;
    
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
    [addButton setBackgroundImage:[UIImage imageNamed:@"4设置_21"] forState:UIControlStateNormal];
    [self.view addSubview:addButton];
    [addButton autoSetDimensionsToSize:CGSizeMake(36.0f, 36.0f)];
    [addButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:addLabel withOffset:-5.0f];
    [addButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    [self.view addSubview:_tableView];
    [_tableView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [_tableView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_tableView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_tableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:addButton withOffset:-12.0f];
    
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footView;
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
}

@end
