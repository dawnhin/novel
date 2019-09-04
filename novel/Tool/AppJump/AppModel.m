//
//  AppModel.m
//  novel
//
//  Created by 黎铭轩 on 15/7/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "AppModel.h"
static NSString *Theme=@"Theme";
@implementation AppModel

@end
@interface AppTheme()
@property (assign, nonatomic)ThemeState themeState;
@end
@implementation AppTheme
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSData *data=[[NSUserDefaults standardUserDefaults] objectForKey:Theme];
        _model=data ? [BaseModel unarchiveForData:data]:nil;
    }
    return self;
}
+ (instancetype)shareInstance{
    static AppTheme *dataBase;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!dataBase) {
            dataBase=[[AppTheme alloc]init];
        }
    });
    return dataBase;
}
- (void)setThemeState:(ThemeState)themeState{
    if (!_model) {
        NSString *path=[[NSBundle mainBundle] pathForResource:@"App" ofType:@"plist"];
        NSDictionary *dictionary=[NSDictionary dictionaryWithContentsOfFile:path];
        NSString *title=@"too_blue";
        switch (themeState) {
            case ThemeDefault:
                title=@"too_blue";
                break;
            case ThemeTooHouse:
                title=@"too_house";
                break;
            case ThemeTooGold:
                title=@"too_gold";
                break;
            case ThemeTooZi:
                title=@"too_zi";
                break;
            case ThemeTooFen:
                title=@"too_fen";
                break;
            default:
                break;
        }
        _model=[AppModel modelWithJSON:dictionary[title]];
    }
}
+ (BOOL)saveAppTheme:(AppModel *)appModel{
    [AppTheme shareInstance].model=appModel;
    BOOL res=NO;
    NSData *userData=[BaseModel archivedDataForData:appModel];
    if (userData) {
        [[NSUserDefaults standardUserDefaults] setObject:userData forKey:Theme];
        res=[[NSUserDefaults standardUserDefaults]synchronize];
    }
    return res;
}
- (AppModel *)model{
    if (!_model) {
        _model=[[AppModel alloc]init];
        _model.color=@"66A2F9";
        _model.icon_mine_h=@"icon_mine_h";
        _model.icon_mine_n=@"icon_mine_n";
        _model.icon_case_h=@"icon_case_h";
        _model.icon_case_n=@"icon_case_n";
        _model.icon_home_h=@"icon_home_h";
        _model.icon_home_n=@"icon_home_n";
        _model.icon_class_h=@"icon_class_h";
        _model.icon_class_n=@"icon_class_n";
        _model.icon_more=@"icon_more";
        _model.icon_man=@"icon_man";
    }
    return _model;
}
@end
