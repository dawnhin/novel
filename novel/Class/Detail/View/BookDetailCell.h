//
//  BookDetailCell.h
//  novel
//
//  Created by 黎铭轩 on 16/8/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GKBookDetailModel;
NS_ASSUME_NONNULL_BEGIN

@interface BookDetailCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *wordLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *stateButton;
@property (strong, nonatomic)GKBookDetailModel *model;
+(CGFloat)heightForWidth:(CGFloat)width model:(GKBookDetailModel *)model;
@end

NS_ASSUME_NONNULL_END
