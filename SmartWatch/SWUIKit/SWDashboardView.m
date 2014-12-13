//
//  SWCircleView.m
//  SmartWatch
//
//  Created by zhuzhi on 14/12/2.
//
//

#import "SWDashboardView.h"

@interface SWCircleView : UIView

@property (nonatomic,strong)NSString *value;
@property (nonatomic,strong)NSString *unit;
@property (nonatomic,strong)NSString *descri;

@end

@interface SWCircleView ()
{
    UIImageView *backImageView;
    UILabel *valueLabel;
    UILabel *descriLabel;
}

@end

@implementation SWCircleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 51.0f, 51.0f)];
        backImageView.image = [UIImage imageNamed:@"1运动记录_73"];
        [self addSubview:backImageView];
        
        valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 51.0f, 51.0f)];
        valueLabel.numberOfLines = 0;
        valueLabel.textAlignment = NSTextAlignmentCenter;
        valueLabel.backgroundColor = [UIColor clearColor];
        valueLabel.font = [UIFont systemFontOfSize:11.0f];
        valueLabel.textColor = RGBFromHex(0x868686);
        [self addSubview:valueLabel];
        
        descriLabel = [[UILabel alloc] initWithFrame:CGRectMake(61.0f, 0.0f, 51.0f, 51.0f)];
        descriLabel.textAlignment = NSTextAlignmentLeft;
        descriLabel.backgroundColor = [UIColor clearColor];
        descriLabel.font = [UIFont systemFontOfSize:11.0f];
        descriLabel.textColor = [UIColor whiteColor];
        [self addSubview:descriLabel];
    }
    
    return self;
}

- (void)setValue:(NSString *)value {
    _value = value;
    valueLabel.text = [NSString stringWithFormat:@"%@\n%@", _value, _unit];
}

- (void)setUnit:(NSString *)unit {
    _unit = unit;
    valueLabel.text = [NSString stringWithFormat:@"%@\n%@", _value, _unit];
}

- (void)setDescri:(NSString *)descri {
    _descri = descri;
    descriLabel.text = descri;
}

@end

@interface SWDashboardView ()

@property (nonatomic,strong)SWCircleView *circleView1;
@property (nonatomic,strong)SWCircleView *circleView2;
@property (nonatomic,strong)SWCircleView *circleView3;

@end

@implementation SWDashboardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _circleView1 = [[SWCircleView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 112.0f, 51.0f)];
        _circleView2 = [[SWCircleView alloc] initWithFrame:CGRectMake(0.0f, 60.0f, 112.0f, 51.0f)];
        _circleView3 = [[SWCircleView alloc] initWithFrame:CGRectMake(0.0f, 120.0f, 112.0f, 51.0f)];

        [self addSubview:_circleView1];
        [self addSubview:_circleView2];
        [self addSubview:_circleView3];
    }
    
    return self;
}

- (void)setValue1:(NSString *)value1 {
    _circleView1.value = value1;
}

- (void)setUnit1:(NSString *)unit {
    _circleView1.unit = unit;
}

- (void)setDescri1:(NSString *)descri {
    _circleView1.descri = descri;
}

- (void)setValue2:(NSString *)value2 {
    _circleView2.value = value2;
}

- (void)setUnit2:(NSString *)unit {
    _circleView2.unit = unit;
}

- (void)setDescri2:(NSString *)descri {
    _circleView2.descri = descri;
}

- (void)setValue3:(NSString *)value3 {
    _circleView3.value = value3;
}

- (void)setUnit3:(NSString *)unit {
    _circleView3.unit = unit;
}

- (void)setDescri3:(NSString *)descri {
    _circleView3.descri = descri;
}

@end
