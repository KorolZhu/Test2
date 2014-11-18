//
//  UIView+SW.h
//  SmartWatch
//
//  Created by zhuzhi on 14/11/16.
//
//

#import <UIKit/UIKit.h>

@interface UIView (SW)

- (CGFloat)width;
- (CGFloat)height;
- (CGFloat)top;
- (CGFloat)left;
- (CGFloat)bottom;
- (CGFloat)right;
- (CGFloat)centerX;
- (CGFloat)centerY;

- (void)setTop:(CGFloat)top;
- (void)setLeft:(CGFloat)left;
- (void)setRight:(CGFloat)right;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;
- (void)setCenterX:(CGFloat)centerX;
- (void)setCenterY:(CGFloat)centerY;

@end

@interface UIView (Private)

- (NSString *)recursiveDescription;

@end
