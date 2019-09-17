//
//  ShareTool.m
//  novel
//
//  Created by 黎铭轩 on 15/9/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "ShareTool.h"
#import <WXApi.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
@interface ShareTool()<TencentSessionDelegate,WXApiDelegate>
@property (copy, nonatomic)Completion completion;
@end
@implementation ShareTool
static ShareTool *instance;
+ (void)shareInit{
    [WXApi registerApp: WChatAppKey];
    TencentOAuth *auth=[[TencentOAuth alloc]initWithAppId:QQAppKey andDelegate:self];
}
+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance=[[self alloc] init];
    });
    return instance;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance=[super allocWithZone:zone];
    });
    return instance;
}
+ (BOOL)handleOpenURL:(NSURL *)url{
    [WXApi handleOpenURL:url delegate:self];
    [QQApiInterface handleOpenURL:url delegate:self];
    [TencentOAuth HandleOpenURL:url];
    return NO;
}
+ (void)shareTo:(ShareType)type imageUrl:(NSString *)imageUrl title:(NSString *)title subTitle:(NSString *)subTitle completion:(Completion)completion{
    NSString *content=[NSString stringWithFormat: @"我正在看《%@》\n%@",title,subTitle];
    [ShareTool shareInstance].completion = completion;
    NSData *imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    UIImage *logo=[UIImage imageNamed: @"icon_logo"];
    NSData *data=UIImageJPEGRepresentation(logo, 0.9);
    if (data.length >= 32*1024) {
        data=UIImageJPEGRepresentation([logo imageByResizeToSize:CGSizeMake(120, 120)], 0.9);
    }
    switch (type) {
        case ShareTypeWeChatLine:
            if (![WXApi isWXAppInstalled]) {
                !completion ?: completion(@"该设备未安装微信APP");
                return;
            }
            break;
        case ShareTypeQQZone:{
            if (![QQApiInterface isQQInstalled]) {
                !completion ?: completion(@"该设备未安装QQ");
                return;
            }
                QQApiImageArrayForQZoneObject *object=[QQApiImageArrayForQZoneObject objectWithimageDataArray:[NSArray arrayWithObject:imageData] title:content extMap:nil];
                SendMessageToQQReq *reqs=[SendMessageToQQReq reqWithContent:object];
                [QQApiInterface SendReqToQZone:reqs];
        }
        default:
            break;
    }
}
+ (void)shareType:(ShareType)type url:(NSString *)url title:(NSString *)title subTitle:(NSString *)subTitle completion:(Completion)completion{
    [ShareTool shareInstance].completion = completion;
    UIImage *image=[UIImage imageNamed:@"icon_logo"];
    NSData *data=UIImageJPEGRepresentation(image, 0.9);
    // 图片大小不能超过32k
    if (data.length >= 32*1024) {
        data=UIImageJPEGRepresentation([image imageByResizeToSize:CGSizeMake(120, 120) contentMode:UIViewContentModeScaleAspectFill], 0.9);
    }
    switch (type) {
        case ShareTypeWeChatLine:{
            if (![WXApi isWXAppInstalled]) {
                if (!completion) {
                    //提示该设备未安装微信APP
                    completion(@"该设备未安装微信APP");
                }
                return;
            }
            WXMediaMessage *message=[WXMediaMessage message];
            message.title=title;
            message.description=subTitle;
            message.thumbData=data;
            
            WXWebpageObject *web=[WXWebpageObject object];
            web.webpageUrl=url;
            message.mediaObject=web;
            
            SendMessageToWXReq *req=[[SendMessageToWXReq alloc]init];
            req.bText=NO;
            req.message=message;
            req.scene = type == ShareTypeWeChat ? WXSceneSession : WXSceneTimeline;
            [WXApi sendReq:req];
        }
            break;
        case ShareTypeQQZone:{
            if (![QQApiInterface isQQInstalled]) {
                if (!completion) {
                    completion(@"该设备未安装QQ");
                }
                return;
            }
            QQApiURLObject *object=[QQApiURLObject objectWithURL:[NSURL URLWithString:url] title:title description:subTitle previewImageData:data targetContentType:QQApiURLTargetTypeVideo];
            object.shareDestType=ShareDestTypeQQ;
            SendMessageToQQReq *req=[SendMessageToQQReq reqWithContent:object];
            type == ShareTypeQQ ? [QQApiInterface sendReq:req] : [QQApiInterface SendReqToQZone:req];
            break;
        }
        default:
            break;
    }
}
+ (void)shareSystem:(NSString *)title url:(NSString *)url completion:(Completion)completion{
    NSString *content=[NSString stringWithFormat: @"我在阅读《%@》小说",title];
    NSArray *activityItems=[NSArray arrayWithObjects:content,[UIImage imageNamed:@"icon_logo"],[NSURL URLWithString:url], nil];
    UIActivityViewController *activity=[[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:@[]];
    [activity setCompletionWithItemsHandler:^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        !completion ?: completion(content ? @"操作成功" : @"操作失败,请重试");
    }];
    UIViewController *rootViewController=[UIViewController rootTopPresentedController];
    [rootViewController presentViewController:activity animated:YES completion:nil];
}
- (void)onResp:(BaseResp *)resp{
    if ([resp isKindOfClass:[SendMessageToQQResp class]]) {
        SendMessageToQQResp *resps=(SendMessageToQQResp *)resp;
        if (resps.result.integerValue==0) {
            !self.completion ?: self.completion(@"分享成功");
        }
        else if(resps.result.integerValue==-4){
            !self.completion ?: self.completion(@"分享取消");
        }
        else{
            !self.completion ?: self.completion(@"分享失败");
        }
    }
    else{
        if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
            if (resp.errCode == WXSuccess) {
                !self.completion ?: self.completion(@"分享成功");
            }
            else if(resp.errCode == WXErrCodeUserCancel){
                !self.completion ?: self.completion(@"分享取消");
            }
            else{
                !self.completion ?: self.completion(@"分享失败");
            }
        }
    }
    self.completion = nil;
}
@end
