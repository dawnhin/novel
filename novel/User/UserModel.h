//
//  UserModel.h
//  novel
//
//  Created by 黎铭轩 on 15/7/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "BaseModel.h"
#import "RankModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UserModel : BaseModel
@property (assign, nonatomic)UserState state;
@property (strong, nonatomic)NSArray<RankModel *> *rankDatas;

+(instancetype)viewControllerWithState:(UserState)state rankDatas:(NSArray *)rankDatas;
@end

NS_ASSUME_NONNULL_END
