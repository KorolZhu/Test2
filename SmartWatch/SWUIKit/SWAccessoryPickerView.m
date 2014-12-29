//
//  SWAccessoryPickerView.m
//  SmartWatch
//
//  Created by zhuzhi on 14/12/29.
//
//

#import "SWAccessoryPickerView.h"

@interface SWAccessoryPickerView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *cancelButton;
@property (nonatomic,strong) UIView *backAlphaView;

@end

@implementation SWAccessoryPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.75f];
        self.layer.cornerRadius = 8.0f;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, self.width - 40.0f, 44.0f)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:16.0f];
        _titleLabel.textColor = [UIColor blackColor];
        [self addSubview:_titleLabel];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, _titleLabel.bottom, self.width, self.height - 88.0f) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.backgroundView = nil;
        [self addSubview:_tableView];
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _cancelButton.frame = CGRectMake(0.0f, _tableView.bottom, self.width, 44.0f);
        [_cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
    }
    
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    [self.tableView reloadData];
}

- (void)cancelButtonClick {
    [self.delegate accessoryPickerViewDidCancel:self];
}

- (BOOL)isVisible {
    return self.superview != nil;
}

- (void)show {
    if (self.superview) {
        return;
    }
    
    if (!_backAlphaView) {
        _backAlphaView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    
    _backAlphaView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
    [[[UIApplication sharedApplication] keyWindow] addSubview:_backAlphaView];
    [UIView animateWithDuration:0.2f animations:^{
        _backAlphaView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
    } completion:^(BOOL finished) {
        
    }];
    
    self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        
    }];
}

- (void)hide {
    if (!self.superview) {
        return;
    }
    
    [_backAlphaView removeFromSuperview];
    [self removeFromSuperview];
//    [UIView animateWithDuration:0.2f animations:^{
//        _backAlphaView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
//    } completion:^(BOOL finished) {
//        [_backAlphaView removeFromSuperview];
//    }];
//    
//    self.transform = CGAffineTransformIdentity;
//    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
//    } completion:^(BOOL finished){
//        [self removeFromSuperview];
//    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"headImageCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    CBPeripheral *peripheral = [_dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = peripheral.name;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 42.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CBPeripheral *peripheral = [_dataSource objectAtIndex:indexPath.row];
    [self.delegate accessoryPickerView:self didSelectPeripheral:peripheral];
}

@end
