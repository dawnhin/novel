//
//  AppModel.h
//  novel
//
//  Created by 黎铭轩 on 15/7/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, ThemeState) {
    ThemeDefault=0,
    ThemeTooHouse,
    ThemeTooGold,
    ThemeTooZi,
    ThemeTooFen
};
@interface AppModel : BaseModel
@property (strong, nonatomic)NSString *title;
@property (strong, nonatomic)NSString *color;
@property (strong, nonatomic) NSString *icon_case_h;
@property (strong, nonatomic) NSString *icon_case_n;
@property (strong, nonatomic) NSString *icon_class_h;
@property (strong, nonatomic) NSString *icon_class_n;
@property (strong, nonatomic) NSString *icon_home_h;
@property (strong, nonatomic) NSString *icon_home_n;
@property (strong, nonatomic) NSString *icon_mine_h;
@property (strong, nonatomic) NSString *icon_mine_n;
@property (strong, nonatomic) NSString *icon_more;
@property (strong, nonatomic) NSString *icon_man;
@end
@interface AppTheme : NSObject
@property (strong, nonatomic)AppModel *model;
+(instancetype)shareInstance;
+(BOOL)saveAppTheme:(AppModel *)appModel;
@end
NS_ASSUME_NONNULL_END
