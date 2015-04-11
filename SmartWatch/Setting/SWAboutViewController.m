//
//  SWAboutViewController.m
//  SmartWatch
//
//  Created by zhuzhi on 15/4/8.
//
//

#import "SWAboutViewController.h"

@interface SWAboutViewController ()

@property (nonatomic,strong) UIScrollView *scrollView;

@end

@implementation SWAboutViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    UIBarButtonItem *backButton = [UIBarButtonItem backItemWithTarget:self action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"4背景-ios_01"] forBarMetrics:UIBarMetricsDefault];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"4背景-ios_02"]];
    
    self.navigationItem.title = NSLocalizedString(@"About us", nil);
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_scrollView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"setting-about@2x"]];
    imageView.frame = CGRectMake((IPHONE_WIDTH - 200.0f) / 2.0f, 15.0f, 200.0f, 200.0f);
    [_scrollView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30.0f, imageView.bottom + 15.0f, IPHONE_WIDTH - 60.0f, 0.0f)];
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:17.0f];
    label.text = NSLocalizedString(@"Tinsee Smart Watch, World's first wireless power charge, finest stainless steel case , traditional crafts personalized fashion elements intelligent wrist watch, is recognized by media as the most pleasant to wear smart watch", nil);
    [_scrollView addSubview:label];
    
    CGSize size = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(label.width, 1000.0f)];
    label.height = size.height;
    
    _scrollView.contentSize = CGSizeMake(IPHONE_WIDTH, label.bottom);
    
    
//    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
//    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    _tableView.delegate = self;
//    _tableView.dataSource = self;
//    _tableView.backgroundColor = [UIColor clearColor];
//    _tableView.backgroundView = nil;
//    [self.view addSubview:_tableView];
    
//    UIView *footView = [[UIView alloc] init];
//    footView.backgroundColor = [UIColor clearColor];
//    self.tableView.tableFooterView = footView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
