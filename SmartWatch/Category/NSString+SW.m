//
//  NSString+SW.m
//  SmartWatch
//
//  Created by zhuzhi on 14/12/8.
//
//

#import "NSString+SW.h"

@implementation NSString (SW)

- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)containString:(NSString *)string {
    if (!string || string.length <= 0) {
        return NO;
    }
    return ([self rangeOfString:string].location != NSNotFound);
}

@end
