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
    UILabel *dateLabel;
}

@end

@implementation SWExerciseRecordsTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _lastButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lastButton setImage:[UIImage imageNamed:@"日期左选择_正常"] forState:UIControlStateNormal];
        [_lastButton setImage:[UIImage imageNamed:@"日期左选择_禁用"] forState:UIControlStateDisabled];
        _lastButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self addSubview:_lastButton];
        
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setImage:[UIImage imageNamed:@"日期右选择_正常"] forState:UIControlStateNormal];
        [_nextButton setImage:[UIImage imageNamed:@"日期右选择_禁用"] forState:UIControlStateDisabled];
        _nextButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self addSubview:_nextButton];
        
        dateLabel = [[UILabel alloc] init];
        dateLabel.textAlignment = NSTextAlignmentCenter;
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.font = [UIFont systemFontOfSize:17.0f];
        dateLabel.textColor = [UIColor whiteColor];
        [self addSubview:dateLabel];
        
        [dateLabel autoCenterInSuperview];
        [_lastButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:dateLabel];
        [_lastButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:dateLabel withOffset:-5.0f];
        [_lastButton autoSetDimension:ALDimensionWidth toSize:35.0f];
        [_nextButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:dateLabel];
        [_nextButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:dateLabel withOffset:5.0f];
        [_nextButton autoSetDimension:ALDimensionWidth toSize:35.0f];
        
    }
    
    return self;
}

- (void)setDate:(NSDate *)date {
	_date = date;
	
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *currentLanguageCode = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([currentLanguageCode rangeOfString:@"zh"].location != NSNotFound) {
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    } else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    dateLabel.text = [dateFormatter stringFromDate:date];
    
    [self setNeedsLayout];
}

@end
