//
//  SWDeviceConnectdViewController.m
//  SmartWatch
//
//  Created by zhuzhi on 14/12/23.
//
//

#import "SWDeviceConnectdViewController.h"
#import "SWAccessoryPickerView.h"

@interface SWDeviceConnectdViewController ()<UITableViewDataSource,UITableViewDelegate,SWAccessoryPickerViewDelegate>
{
    SWAccessoryPickerView *accessoryPickerView;
}

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation SWDeviceConnectdViewController

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
    [[SWBLECenter shareInstance] removeObserver:self forKeyPath:@"state"];
    [[SWBLECenter shareInstance].ble removeObserver:self forKeyPath:@"peripherals"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"4背景-ios_01"] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"4背景-ios_02"]];
    self.navigationItem.title = @"我的设备";
    
    UIBarButtonItem *backButton = [UIBarButtonItem backItemWithTarget:self action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"同步", nil) style:UIBarButtonItemStylePlain target:self action:@selector(synchronizeClick)];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.allowsSelectionDuringEditing = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    [self.view addSubview:_tableView];
    [_tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footView;
    
    [[SWBLECenter shareInstance] addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:NULL];
    [[SWBLECenter shareInstance].ble addObserver:self forKeyPath:@"peripherals" options: NSKeyValueObservingOptionNew context:NULL];
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)synchronizeClick {
    if ([SWBLECenter shareInstance].state == SWPeripheralStateDisconnected) {
        if (!accessoryPickerView) {
            accessoryPickerView = [[SWAccessoryPickerView alloc] initWithFrame:CGRectMake(22.0f, 100.0f, IPHONE_WIDTH - 44.0f, IPHONE_HEIGHT - 200.0f)];
            accessoryPickerView.title = NSLocalizedString(@"请选择蓝牙设备", nil);
            accessoryPickerView.delegate = self;
        }
        
        [accessoryPickerView show];
        [accessoryPickerView setDataSource:nil];
        [[SWBLECenter shareInstance] scanBLEPeripherals];
    } else if ([SWBLECenter shareInstance].state == SWPeripheralStateConnected) {
        [[SWBLECenter shareInstance] synchronize];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    NSString *name = [SWBLECenter shareInstance].activePeripheral.name;
    if (name.length > 0) {
        cell.textLabel.text = name;
    } else {
        cell.textLabel.text = nil;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - AccessoryPickerView

- (void)accessoryPickerView:(SWAccessoryPickerView *)pickerView didSelectPeripheral:(CBPeripheral *)peripheral {
    [[SWBLECenter shareInstance] stopScanBLEPeripherals];
    [accessoryPickerView hide];
    [[SWBLECenter shareInstance] connectPeripheral:peripheral];
}

- (void)accessoryPickerViewDidCancel:(SWAccessoryPickerView *)pickerView {
    [[SWBLECenter shareInstance] stopScanBLEPeripherals];
    [accessoryPickerView hide];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"state"]) {
        NSInteger state = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        switch (state) {
            case SWPeripheralStateDisconnected:
            case SWPeripheralStateConnected:
                [self.tableView reloadData];
                break;
            default:
                break;
        }
    } else if ([keyPath isEqualToString:@"peripherals"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (accessoryPickerView.isVisible) {
                accessoryPickerView.dataSource = [NSArray arrayWithArray:[SWBLECenter shareInstance].ble.peripherals];
            }
        });
    }
}

@end
