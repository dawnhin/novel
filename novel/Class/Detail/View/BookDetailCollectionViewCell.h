//
//  BookDetailCollectionViewCell.h
//  novel
//
//  Created by 黎铭轩 on 27/8/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKBookDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BookDetailCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *counLabel;
@property (weak, nonatomic) IBOutlet UIButton *collectionButton;
@property (strong, nonatomic) GKBookListModel *model;
@end

NS_ASSUME_NONNULL_END
