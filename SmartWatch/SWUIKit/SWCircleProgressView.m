//
//  SWCircleProgressView.m
//  SmartWatch
//
//  Created by zhuzhi on 14/11/23.
//
//

#import "SWCircleProgressView.h"

#define DEGREES_2_RADIANS(x) (0.0174532925 * (x))

@interface SWCircleProgressView ()
{
    UIImageView *backImageView;
    UILabel *topDescLabel;
    UILabel *bottomDescLabel;
    UILabel *valueLabel;
    
    CAShapeLayer *progressLayer;
    CGFloat circleStartAngle;
    CGFloat circleEndAngle;
    CGFloat radius;
}

@end
@implementation SWCircleProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 0.0f, 0.0f)];
    if (self) {
        backImageView = [[UIImageView alloc] init];
        [self addSubview:backImageView];
        
        valueLabel = [[UILabel alloc] init];
        valueLabel.textAlignment = NSTextAlignmentCenter;
        valueLabel.backgroundColor = [UIColor clearColor];
        valueLabel.font = [UIFont systemFontOfSize:44.0f];
        valueLabel.textColor = [UIColor whiteColor];
        [self addSubview:valueLabel];
        
        topDescLabel = [[UILabel alloc] init];
        topDescLabel.textAlignment = NSTextAlignmentCenter;
        topDescLabel.backgroundColor = [UIColor clearColor];
        topDescLabel.font = [UIFont systemFontOfSize:14.0f];
        topDescLabel.textColor = RGBFromHex(0x333333);
        [self addSubview:topDescLabel];
        
        bottomDescLabel = [[UILabel alloc] init];
        bottomDescLabel.textAlignment = NSTextAlignmentCenter;
        bottomDescLabel.backgroundColor = [UIColor clearColor];
        bottomDescLabel.font = [UIFont systemFontOfSize:14.0f];
        bottomDescLabel.textColor = RGBFromHex(0x333333);
        [self addSubview:bottomDescLabel];
    }
    
    return self;
}

- (void)setBackImage:(UIImage *)backImage {
    _backImage = backImage;
    backImageView.image = backImage;
    self.width = _backImage.size.width;
    self.height = _backImage.size.height;
    backImageView.frame = self.bounds;
}

- (void)setTopDesc:(NSString *)topDesc {
    _topDesc = topDesc;
    topDescLabel.text = topDesc;
    [self setNeedsLayout];
}

- (void)setBottomDesc:(NSString *)bottomDesc {
    _bottomDesc = bottomDesc;
    bottomDescLabel.text = bottomDesc;
    [self setNeedsLayout];
}

- (void)setValueString:(NSString *)valueString {
    _valueString = valueString;
    valueLabel.text = valueString;
    [self setNeedsDisplay];
}

- (void)setProgress:(float)progress {
    _progress = progress;
    
    if (!progressLayer) {
        progressLayer = [[CAShapeLayer alloc] init];
        progressLayer.strokeColor = [[UIColor whiteColor] CGColor];
        progressLayer.fillColor = [[UIColor clearColor] CGColor];
        progressLayer.lineCap = @"round";
        progressLayer.lineWidth = 6.0f;
        [self.layer addSublayer:progressLayer];
        
        circleStartAngle = 116.0f;
        circleEndAngle = 450.0f - (circleStartAngle - 90.0f);
        radius = self.width / 2.0f - 9.0f;
    }
    
    CGFloat endAngle = circleStartAngle + (circleEndAngle - circleStartAngle) * progress;
    UIBezierPath* aPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width / 2.0f, self.height / 2.0f)
                                                         radius:radius
                                                     startAngle:DEGREES_2_RADIANS(circleStartAngle)
                                                       endAngle:DEGREES_2_RADIANS(endAngle)
                                                      clockwise:YES];
    progressLayer.path = aPath.CGPath;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [valueLabel sizeToFit];
    valueLabel.center = CGPointMake(self.width / 2.0f, self.height / 2.0f);
    
    [topDescLabel sizeToFit];
    topDescLabel.centerX = self.width / 2.0f;
    topDescLabel.bottom = valueLabel.top - 4.0f;
    
    [bottomDescLabel sizeToFit];
    bottomDescLabel.centerX = self.width / 2.0f;
    bottomDescLabel.top = valueLabel.bottom + 4.0f;
}

@end
