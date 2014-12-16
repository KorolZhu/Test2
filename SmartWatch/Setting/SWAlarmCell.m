//
//  SWAlarmCell.m
//  SmartWatch
//
//  Created by zhuzhi on 14/12/16.
//
//

#import "SWAlarmCell.h"
#import "SWAlarmInfo.h"

@interface SWAlarmCell ()
{
    UILabel *timeLabel;
    UILabel *repeatLabel;
}

@end

@implementation SWAlarmCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        timeLabel = [[UILabel alloc] init];
        timeLabel.textAlignment = NSTextAlignmentLeft;
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.font = [UIFont systemFontOfSize:17.0f];
        timeLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:timeLabel];
        
        repeatLabel = [[UILabel alloc] init];
        repeatLabel.textAlignment = NSTextAlignmentLeft;
        repeatLabel.backgroundColor = [UIColor clearColor];
        repeatLabel.font = [UIFont systemFontOfSize:9.0f];
        repeatLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:repeatLabel];
        
        _stateSwitch = [[UISwitch alloc] init];
        
    }
    
    return self;
}

- (void)setAlarmInfo:(SWAlarmInfo *)alarmInfo {
    _alarmInfo = alarmInfo;
    timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", _alarmInfo.hour, alarmInfo.minute];
    
    NSMutableString *repeatString = [NSMutableString string];
    if ((alarmInfo.repeat & 16) > 0) {
        [repeatString appendString:@"星期一"];
    }
    
    if ((alarmInfo.repeat & 8) > 0) {
        [repeatString appendString:@"星期二"];
    }
    
    if ((alarmInfo.repeat & 4) > 0) {
        [repeatString appendString:@"星期三"];
    }
    
    if ((alarmInfo.repeat & 2) > 0) {
        [repeatString appendString:@"星期四"];
    }
    
    if ((alarmInfo.repeat & 1) > 0) {
        [repeatString appendString:@"星期五"];
    }
    
    if ((alarmInfo.repeat & 64) > 0) {
        [repeatString appendString:@"星期六"];
    }
    
    if ((alarmInfo.repeat & 32) > 0) {
        [repeatString appendString:@"星期日"];
    }
    
    if (repeatString.length > 0) {
        repeatLabel.text = repeatString;
    }
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [timeLabel sizeToFit];
    [repeatLabel sizeToFit];
    
    CGFloat totalHeight = timeLabel.height + repeatLabel.height + 3.0f;
    timeLabel.top = (self.height - totalHeight) / 2.0f;
    timeLabel.left = 18.0f;
    repeatLabel.top = timeLabel.bottom + 3.0f;
    repeatLabel.left = 18.0f;
}

@end
