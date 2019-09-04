//
//  UserManager.h
//  novel
//
//  Created by 黎铭轩 on 15/7/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@class UserModel;
@interface UserManager : NSObject
@property (strong, nonatomic)UserModel *user;
/**
 *用户实例
 */
+(instancetype)shareInstance;
/**
 *是否选择
 */
+(BOOL)alreadySelect;
/**
 *写入当前用户
 */
+(BOOL)saveUserModel:(UserModel *)user;
+(void)reloadHomeData:(LoadDataState)option;
/**
 *刷新首页数据
 */
+(void)reloadHomeDataNeed:(void(^)(LoadDataState option))completion;
@end

NS_ASSUME_NONNULL_END
