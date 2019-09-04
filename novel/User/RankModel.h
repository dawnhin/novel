//
//  RankModel.h
//  novel
//
//  Created by 黎铭轩 on 15/7/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RankModel : BaseModel
@property (strong, nonatomic)NSString *_id;
@property (strong, nonatomic)NSString *collapse;
@property (strong, nonatomic)NSString *cover;
@property (strong, nonatomic)NSString *monthRank;
@property (strong, nonatomic)NSString *shortTitle;
@property (strong, nonatomic)NSString *title;
@property (strong, nonatomic)NSString *totalRank;
@property (assign, nonatomic)BOOL select;
@property (assign, nonatomic)NSInteger rankSort;
@end

@interface RankInfo : BaseModel
@property (assign, nonatomic)UserState state;
@property (strong, nonatomic)NSArray<RankModel *> *listBoys;
@property (strong, nonatomic)NSArray<RankModel *> *listGirls;
@property (strong, nonatomic)NSArray<RankModel *> *pictures;
@property (strong, nonatomic)NSArray<RankModel *> *listData;
@property (strong, nonatomic)NSArray<RankModel *> *epub;
@end
NS_ASSUME_NONNULL_END
