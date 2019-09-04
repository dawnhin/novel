//
//  UserManager.m
//  novel
//
//  Created by 黎铭轩 on 15/7/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "UserManager.h"
#import "UserModel.h"
static NSString *userinfo=@"userinfo";
@interface UserManager()
@property (strong, nonatomic)void(^completion)(LoadDataState option);
@end
@implementation UserManager
+ (instancetype)shareInstance{
    static UserManager *_shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_shareInstance) {
            _shareInstance=[[[self class] alloc] init];
        }
    });
    return _shareInstance;
}
+ (BOOL)alreadySelect{
    return [[NSUserDefaults standardUserDefaults] objectForKey:userinfo];
}
+ (BOOL)saveUserModel:(UserModel *)user{
    [UserManager shareInstance].user=user;
    BOOL res=NO;
    NSData *userData=[BaseModel archivedDataForData:user];
    if (userData) {
        [[NSUserDefaults standardUserDefaults]setObject:userData forKey:userinfo];
        res=[[NSUserDefaults standardUserDefaults] synchronize];
    }
    return res;
}
+ (void)reloadHomeData:(LoadDataState)option{
    ![UserManager shareInstance].completion ?: [UserManager shareInstance].completion(option);
}
+ (void)reloadHomeDataNeed:(void (^)(LoadDataState option))completion{
    [UserManager shareInstance].completion=completion;
}
#pragma mark - 获取当前用户
- (UserModel *)user{
    if (!_user) {
        NSData *data=[[NSUserDefaults standardUserDefaults] objectForKey:userinfo];
        _user=data ? [BaseModel unarchiveForData:data]:nil;
    }
    return _user;
}
@end
