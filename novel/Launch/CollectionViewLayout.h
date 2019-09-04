//
//  CollectionViewLayout.h
//  novel
//
//  Created by 黎铭轩 on 17/7/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RankModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, LayoutStyle) {
    LayoutStyleTag,
    LayoutStyleCommend,
};
@interface CollectionViewLayout : UICollectionViewFlowLayout
@property (strong, nonatomic)NSArray<RankModel *> *dataArray;
+(instancetype)viewControllerWithStyle:(LayoutStyle)style;
@end

NS_ASSUME_NONNULL_END
