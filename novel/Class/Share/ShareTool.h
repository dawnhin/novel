//
//  ShareTool.h
//  novel
//
//  Created by 黎铭轩 on 15/9/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    ShareTypeWeChat,
    ShareTypeWeChatLine,
    ShareTypeQQ,
    ShareTypeQQZone
} ShareType;
typedef void(^Completion)(NSString *error);
@interface ShareTool : NSObject
/**
 初始化
 */
+(void)shareInit;
+(void)shareTo:(ShareType)type imageUrl:(NSString *)imageUrl title:(NSString *)title subTitle:(NSString *)subTitle completion:(Completion)completion;
+(void)shareType:(ShareType)type url:(NSString *)url title:(NSString *)title subTitle:(NSString *)subTitle completion:(Completion)completion;
/**
 系统分享
 */
+(void)shareSystem:(NSString *)title url:(NSString *)url completion:(Completion)completion;
+(BOOL)handleOpenURL:(NSURL *)url;
@end

NS_ASSUME_NONNULL_END
