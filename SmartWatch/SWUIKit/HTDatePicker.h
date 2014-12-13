//
//  HTDatePicker.h
//  HelloTalk_Binary
//
//  Created by zhuzhi on 13-7-19.
//  Copyright (c) 2013年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMBlurView.h"

@protocol HTDatePickerDelegate <NSObject>

@optional
- (void)datePickerCancel;
- (void)datePickerFinished:(NSDate *)date;

@end

@interface HTDatePicker : AMBlurView

@property(nonatomic,weak)id<HTDatePickerDelegate>delegate;

//@property (nonatomic,strong) NSString *title;
- (id)initWithFrame:(CGRect)frame date:(NSDate *)date;

@end
