//
//  SWShareKit.m
//  SmartWatch
//
//  Created by zhuzhi on 14/11/16.
//
//

#import "SWShareKit.h"
#import "WXApi.h"
#import "WXApiObject.h"

@interface SWShareKit ()<WXApiDelegate>

@end

@implementation SWShareKit

SW_DEF_SINGLETON(SWShareKit, sharedInstance)

- (void)registerApp {
    [WXApi registerApp:KWeChatAppId];
}

- (BOOL)handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)sendMessage:(NSString *)message WithUrl:(NSString *)url WithType:(SWShareType)shareType {
    // 发送内容给微信
    
    WXMediaMessage *mediaMessage = [WXMediaMessage message];
    mediaMessage.title = message;
    mediaMessage.description = @"description";
    [mediaMessage setThumbImage:[UIImage imageNamed:@"first"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = url;
    
    mediaMessage.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = mediaMessage;
    req.scene = shareType == SWShareTypeWechatTimeline ? WXSceneTimeline : WXSceneSession;
    
    [WXApi sendReq:req];
}

#pragma mark - WXApiDelegate 


@end
