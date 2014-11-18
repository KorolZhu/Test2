//
//  UIColor+SW.h
//  SmartWatch
//
//  Created by zhuzhi on 14/11/16.
//
//

#import <UIKit/UIKit.h>

#define RGB(r,g,b) [UIColor rgbColorWithRed:r green:g blue:b]
#define RGBA(r,g,b,a) [UIColor rgbColorWithRed:r green:g blue:b alpha:a]

@interface UIColor (SW)

+ (UIColor *)rgbColorWithRed:(float)red green:(float)green blue:(float)blue;
+ (UIColor *)rgbColorWithRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha;

@end
