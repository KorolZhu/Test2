//
//  SWModel.h
//  SmartWatch
//
//  Created by zhuzhi on 14/12/10.
//
//

#import <Foundation/Foundation.h>

@interface SWModel : NSObject

@property (nonatomic,weak) id responder;

- (instancetype)initWithResponder:(id)responder;

- (void)respondSelectorOnMainThread:(SEL)selector;

@end
