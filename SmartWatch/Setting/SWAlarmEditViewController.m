//
//  SWAlarmEditViewController.m
//  SmartWatch
//
//  Created by zhuzhi on 14/12/16.
//
//

#import "SWAlarmEditViewController.h"
#import "SWAlarmInfo.h"
#import "SWSettingInfo.h"
#import "SWSettingModel.h"

static NSString *alarmEditCellIdentifier = @"alarmEditCellIdentifier";

@interface SWAlarmEditViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIDatePicker *datePicker;
    NSArray *textArray;
    NSMutableArray *selectedArray;
}

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation SWAlarmEditViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"4背景-ios_01"] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"4背景-ios_02"]];
    self.navigationItem.title = NSLocalizedString(@"Edit", nil);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"OK", nil) style:UIBarButtonItemStylePlain target:self action:@selector(saveClick)];
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0f, 0.0f, IPHONE_WIDTH, 216.0f)];
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.datePickerMode = UIDatePickerModeTime;
    [self.view addSubview:datePicker];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, datePicker.bottom, IPHONE_WIDTH, IPHONE_HEIGHT_WITHOUTTOPBAR - datePicker.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:alarmEditCellIdentifier];
    [self.view addSubview:_tableView];
    
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footView;
    
    textArray = @[NSLocalizedString(@"Monday", nil),NSLocalizedString(@"Tuesday", nil),NSLocalizedString(@"Wednesday", nil),NSLocalizedString(@"Thursday", nil),NSLocalizedString(@"Friday", nil),NSLocalizedString(@"Saturday", nil),NSLocalizedString(@"Sunday", nil)];
    selectedArray = [NSMutableArray array];
}

- (void)cancelClick {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)saveClick {
    NSInteger repeat = 0;
    NSArray *arr = @[@1,@2,@4,@8,@16,@32,@64];
    for (NSIndexPath *indexPath in selectedArray) {
        repeat |= [[arr objectAtIndex:indexPath.row] integerValue];
    }
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit| NSMinuteCalendarUnit;
    static NSCalendar *calendar;
    if (!calendar) {
        calendar = [NSCalendar currentCalendar];
    }
    
    NSDateComponents *comps = [calendar components:unitFlags fromDate:[datePicker date]];
    NSInteger hour = [comps hour];
    NSInteger minute = [comps minute];
    
    if (!self.alarmInfo) {
        SWAlarmInfo *alarmInfo = [[SWAlarmInfo alloc] init];
        alarmInfo.hour = hour;
        alarmInfo.minute = minute;
        alarmInfo.state = 1;
        alarmInfo.repeat = repeat;
        if ([[SWBLECenter shareInstance] setAlarmWithAlarmInfo:alarmInfo]) {
            [self.model addNewAlarm:alarmInfo];
            [self dismissViewControllerAnimated:YES completion:NULL];
        }
    } else {
        self.alarmInfo.hour = hour;
        self.alarmInfo.minute = minute;
        self.alarmInfo.repeat = repeat;
        if ([[SWBLECenter shareInstance] setAlarmWithAlarmInfo:self.alarmInfo]) {
            [self.model updateAlarmInfo];
            [self dismissViewControllerAnimated:YES completion:NULL];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return textArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:alarmEditCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = [textArray objectAtIndex:indexPath.row];
    if (![selectedArray containsObject:indexPath]) {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"4设置_51"]];
    } else {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"4设置_55"]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([selectedArray containsObject:indexPath]) {
        [selectedArray removeObject:indexPath];
    } else {
        [selectedArray addObject:indexPath];
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
