//
//  ZZLineGraphView.m
//  LineChart
//
//  Created by zhuzhi on 14/11/17.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//

#import "SWLineGraphView.h"
#import "SWPlot.h"
#import <math.h>
#import <objc/runtime.h>

NSString *const kXAxisLabelColorKey         = @"kXAxisLabelColorKey";
NSString *const kXAxisLabelFontKey          = @"kXAxisLabelFontKey";
NSString *const kXAxisDescLabelColorKey     = @"kXAxisDescLabelColorKey";
NSString *const kXAxisDescLabelFontKey      = @"kXAxisDescLabelFontKey";
NSString *const kYAxisLabelColorKey         = @"kYAxisLabelColorKey";
NSString *const kYAxisLabelFontKey          = @"kYAxisLabelFontKey";
NSString *const kYAxisDescLabelColorKey     = @"kYAxisDescLabelColorKey";
NSString *const kYAxisDescLabelFontKey      = @"kYAxisDescLabelFontKey";
NSString *const kYAxisLabelSideMarginsKey   = @"kYAxisLabelSideMarginsKey";
NSString *const kPlotBackgroundLineColorKey = @"kPlotBackgroundLineColorKey";
NSString *const kDotSizeKey                 = @"kDotSizeKey";

#define TOP_MARGIN_TO_LEAVE 10.0
#define TOP_X_AXIS_TO_LEAVE 15.0f
#define TOP_Y_AXIS_TO_LEAVE 10.0
#define ITEM_PADDING 3.0F

@interface SWLineGraphView ()
{
    UIView *chartBackView;
    UILabel *xDescriptionLabel;
    UILabel *yDescriptionLabel;
    CGPoint origin;
    CGFloat xAxisWidthInPx;
    CGFloat xIntervalInPx;
    CGFloat yAxisHeightInPx;
    CGFloat yIntervalInPx;
}

@end
@implementation SWLineGraphView

- (instancetype)init {
    if((self = [super init])) {
        [self loadDefaultTheme];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadDefaultTheme];
    }
    return self;
}

- (void)loadDefaultTheme {
    _themeAttributes = @{
                         kXAxisLabelColorKey : [UIColor whiteColor],
                         kXAxisLabelFontKey : [UIFont systemFontOfSize:9.0f],
                         kXAxisDescLabelColorKey : [[UIColor whiteColor] colorWithAlphaComponent:0.5f],
                         kXAxisDescLabelFontKey : [UIFont systemFontOfSize:11.0f],
                         kYAxisLabelColorKey : [[UIColor whiteColor] colorWithAlphaComponent:0.5f],
                         kYAxisLabelFontKey : [UIFont systemFontOfSize:9.0f],
                         kYAxisDescLabelColorKey : [UIColor blackColor],
                         kYAxisDescLabelFontKey : [UIFont systemFontOfSize:11.0f],
                         kYAxisLabelSideMarginsKey : @10,
                         kPlotBackgroundLineColorKey : [UIColor colorWithRed:0.48 green:0.48 blue:0.49 alpha:0.4],
                         kDotSizeKey : @4.0
                         };
}

- (void)addPlot:(SWPlot *)newPlot;
{
    if(nil == newPlot) {
        return;
    }
    
    if(_plots == nil){
        _plots = [NSMutableArray array];
    }
    [_plots addObject:newPlot];
}

- (void)setupTheView
{
    [self drawBackground];
    
    [self drawYAxis];
    [self drawXAxis];
    [self drawLines];
    
    for(SWPlot *plot in _plots) {
        [self drawPlot:plot];
    }
}

#pragma mark - Actual Plot Drawing Methods

- (void)drawBackground {
    if (_headView) {
        [self addSubview:_headView];
    }
    
    yDescriptionLabel = [[UILabel alloc] init];
    yDescriptionLabel.font = [_themeAttributes objectForKey:kYAxisDescLabelFontKey];
    yDescriptionLabel.textColor = [_themeAttributes objectForKey:kYAxisDescLabelColorKey];
    yDescriptionLabel.text = _yAxisDescription;
    [self addSubview:yDescriptionLabel];
    [yDescriptionLabel sizeToFit];
    yDescriptionLabel.center = CGPointMake(yDescriptionLabel.height / 2.0f + ITEM_PADDING, self.bounds.size.height / 2.0f);
    yDescriptionLabel.transform = CGAffineTransformMakeRotation(-M_PI_2);
    
    chartBackView = [[UIView alloc] init];
    chartBackView.layer.cornerRadius = 3.5f;
    chartBackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2f];
    [self addSubview:chartBackView];
    [chartBackView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(_headView.height + ITEM_PADDING, yDescriptionLabel.width + 2 * ITEM_PADDING, 0.0f, yDescriptionLabel.width + 2 * ITEM_PADDING)];
    _headView.left = yDescriptionLabel.width + 2 * ITEM_PADDING;
    
    xDescriptionLabel = [[UILabel alloc] init];
    xDescriptionLabel.font = [_themeAttributes objectForKey:kXAxisDescLabelFontKey];
    xDescriptionLabel.textColor = [_themeAttributes objectForKey:kXAxisDescLabelColorKey];
    xDescriptionLabel.text = _xAxisDescription;
    [self addSubview:xDescriptionLabel];
    [xDescriptionLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [xDescriptionLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:ITEM_PADDING];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)drawYAxis {
    CGFloat xAxisLabelHeight = 0.0f;
    if (_xAxisValues.count > 0) {
        NSDictionary *dic = [_xAxisValues firstObject];
        NSString *xAxisValue = dic.allValues.firstObject;
        NSDictionary *attributeDic = @{NSFontAttributeName: [_themeAttributes objectForKey:kXAxisLabelFontKey]};
        CGSize size = [xAxisValue sizeWithAttributes:attributeDic];
        xAxisLabelHeight = size.height;
    }
    
    yAxisHeightInPx = chartBackView.height - xDescriptionLabel.height - xAxisLabelHeight - TOP_MARGIN_TO_LEAVE - 3 * ITEM_PADDING;
    origin.y = chartBackView.top + TOP_MARGIN_TO_LEAVE + yAxisHeightInPx;
    
    double yIntervalValue = _yAxisRange / _yIntervalCount;

    NSMutableArray *labelArray = [NSMutableArray array];
    float maxWidth = 0;

    for(int i = 0; i <= _yIntervalCount; i++){
        UILabel *yAxisLabel = [[UILabel alloc] init];
        yAxisLabel.backgroundColor = [UIColor clearColor];
        yAxisLabel.font = [_themeAttributes objectForKey:kYAxisLabelFontKey];
        yAxisLabel.textColor = [_themeAttributes objectForKey:kYAxisLabelColorKey];
        yAxisLabel.textAlignment = NSTextAlignmentCenter;
        float val = i * yIntervalValue;
        yAxisLabel.text = [NSString stringWithFormat:@"%.1f%@", val, _yAxisSuffix.length == 0
                           ? @"" : _yAxisSuffix];
        [yAxisLabel sizeToFit];
        if (yAxisLabel.width > maxWidth) {
            maxWidth = yAxisLabel.width;
        }

        [labelArray addObject:yAxisLabel];
    }
    
    xAxisWidthInPx = chartBackView.width - maxWidth - 3 *ITEM_PADDING;
    origin.x = chartBackView.left + maxWidth + 2 * ITEM_PADDING;
    
    yIntervalInPx = (yAxisHeightInPx - TOP_Y_AXIS_TO_LEAVE) / _yIntervalCount;

    for(int i = 0; i < labelArray.count; i++) {
        UILabel *label = [labelArray objectAtIndex:i];
        CGRect frame = label.frame;
        frame.origin.x = chartBackView.left + ITEM_PADDING;
        frame.origin.y = origin.y - i * yIntervalInPx - frame.size.height / 2.0f;
        frame.size.width = maxWidth;
        label.frame = frame;
        [self addSubview:label];
        
        if (i > 0) {
            UIImageView *line = [[UIImageView alloc] init];
            line.backgroundColor = [UIColor whiteColor];
            [self addSubview:line];
            frame.origin.x = origin.x - 3.0f;
            frame.origin.y = origin.y - i * yIntervalInPx;
            frame.size.width = 3.0f;
            frame.size.height = 1.0f;
            line.frame = frame;
        }
    }
    
    UIImageView *yAxis = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"曲线图_竖线"]];
    [self addSubview:yAxis];
    CGRect frame = CGRectZero;
    frame.origin.x = origin.x;
    frame.origin.y = chartBackView.top + TOP_MARGIN_TO_LEAVE;
    frame.size.height = yAxisHeightInPx;
    frame.size.width = 1.0f;
    yAxis.frame = frame;
}

- (void)drawXAxis {
    xIntervalInPx = (xAxisWidthInPx - TOP_X_AXIS_TO_LEAVE) / _xIntervalCount;
    for (NSDictionary *dic in _xAxisValues) {
        int index = [dic.allKeys.firstObject intValue];
        NSString *value = dic.allValues.firstObject;
        UILabel *xAxisLabel = [[UILabel alloc] init];
        xAxisLabel.backgroundColor = [UIColor clearColor];
        xAxisLabel.font = [_themeAttributes objectForKey:kXAxisLabelFontKey];
        xAxisLabel.textColor = [_themeAttributes objectForKey:kXAxisLabelColorKey];
        xAxisLabel.textAlignment = NSTextAlignmentCenter;
        xAxisLabel.text = value;
        [xAxisLabel sizeToFit];
        [self addSubview:xAxisLabel];
        xAxisLabel.centerX = origin.x + index * xIntervalInPx;
        xAxisLabel.centerY = origin.y + xAxisLabel.height / 2.0f + ITEM_PADDING;
    }
    
    UIImageView *xAxis = [[UIImageView alloc] init];
    xAxis.backgroundColor = [UIColor whiteColor];
    [self addSubview:xAxis];
    CGRect frame = CGRectZero;
    frame.origin = origin;
    frame.size.width = xAxisWidthInPx;
    frame.size.height = 1.0f;
    xAxis.frame = frame;
}

- (void)drawLines {
    for (int i = 0; i <= _xIntervalCount; i++) {
        UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"曲线图_竖线"]];
        [self addSubview:line];
        CGRect frame = CGRectZero;
        frame.origin.x = origin.x + i * xIntervalInPx;
        frame.origin.y = chartBackView.top + TOP_MARGIN_TO_LEAVE;
        frame.size.width = 1.0f;
        frame.size.height = yAxisHeightInPx;
        line.frame = frame;
    }
}

- (float)getValueForIndex:(NSNumber *)index forPlot:(SWPlot *)plot {
    __block float value = 0.0f;
    [plot.plottingValues enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dic = obj;
        if ([dic.allKeys containsObject:index]) {
            value = [dic.allValues.firstObject floatValue];
            *stop = YES;
        }
    }];
    
    return value;
}

- (void)drawPlot:(SWPlot *)plot {
    CAShapeLayer *graphLayer = [CAShapeLayer layer];
    graphLayer.frame = self.bounds;
    graphLayer.fillColor = [UIColor clearColor].CGColor;
    graphLayer.backgroundColor = [UIColor clearColor].CGColor;
    [graphLayer setStrokeColor:[[plot.plotThemeAttributes objectForKey:kPlotStrokeColorKey] CGColor]];
    [graphLayer setLineWidth:[[plot.plotThemeAttributes objectForKey:kPlotStrokeWidthKey] intValue]];
    
    CGMutablePathRef graphPath = CGPathCreateMutable();
    
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.frame = self.bounds;
    circleLayer.fillColor = [[plot.plotThemeAttributes objectForKey:kPlotPointFillColorKey] CGColor];
    circleLayer.backgroundColor = [UIColor clearColor].CGColor;
    [circleLayer setStrokeColor:[[plot.plotThemeAttributes objectForKey:kPlotPointFillColorKey] CGColor]];
    [circleLayer setLineWidth:[[plot.plotThemeAttributes objectForKey:kPlotStrokeWidthKey] intValue]];
    
    CGMutablePathRef circlePath = CGPathCreateMutable();
    
    for (int i = 1; i <= _xIntervalCount ; i++) {
        CGPoint point = CGPointZero;
        point.x = origin.x + i * xIntervalInPx;
        point.y =  origin.y - [self getValueForIndex:@(i) forPlot:plot] * yIntervalInPx / (_yAxisRange / _yIntervalCount);
        if (i == 1) {
            CGPathMoveToPoint(graphPath, NULL, point.x, point.y);
        } else {
            CGPathAddLineToPoint(graphPath, NULL, point.x, point.y);
        }
        CGFloat dotsSize = [_themeAttributes[kDotSizeKey] floatValue];
        CGPathAddEllipseInRect(circlePath, NULL, CGRectMake(point.x - dotsSize/2.0f, point.y - dotsSize/2.0f, dotsSize, dotsSize));
    }
    
    graphLayer.path = graphPath;
    circleLayer.path = circlePath;
    
    [self.layer addSublayer:graphLayer];
    [self.layer addSublayer:circleLayer];
    
}

@end
