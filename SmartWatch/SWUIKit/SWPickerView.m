//
//  SWPickerView.m
//  SmartWatch
//
//  Created by zhuzhi on 14/12/13.
//
//

#import "SWPickerView.h"

@interface SWPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView *_pickerView;
    UINavigationBar *_navigationBar;
    UINavigationItem *_navItem;
}

@end

@implementation SWPickerView

- (id)init{
    self = [super initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 260)];
    if (self) {
        [self setBlurTintColor:[UIColor whiteColor]];
        _navigationBar = [[UINavigationBar alloc] initForAutoLayout];
        _navigationBar.barStyle = UIBarStyleDefault;
        UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消", @"Cancel Button") style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClick)];
        UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"保存", @"picker Birthday Save Button") style:UIBarButtonItemStyleDone target:self action:@selector(saveBtnClick)];
        _navItem = [[UINavigationItem alloc] init];
        _navItem.leftBarButtonItem = cancelBtn;
        _navItem.rightBarButtonItem = saveBtn;
        [_navigationBar pushNavigationItem:_navItem animated:NO];
        [self addSubview:_navigationBar];
        [_navigationBar autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self];
        [_navigationBar autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self];
        [_navigationBar autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self];
        [_navigationBar autoSetDimension:ALDimensionHeight toSize:44.0f];
        
        _pickerView = [[UIPickerView alloc] initForAutoLayout];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        [self addSubview:_pickerView];
        [_pickerView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(44.0f, 0.0f, 0.0f, 0.0f)];
        
        self.hidden = YES;
    }
    
    return self;
}

- (void)showFromView:(UIView *)view {
    if (!self.hidden) {
        return;
    }
    
    if (!self.superview) {
        [view addSubview:self];
    }
    
    self.top = view.height;
    self.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.top = view.height - self.height;
    } completion:^(BOOL finished) {
    }];
}

- (void)hideFromView:(UIView *)view {
    if (self.hidden) {
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.top = view.height;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

- (void)cancelBtnClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerViewDidCancel:)]) {
        [self.delegate pickerViewDidCancel:self];
    }
}

- (void)saveBtnClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:didFinished:)]) {
        [self.delegate pickerView:self didFinished:[_dataSource objectAtIndex:[_pickerView selectedRowInComponent:0]]];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _dataSource.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title = [_dataSource objectAtIndex:row];
    if (_titleSuffix.length > 0) {
        return [NSString stringWithFormat:@"%@%@", title, _titleSuffix];
    }
    
    return title;
    
}

@end
