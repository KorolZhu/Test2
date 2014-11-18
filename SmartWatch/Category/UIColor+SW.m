//
//  UIColor+SW.m
//  SmartWatch
//
//  Created by zhuzhi on 14/11/16.
//
//

#import "UIColor+SW.h"

@implementation UIColor (SW)

+ (UIColor *)rgbColorWithRed:(float)red green:(float)green blue:(float)blue {
    return [UIColor rgbColorWithRed:red green:green blue:blue alpha:1.0f];
}

+ (UIColor *)rgbColorWithRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha {
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
}

@end
