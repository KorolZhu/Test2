//
//  SWHeadImageCell.m
//  SmartWatch
//
//  Created by zhuzhi on 14/12/3.
//
//

#import "SWHeadImageCell.h"

@interface SWHeadImageCell ()<UITextFieldDelegate,UIActionSheetDelegate>

@end

@implementation SWHeadImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        _headImageView = [[UIImageView alloc] init];
        _headImageView.backgroundColor = [UIColor lightGrayColor];
        _headImageView.layer.masksToBounds = YES;
        _headImageView.clipsToBounds = YES;
        _headImageView.layer.borderWidth = 3.0f;
        _headImageView.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6f].CGColor;
        _headImageView.layer.cornerRadius = 40.0f;
        [self.contentView addSubview:_headImageView];
        _headImageView.frame = CGRectMake((IPHONE_WIDTH - 80.0f) / 2.0f, 25.0f, 80.0f, 80.0f);
        _headImageView.userInteractionEnabled = YES;
        
        _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake((IPHONE_WIDTH - 150.0f) / 2.0f, _headImageView.bottom + 6.0f, 150.0f, 25.0f)];
        _nameTextField.delegate = self;
        _nameTextField.borderStyle = UITextBorderStyleNone;
        _nameTextField.textAlignment = NSTextAlignmentCenter;
        _nameTextField.font = [UIFont systemFontOfSize:17.0f];
        _nameTextField.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2f];
        _nameTextField.layer.cornerRadius = 2.0f;
        _nameTextField.textColor = [UIColor whiteColor]; 
        _nameTextField.returnKeyType = UIReturnKeyDone;
        [self.contentView addSubview:_nameTextField];
    }
    
    return self;
}

@end
