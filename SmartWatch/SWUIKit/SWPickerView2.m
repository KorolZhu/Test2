//
//  SWPickerView2.m
//  SmartWatch
//
//  Created by zhuzhi on 14/12/13.
//
//

#import "SWPickerView2.h"

@interface SWPickerView2 ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView *_pickerView;
    UINavigationBar *_navigationBar;
    UINavigationItem *_navItem;
}

@end

@implementation SWPickerView2

- (id)init{
    self = [super initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 260)];
    if (self) {
        [self setBlurTintColor:[UIColor whiteColor]];
        _navigationBar = [[UINavigationBar alloc] initForAutoLayout];
        _navigationBar.barStyle = UIBarStyleDefault;
		[_navigationBar setTintColor:[UIColor blackColor]];
        UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"Cancel Button") style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClick)];
        UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", @"picker Birthday Save Button") style:UIBarButtonItemStyleDone target:self action:@selector(saveBtnClick)];
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

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated {
	[_pickerView selectRow:row inComponent:component animated:animated];
}

- (void)cancelBtnClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView2DidCancel:)]) {
        [self.delegate pickerView2DidCancel:self];
    }
}

- (void)saveBtnClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView2:didFinishedWithValue1:value2:)]) {
        [self.delegate pickerView2:self didFinishedWithValue1:[_dataSource1 objectAtIndex:[_pickerView selectedRowInComponent:0]] value2:[_dataSource2 objectAtIndex:[_pickerView selectedRowInComponent:1]]];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return _dataSource1.count;
    }
    
    return _dataSource2.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title = nil;
    if (component == 0) {
        title = [_dataSource1 objectAtIndex:row];
        if (_titleSuffix1.length > 0) {
            title = [NSString stringWithFormat:@"%@%@", title, _titleSuffix1];
        }
        
    } else {
        title = [_dataSource2 objectAtIndex:row];
        if (_titleSuffix2.length > 0) {
            title = [NSString stringWithFormat:@"%@%@", title, _titleSuffix2];
        }
    }
    
    return title;
    
}

@end
