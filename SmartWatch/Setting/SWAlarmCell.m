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
    UIImageView *indicatorView;
}

@end

@implementation SWAlarmCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        timeLabel = [[UILabel alloc] init];
        timeLabel.textAlignment = NSTextAlignmentLeft;
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.font = [UIFont systemFontOfSize:22.0f];
        timeLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:timeLabel];
        
        repeatLabel = [[UILabel alloc] init];
        repeatLabel.textAlignment = NSTextAlignmentLeft;
        repeatLabel.backgroundColor = [UIColor clearColor];
        repeatLabel.font = [UIFont systemFontOfSize:13.0f];
        repeatLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:repeatLabel];
        
        _stateSwitch = [[UISwitch alloc] init];
        [self.contentView addSubview:_stateSwitch];
        
        indicatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"4设置_43"]];
        [self.contentView addSubview:indicatorView];
        indicatorView.hidden = YES;
        
    }
    
    return self;
}

- (void)setAlarmInfo:(SWAlarmInfo *)alarmInfo {
    _alarmInfo = alarmInfo;
    timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", _alarmInfo.hour, alarmInfo.minute];
    
    NSMutableString *repeatString = [NSMutableString string];
    if ((alarmInfo.repeat & 1) > 0) {
        [repeatString appendString:NSLocalizedString(@"Monday", nil)];
    }
    
    if ((alarmInfo.repeat & 2) > 0) {
        [repeatString appendString:NSLocalizedString(@"Tuesday", nil)];
    }
    
    if ((alarmInfo.repeat & 4) > 0) {
        [repeatString appendString:NSLocalizedString(@"Wednesday", nil)];
    }
    
    if ((alarmInfo.repeat & 8) > 0) {
        [repeatString appendString:NSLocalizedString(@"Thursday", nil)];
    }
    
    if ((alarmInfo.repeat & 16) > 0) {
        [repeatString appendString:NSLocalizedString(@"Friday", nil)];
    }
    
    if ((alarmInfo.repeat & 32) > 0) {
        [repeatString appendString:NSLocalizedString(@"Saturday", nil)];
    }
    
    if ((alarmInfo.repeat & 64) > 0) {
        [repeatString appendString:NSLocalizedString(@"Sunday", nil)];
    }
    
    if (repeatString.length > 0) {
        repeatLabel.text = repeatString;
    }
    
    _stateSwitch.on = alarmInfo.state;
    
    [self setNeedsLayout];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    _stateSwitch.hidden = editing;
    indicatorView.hidden = !editing;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [timeLabel sizeToFit];
    [repeatLabel sizeToFit];
    
    CGFloat totalHeight = timeLabel.height + repeatLabel.height + 3.0f;
    timeLabel.top = (self.height - totalHeight) / 2.0f;
    timeLabel.left = 18.0f;
    repeatLabel.top = timeLabel.bottom+ 3.0f;
    repeatLabel.left = 18.0f;
    
    _stateSwitch.left = self.width - _stateSwitch.width - 12.0f;
    _stateSwitch.centerY = self.height / 2.0f;

    indicatorView.centerY = self.height / 2.0f;
    indicatorView.right = self.contentView.width - 20.0f;
}

@end
