//
//  SWDeviceConnectdViewController.m
//  SmartWatch
//
//  Created by zhuzhi on 14/12/23.
//
//

#import "SWDeviceConnectdViewController.h"
#import "SWAccessoryPickerView.h"
#import "MBProgressHUD.h"

@interface SWDeviceConnectdViewController ()<UITableViewDataSource,UITableViewDelegate,SWAccessoryPickerViewDelegate>
{
    SWAccessoryPickerView *accessoryPickerView;
    MBProgressHUD *progressHUD;
    NSTimer *scanTimer;
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(synchronizeStart) name:kSWBLESynchronizeStartNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(synchronizeSucceed) name:kSWBLESynchronizeSuccessNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(synchronizeFailed) name:kSWBLESynchronizeFailNotification object:nil];
    }
    
    return self;
}

- (void)dealloc {
    [[SWBLECenter shareInstance] removeObserver:self forKeyPath:@"state" context:NULL];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"4背景-ios_01"] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"4背景-ios_02"]];
    self.navigationItem.title = @"Watch ID";
    
    UIBarButtonItem *backButton = [UIBarButtonItem backItemWithTarget:self action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Synchronous", nil) style:UIBarButtonItemStylePlain target:self action:@selector(synchronizeClick)];
    
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
    
    if (!progressHUD) {
        progressHUD = [[MBProgressHUD alloc] initWithView:self.tabBarController.view];
        [self.tabBarController.view addSubview:progressHUD];
    }
    
    [[SWBLECenter shareInstance] addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([scanTimer isValid]) {
        [scanTimer invalidate];
        scanTimer = nil;
    }
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    NSString *uuid = [[NSUserDefaults standardUserDefaults] stringForKey:LASTPERIPHERALUUID];
    NSString *name = [[NSUserDefaults standardUserDefaults] stringForKey:LASTPERIPHERALNAME];
    
    NSString *subuuid = @"";
    if (uuid.length >= 4) {
        subuuid = [uuid substringToIndex:4];
    }
    
    if (name.length == 0) {
        name = @"";
    }
    
    if ([name.lowercaseString isEqualToString:@"wristband"]) {
        name = @"Tinsee";
    }
    
    if (name.length > 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@%@", name, subuuid];
        cell.detailTextLabel.text = NSLocalizedString(@"UNLOCK", nil);
    } else {
        cell.textLabel.text = nil;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *name = [[NSUserDefaults standardUserDefaults] stringForKey:LASTPERIPHERALUUID];
    if (name.length > 0) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:LASTPERIPHERALUUID];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:LASTPERIPHERALNAME];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [tableView reloadData];
    }
}

#pragma mark - Ble

- (void)synchronizeClick {
    if ([SWBLECenter shareInstance].state == SWPeripheralStateDisconnected) {
        NSString *lastuuid = [[NSUserDefaults standardUserDefaults] stringForKey:LASTPERIPHERALUUID];
        if (lastuuid.length > 0) {
            progressHUD.detailsLabelText = NSLocalizedString(@"Scanning", nil);
            [progressHUD show:NO];
            
            scanTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(scanTimeout) userInfo:nil repeats:YES];
        } else {
            [self scanTimeout];
        }
        
        [[SWBLECenter shareInstance] scanBLEPeripherals];
        [[SWBLECenter shareInstance].ble addObserver:self forKeyPath:@"peripherals" options: NSKeyValueObservingOptionNew context:NULL];
    } else if ([SWBLECenter shareInstance].state == SWPeripheralStateConnected) {
        [[SWBLECenter shareInstance] synchronize];
    }
}

- (void)scanTimeout {
    [scanTimer invalidate];
    scanTimer = nil;
    
    [progressHUD hide:NO];
    
    if (!accessoryPickerView) {
        accessoryPickerView = [[SWAccessoryPickerView alloc] initWithFrame:CGRectMake(22.0f, 100.0f, IPHONE_WIDTH - 44.0f, IPHONE_HEIGHT - 200.0f)];
        accessoryPickerView.title = NSLocalizedString(@"Please Choose Watch", nil);
        accessoryPickerView.delegate = self;
    }
    
    [accessoryPickerView show];
    [accessoryPickerView setDataSource:[NSArray arrayWithArray:[SWBLECenter shareInstance].ble.peripherals]];
}

#pragma mark - Synchronize

- (void)synchronizeStart {
    if ([NSThread isMainThread]) {
        if (progressHUD.hidden || progressHUD.alpha == 0.0f) {
            [progressHUD show:NO];
        }
        progressHUD.detailsLabelText = NSLocalizedString(@"Synchronous...", nil);
    } else {
        if (progressHUD.hidden || progressHUD.alpha == 0.0f) {
            [progressHUD show:NO];
        }
        [[GCDQueue mainQueue] queueBlock:^{
            progressHUD.detailsLabelText = NSLocalizedString(@"Synchronous...", nil);
        }];
    }
}

- (void)synchronizeSucceed {
    if ([NSThread isMainThread]) {
        [progressHUD hide:YES];
    } else {
        [[GCDQueue mainQueue] queueBlock:^{
            [progressHUD hide:YES];
        }];
    }
    
}

- (void)synchronizeFailed {
    if ([NSThread isMainThread]) {
        [progressHUD hide:YES];
    } else {
        [[GCDQueue mainQueue] queueBlock:^{
            [progressHUD hide:YES];
        }];
    }
}

#pragma mark - AccessoryPickerView

- (void)accessoryPickerView:(SWAccessoryPickerView *)pickerView didSelectPeripheral:(CBPeripheral *)peripheral {
    [[SWBLECenter shareInstance].ble removeObserver:self forKeyPath:@"peripherals"];
    [[SWBLECenter shareInstance] stopScanBLEPeripherals];
    if (accessoryPickerView.isVisible) {
        [accessoryPickerView hide];
    }
    [[SWBLECenter shareInstance] connectPeripheral:peripheral];
}

- (void)accessoryPickerViewDidCancel:(SWAccessoryPickerView *)pickerView {
    [[SWBLECenter shareInstance].ble removeObserver:self forKeyPath:@"peripherals"];
    [[SWBLECenter shareInstance] stopScanBLEPeripherals];
    if (accessoryPickerView.isVisible) {
        [accessoryPickerView hide];
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"state"]) {
        NSInteger state = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        switch (state) {
            case SWPeripheralStateDisconnected: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [progressHUD hide:NO];
                });
            }
                break;
            case SWPeripheralStateConnected: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
                break;
            default: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (state == SWPeripheralStateConnecting) {
                        if (progressHUD.hidden || progressHUD.alpha == 0.0f) {
                            [progressHUD show:NO];
                        }
                        progressHUD.detailsLabelText = NSLocalizedString(@"Connecting...", nil);
                    }
                });
                
            }
                break;
        }
    } else if ([keyPath isEqualToString:@"peripherals"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (accessoryPickerView.isVisible) {
                [accessoryPickerView setDataSource:[NSArray arrayWithArray:[SWBLECenter shareInstance].ble.peripherals]];
            } else {
                NSString *lastuuid = [[NSUserDefaults standardUserDefaults] stringForKey:LASTPERIPHERALUUID];
                if (lastuuid.length > 0) {
                    NSArray *array = [NSArray arrayWithArray:[SWBLECenter shareInstance].ble.peripherals];
                    for (CBPeripheral *peripheral in array) {
                        if ([peripheral.identifier.UUIDString isEqualToString:lastuuid]) {
                            if ([scanTimer isValid] && ![accessoryPickerView isVisible]) {
                                [self accessoryPickerView:nil didSelectPeripheral:peripheral];
                                [scanTimer invalidate];
                                scanTimer = nil;
                            }
                            
                            break;
                        }
                    }
                }
            }
            
        });
    }
}

@end
