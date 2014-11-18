//
//  SWShareKit.h
//  SmartWatch
//
//  Created by zhuzhi on 14/11/16.
//
//

#import <Foundation/Foundation.h>
#import "SWSingleton.h"
#import "SWShareConstant.h"

@interface SWShareKit : NSObject

SM_AS_SINGLETON(SWShareKit, sharedInstance);

- (void)registerApp;

- (BOOL)handleOpenURL:(NSURL *)url;

- (void)sendMessage:(NSString*)message WithUrl:(NSString*)url WithType:(SWShareType)shareType;

@end
