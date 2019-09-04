//
//  StartCollectionViewCell.h
//  novel
//
//  Created by 黎铭轩 on 17/7/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RankModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, StartState) {
    StartStateDefault=0,
    StartStateBack,
    StartStateBoard,
};
@interface StartCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic)RankModel *model;
+(instancetype)cellForCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath state:(StartState)state;
@end

NS_ASSUME_NONNULL_END
