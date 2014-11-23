//
//  SWEnvironmentView.m
//  SmartWatch
//
//  Created by zhuzhi on 14/11/23.
//
//

#import "SWEnvironmentView.h"

@interface SWEnvironmentLabel : UIView
{
    UIImageView *imageView;
    UILabel *titleLabel;
    UILabel *valueLabel;
}

@property (nonatomic,strong)UIImage *image;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *value;

@end

@implementation SWEnvironmentLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        
        titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:10.0f];
        titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:titleLabel];
        
        valueLabel = [[UILabel alloc] init];
        valueLabel.textAlignment = NSTextAlignmentCenter;
        valueLabel.backgroundColor = [UIColor clearColor];
        valueLabel.font = [UIFont systemFontOfSize:10.0f];
        valueLabel.textColor = [UIColor whiteColor];
        [self addSubview:valueLabel];
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    imageView.image = image;
    [self setNeedsLayout];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    titleLabel.text = title;
    [self setNeedsLayout];
}

- (void)setValue:(NSString *)value {
    _value = value;
    valueLabel.text = value;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize titleSize = [_title sizeWithAttributes:@{NSFontAttributeName: titleLabel.font}];
    CGSize valueSize = [_value sizeWithAttributes:@{NSFontAttributeName: valueLabel.font}];
    
    CGFloat maxLabelWidth = MAX(titleSize.width, valueSize.width);
    CGFloat totalWidth = maxLabelWidth + _image.size.width + 2.0f;
    imageView.frame = CGRectMake((self.width - totalWidth) / 2.0f, (self.height - _image.size.height) / 2.0f, _image.size.width, _image.size.height);
    titleLabel.frame = CGRectMake(imageView.right + 2.0f, 0.0f, titleSize.width, titleSize.height);
    valueLabel.frame = CGRectMake(imageView.right + 2.0f, titleLabel.bottom, valueSize.width, valueSize.height);
}

@end

@interface SWEnvironmentView ()
{
    SWEnvironmentLabel *uvLabel;
    SWEnvironmentLabel *temperatureLabel;
    SWEnvironmentLabel *humidityLabel;
    SWEnvironmentLabel *leftPowerLabel;
}

@end
@implementation SWEnvironmentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *image = [[UIImage imageNamed:@"bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(5.0f, 13.0f, 5.0f, 13.0f)];
        UIImageView *backView = [[UIImageView alloc] initWithImage:image];
        backView.frame = self.bounds;
        [self addSubview:backView];
        
        uvLabel = [[SWEnvironmentLabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.width / 4.0f, self.height)];
        uvLabel.title = NSLocalizedString(@"紫外线等级", nil);
        uvLabel.image = [UIImage imageNamed:@"ico_紫外线"];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [RGBFromHex(0x868686) colorWithAlphaComponent:0.2f];
        [self addSubview:lineView];
        lineView.frame = CGRectMake(self.width / 4.0f, 0.0f, 1.0f, self.height);
        
        temperatureLabel = [[SWEnvironmentLabel alloc] initWithFrame:CGRectMake(uvLabel.right, 0.0f, self.width / 4.0f, self.height)];
        temperatureLabel.title = NSLocalizedString(@"温度", nil);
        temperatureLabel.image = [UIImage imageNamed:@"ico_温度"];
        
        UIView *lineView2 = [[UIView alloc] init];
        lineView2.backgroundColor = [RGBFromHex(0x868686) colorWithAlphaComponent:0.2f];
        [self addSubview:lineView2];
        lineView2.frame = CGRectMake(2 * self.width / 4.0f, 0.0f, 1.0f, self.height);
        
        humidityLabel = [[SWEnvironmentLabel alloc] initWithFrame:CGRectMake(temperatureLabel.right, 0.0f, self.width / 4.0f, self.height)];
        humidityLabel.title = NSLocalizedString(@"湿度", nil);
        humidityLabel.image = [UIImage imageNamed:@"ico_湿度"];
        
        UIView *lineView3 = [[UIView alloc] init];
        lineView3.backgroundColor = [RGBFromHex(0x868686) colorWithAlphaComponent:0.2f];
        [self addSubview:lineView3];
        lineView3.frame = CGRectMake(3 * self.width / 4.0f, 0.0f, 1.0f, self.height);
        
        leftPowerLabel = [[SWEnvironmentLabel alloc] initWithFrame:CGRectMake(humidityLabel.right, 0.0f, self.width / 4.0f, self.height)];
        leftPowerLabel.title = NSLocalizedString(@"剩余电量", nil);
        leftPowerLabel.image = [UIImage imageNamed:@"ico_电量"];

        [self addSubview:uvLabel];
        [self addSubview:temperatureLabel];
        [self addSubview:humidityLabel];
        [self addSubview:leftPowerLabel];
    }
    
    return self;
    
}

- (void)setUvLevel:(NSInteger)uvLevel {
    uvLabel.value = [NSString stringWithFormat:@"%ld级", (long)uvLevel];
}

- (void)setTemperature:(NSInteger)temperature {
    temperatureLabel.value = [NSString stringWithFormat:@"%ld℃", (long)temperature];
}

- (void)setHumidity:(NSInteger)humidity {
    humidityLabel.value = [NSString stringWithFormat:@"%ld%%", (long)humidity];
}

- (void)setLeftPower:(float)leftPower {
    leftPowerLabel.value = [NSString stringWithFormat:@"%ld%%", (long)leftPower];
}

@end
