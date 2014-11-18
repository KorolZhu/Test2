//
//  UIDevice+SW.m
//  SmartWatch
//
//  Created by zhuzhi on 14/11/16.
//
//

#import "UIDevice+SW.h"

@implementation UIDevice (SW)

- (NSInteger)majorVersion {
    NSNumber *majorVersion = [[self.systemVersion componentsSeparatedByString:@"."] objectAtIndex:0];
    NSInteger result = majorVersion.integerValue;
    return result;
}

- (BOOL)isIOS7 {
    
    static BOOL isIOS7;
    
    GCDExecOnce(^{
        isIOS7 = ([self majorVersion] >= 7);
    });
    
    return isIOS7;
}

- (BOOL)isIOS8 {
    static BOOL isIOS8;
    
    GCDExecOnce(^{
        isIOS8 = ([self majorVersion] >= 8);
    });
    
    return isIOS8;
}

- (float)screenWidth {
    
    if (IOS8) {
        return [UIScreen mainScreen].bounds.size.width;
    }
    
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        return [UIScreen mainScreen].bounds.size.height;
    }
    //    if (UIInterfaceOrientationIsLandscape(self.orientation)) {
    //        return IPHONE_HEIGHT;
    //    }
    
    return [UIScreen mainScreen].bounds.size.width;
}

- (float)screenHeight {
    
    if (IOS8) {
        return [UIScreen mainScreen].bounds.size.height;
    }
    
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        return [UIScreen mainScreen].bounds.size.width;
    }
    
    //    if (UIInterfaceOrientationIsLandscape(self.orientation)) {
    //        return IPHONE_WIDTH;
    //    }
    
    return [UIScreen mainScreen].bounds.size.height;
}

- (float)statusbarWidth {
    if (IOS8) {
        return [[UIApplication sharedApplication] statusBarFrame].size.width;
    }
    
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        return [[UIApplication sharedApplication] statusBarFrame].size.height;
    }
    
    
    return [[UIApplication sharedApplication] statusBarFrame].size.width;
}

- (float)statusbarHeight {
    if (IOS8) {
        return [[UIApplication sharedApplication] statusBarFrame].size.height;
    }
    
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        return [[UIApplication sharedApplication] statusBarFrame].size.width;
    }
    
    
    return [[UIApplication sharedApplication] statusBarFrame].size.height;
}

@end
