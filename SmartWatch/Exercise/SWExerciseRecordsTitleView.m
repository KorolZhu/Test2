//
//  SWExerciseRecordsTitleView.m
//  SmartWatch
//
//  Created by zhuzhi on 14/11/23.
//
//

#import "SWExerciseRecordsTitleView.h"

@interface SWExerciseRecordsTitleView ()
{
    UIButton *lastButton;
    UIButton *nextButton;
    UILabel *dateLabel;
}

@end

@implementation SWExerciseRecordsTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        lastButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [lastButton setImage:[UIImage imageNamed:@"日期左选择_正常"] forState:UIControlStateNormal];
        [lastButton setImage:[UIImage imageNamed:@"日期左选择_禁用"] forState:UIControlStateDisabled];
        [self addSubview:lastButton];
        
        nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [nextButton setImage:[UIImage imageNamed:@"日期右选择_正常"] forState:UIControlStateNormal];
        [nextButton setImage:[UIImage imageNamed:@"日期右选择_禁用"] forState:UIControlStateDisabled];
        [self addSubview:nextButton];
        
        dateLabel = [[UILabel alloc] init];
        dateLabel.textAlignment = NSTextAlignmentCenter;
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.font = [UIFont systemFontOfSize:17.0f];
        dateLabel.textColor = [UIColor whiteColor];
        [self addSubview:dateLabel];
        
        [dateLabel autoCenterInSuperview];
        [lastButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:dateLabel];
        [lastButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:dateLabel withOffset:-5.0f];
        [nextButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:dateLabel];
        [nextButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:dateLabel withOffset:5.0f];
        
    }
    
    return self;
}

- (void)setDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    dateLabel.text = [dateFormatter stringFromDate:[NSDate date]];
    
    [self setNeedsLayout];
}

@end
