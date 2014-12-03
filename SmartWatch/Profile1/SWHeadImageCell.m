//
//  SWHeadImageCell.m
//  SmartWatch
//
//  Created by zhuzhi on 14/12/3.
//
//

#import "SWHeadImageCell.h"

@implementation SWHeadImageCell
{
    UIImageView *headImageView;
    UILabel *nameLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        headImageView = [[UIImageView alloc] init];
        headImageView.backgroundColor = [UIColor lightGrayColor];
        headImageView.layer.borderWidth = 3.0f;
        headImageView.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6f].CGColor;
        headImageView.layer.cornerRadius = 40.0f;
        [self.contentView addSubview:headImageView];
        headImageView.frame = CGRectMake((IPHONE_WIDTH - 80.0f) / 2.0f, 25.0f, 80.0f, 80.0f);
        
        nameLabel = [[UILabel alloc] init];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2f];
        nameLabel.layer.cornerRadius = 2.0f;
        nameLabel.font = [UIFont systemFontOfSize:17.0f];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.text = @"Zhu Zhi";
        [self.contentView addSubview:nameLabel];
        [nameLabel sizeToFit];
        nameLabel.top = headImageView.bottom + 6.0f;
        nameLabel.width += 30.0f;
        nameLabel.centerX = IPHONE_WIDTH / 2.0f;
    }
    
    return self;
}

- (void)setHeadImage:(UIImage *)headImage {
    _headImage = headImage;
    headImageView.image = headImage;
}

- (void)setName:(NSString *)name {
    _name = name;
    nameLabel.text = name;
}

@end
