//
//  JumpApp.h
//  novel
//
//  Created by 黎铭轩 on 15/7/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class GKBookDetailModel;
@interface JumpApp : NSObject
/** 跳转引导页*/
+(void)jumpToAppGuidePage:(void(^)(void))completion;
/** 跳转主题页*/
+ (void)jumpToAppTheme;
/** 跳转选择页*/
+(void)jumpToAddSelect;
/** 跳转列表页*/
+(void)jumptoBookRead:(GKBookDetailModel *)model;
+(void)jumpToBookCase;
+(void)jumpToBookHistory;
/** 跳转详情页*/
+(void)jumpToBookDetail:(NSString *)bookID;
@end

NS_ASSUME_NONNULL_END
