//
//  UIDevice+SW.h
//  SmartWatch
//
//  Created by zhuzhi on 14/11/16.
//
//

#import <UIKit/UIKit.h>

@interface UIDevice (SW)

- (BOOL)isIOS7;
- (BOOL)isIOS8;

- (float)screenWidth;
- (float)screenHeight;
- (float)statusbarWidth;
- (float)statusbarHeight;

@end
