//
//  UserModel.m
//  novel
//
//  Created by 黎铭轩 on 15/7/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
+ (instancetype)viewControllerWithState:(UserState)state rankDatas:(NSArray *)rankDatas{
    UserModel *userModel=[[UserModel alloc]init];
    userModel.state=state;
    userModel.rankDatas=rankDatas;
    return userModel;
}
@end
