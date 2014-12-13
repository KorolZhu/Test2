//
//  UIBarButtonItem+HT.h
//  helloTalk
//
//  Created by 任健生 on 13-3-8.
//
//

#import <UIKit/UIKit.h>


@interface UIBarButtonItem (HT)

+ (UIBarButtonItem *)backItemWithTarget:(id)target action:(SEL)action;

+ (UIBarButtonItem *)uiBarButtonItemWithTarget:(id)target action:(SEL)action normalImage:(UIImage *)normalImg highlightImage:(UIImage *)highlightImg;

@end
