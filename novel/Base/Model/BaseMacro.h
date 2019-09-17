//
//  BaseMacro.h
//  novel
//
//  Created by 黎铭轩 on 15/7/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppModel.h"
#define AppColor                 [UIColor colorWithHexString:[AppTheme shareInstance].model.color]
#define Appx252631               [UIColor colorWithRGB:0x252631]
#define Appxdddddd               [UIColor colorWithRGB:0xDDDDDD]
#define Appx000000               [UIColor colorWithRGB:0x000000]
#define Appx333333               [UIColor colorWithRGB:0x333333]
#define Appx666666               [UIColor colorWithRGB:0x666666]
#define Appx999999               [UIColor colorWithRGB:0x999999]
#define Appxf8f8f8               [UIColor colorWithRGB:0xf8f8f8]
#define Appxffffff               [UIColor colorWithRGB:0xffffff]
#define AppRadius                4.0f
#define AppLineHeight            0.60f
#define AppTop                   15.0f

#define RefreshPageStart (1)
#define RefreshPageSize (35)
#define BaseUrl  @"https://api.zhuishushenqi.com/"
#define BaseUrlIcon  @"https://statics.zhuishushenqi.com"
#define kBaseUrl(url)  [NSString stringWithFormat:@"%@%@", BaseUrl, url]
#define kBaseUrlIcon(url)  [NSString stringWithFormat:@"%@%@", BaseUrlIcon, url]
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, UserState) {
    UserBoy=1,
    UserGirl,
};
#define WChatAppKey              @"wx4105c558f6bb1bd1"//微信平台appKey
#define QQAppKey                 @"1109550572" //设置QQ平台的appID
typedef NS_ENUM(NSInteger, LoadDataState) {
    LoadDataNone    =  0,
    LoadDataNetData =  1 << 1,
    LoadDataDataBase=  1 << 2,
    LoadDataDefault = (LoadDataNetData|LoadDataDataBase),
};
#define AppReadContent CGRectMake(AppTop, STATUS_BAR_HIGHT + 40, SCREEN_WIDTH - 30, SCREEN_HEIGHT - STATUS_BAR_HIGHT - TAB_BAR_ADDING - 30 - 40)
@interface BaseMacro : NSObject
+ (NSArray *)hotDatas;
@end

NS_ASSUME_NONNULL_END
