//
//  RankModel.m
//  novel
//
//  Created by 黎铭轩 on 15/7/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "RankModel.h"
#import "UserManager.h"
#import "UserModel.h"
@implementation RankModel

@end
@implementation RankInfo
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"listBoys" : RankModel.class,
             @"listGirls" : RankModel.class,
             @"epub" : RankModel.class,
             @"picture" : RankModel.class,
             };
}

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"listBoys" : @"male",
             @"listGirls" : @"female"};
}
- (void)setState:(UserState)state{
    if (_state != state) {
        _state = state;
        self.listData = (_state == UserBoy) ? self.listBoys : self.listGirls;
    }
}
- (void)setListBoys:(NSArray<RankModel *> *)listBoys{
    NSArray *listData= [UserManager shareInstance].user.rankDatas;
    if (listData) {
        [listData enumerateObjectsUsingBlock:^(RankModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSPredicate *pre1 = [NSPredicate predicateWithFormat:@"_id IN%@",obj._id?:@""];
            RankModel *model  = [listBoys filteredArrayUsingPredicate:pre1].firstObject;
            model.select = YES;
        }];
    }
    _listBoys = listBoys;
}
- (void)setListGirls:(NSArray<RankModel *> *)listGirls{
    NSArray *listData= [UserManager shareInstance].user.rankDatas;
    if (listData) {
        [listData enumerateObjectsUsingBlock:^(RankModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSPredicate *pre1 = [NSPredicate predicateWithFormat:@"_id IN%@",obj._id?:@""];
            RankModel *model  = [listGirls filteredArrayUsingPredicate:pre1].firstObject;
            model.select = YES;
        }];
    }
    _listGirls = listGirls;
}
@end
