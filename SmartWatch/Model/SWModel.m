//
//  SWModel.m
//  SmartWatch
//
//  Created by zhuzhi on 14/12/10.
//
//

#import "SWModel.h"

@implementation SWModel

- (instancetype)initWithResponder:(id)responder {
	self = [super init];
	if (self) {
		self.responder = responder;
	}
	
	return self;
}

- (void)respondSelectorOnMainThread:(SEL)selector {
	if ([self.responder respondsToSelector:selector]) {
		if ([NSThread isMainThread]) {
			NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self.responder methodSignatureForSelector:selector]];
			invocation.target = self.responder;
			invocation.selector = selector;
			[invocation invoke];
		} else {
			[self.responder performSelectorOnMainThread:selector withObject:nil waitUntilDone:NO];
		}
	}
}

@end
