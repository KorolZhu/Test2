//
//  SWProfileInfoCell.m
//  SmartWatch
//
//  Created by zhuzhi on 14/12/3.
//
//

#import "SWProfileInfoCell.h"

@implementation SWProfileInfoCell
{
    UILabel *titleLabel;
    UILabel *valueLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:14.0f];
        titleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:titleLabel];
        titleLabel.frame = CGRectMake(17.0f, 0.0f, 135.0f, 45.0f);
        
        UIImageView *accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"4设置_43"]];
        [self.contentView addSubview:accessoryView];
        accessoryView.left = IPHONE_WIDTH - 24.0f;
        accessoryView.centerY = 23.0f;
        
        valueLabel = [[UILabel alloc] init];
        valueLabel.textAlignment = NSTextAlignmentRight;
        valueLabel.backgroundColor = [UIColor clearColor];
        valueLabel.font = [UIFont systemFontOfSize:14.0f];
        valueLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:valueLabel];
        valueLabel.frame = CGRectMake(accessoryView.left - 115.0f, 0.0f, 100.0f, 45.0f);
    }
    
    return self;
    
}

- (void)setTitle:(NSString *)title {
    _title = title;
    titleLabel.text = title;
}

- (void)setValue:(NSString *)value {
    _value = value;
    valueLabel.text = value;
}

@end
