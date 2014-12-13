//
//  UIBarButtonItem+HT.m
//  helloTalk
//
//  Created by 任健生 on 13-3-8.
//
//

#import "UIBarButtonItem+HT.h"

@implementation UIBarButtonItem (HT)


+ (UIBarButtonItem *)backItemWithTarget:(id)target action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0f, 0.0f, 44.0f, 44.0f);
    [button setImage:[UIImage imageNamed:@"4设置_05"] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButton = nil;
    if (IOS7) {
        backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    } else {
        // 增加一个View,控制点击区域
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f)];
        containerView.backgroundColor = [UIColor clearColor];
        [containerView addSubview:button];
        backButton = [[UIBarButtonItem alloc] initWithCustomView:containerView];
    }
    return backButton;
}

+ (UIBarButtonItem *)uiBarButtonItemWithTarget:(id)target action:(SEL)action normalImage:(UIImage *)normalImg highlightImage:(UIImage *)highlightImg {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0f, 0.0f, normalImg.size.width, normalImg.size.height);
    [button setImage:normalImg forState:UIControlStateNormal];
    [button setImage:highlightImg forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    return backButton;
}

@end
