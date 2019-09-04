//
//  HomeHotCollectionViewCell.h
//  novel
//
//  Created by 黎铭轩 on 6/8/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeHotCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic)UIImageView *imageView;
@property (strong, nonatomic)UIButton *tagButton;
@property (strong, nonatomic)UIButton *deleteButton;
@property (strong, nonatomic)UILabel *titleLabel;
@property (strong, nonatomic)id model;
@end

NS_ASSUME_NONNULL_END
