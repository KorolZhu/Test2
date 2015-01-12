//
//  HTDatePicker.m
//  HelloTalk_Binary
//
//  Created by zhuzhi on 13-7-19.
//  Copyright (c) 2013年 HT. All rights reserved.
//

#import "HTDatePicker.h"

@interface HTDatePicker ()
{
    UIDatePicker *_datePick;
    UINavigationBar *_datePickBar;
    UINavigationItem *_navItem;
}

@end

@implementation HTDatePicker

- (id)initWithFrame:(CGRect)frame{
    self = [self initWithFrame:frame date:nil];
    return self;
}

- (id)initWithFrame:(CGRect)frame date:(NSDate *)date
{
    self = [super initWithFrame:frame];
    if (self) {
        //set datePickBar
        [self setBlurTintColor:[UIColor whiteColor]];
        
        _datePickBar = [[UINavigationBar alloc] initForAutoLayout];
        _datePickBar.barStyle = UIBarStyleDefault ;
        
//        UIImage *navBtnBg = [[UIImage imageNamed:@"nav_btn"] stretchableImageWithLeftCapWidth:5 topCapHeight:30];
//        UIImage *navBtnBgPressed = [[UIImage imageNamed:@"nav_btn_pressed"] stretchableImageWithLeftCapWidth:5 topCapHeight:30];
        
        UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"Cancel Button") style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClick)];
//        [cancelBtn setBackgroundImage:navBtnBg forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//        [cancelBtn setBackgroundImage:navBtnBgPressed forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"OK", @"picker Birthday Save Button") style:UIBarButtonItemStyleDone target:self action:@selector(saveBtnClick)];
        _navItem = [[UINavigationItem alloc] init];
//        [saveBtn setBackgroundImage:navBtnBg forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//        [saveBtn setBackgroundImage:navBtnBgPressed forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        _navItem.leftBarButtonItem = cancelBtn;
        _navItem.rightBarButtonItem = saveBtn;
        
        //UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [_datePickBar pushNavigationItem:_navItem animated:NO];
        
        //_datePickBar.items = @[cancelBtn,titleItem,saveBtn];
        [self addSubview:_datePickBar];
        
        [_datePickBar autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self];
        [_datePickBar autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self];
        [_datePickBar autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self];
        [_datePickBar autoSetDimension:ALDimensionHeight toSize:44.0f];
        
        
        //set datePick
        _datePick = [[UIDatePicker alloc] initForAutoLayout];
        [_datePick setDatePickerMode:UIDatePickerModeDate];
        [self addSubview:_datePick];
        
        [_datePick autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(44.0f, 0.0f, 0.0f, 0.0f)];
    }
    return self;
}

- (void)setDate:(NSDate *)date animated:(BOOL)animated {
    [_datePick setDate:date animated:animated];
}

- (void)cancelBtnClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(datePickerCancel:)]) {
        [self.delegate datePickerCancel:self];
    }
}

- (void)saveBtnClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(datePickerFinished:date:)]) {
        [self.delegate datePickerFinished:self date:_datePick.date];
    }
}

@end
