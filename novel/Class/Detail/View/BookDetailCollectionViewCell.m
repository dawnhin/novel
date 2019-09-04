//
//  BookDetailCollectionViewCell.m
//  novel
//
//  Created by 黎铭轩 on 27/8/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "BookDetailCollectionViewCell.h"
#import "UIImageView+GKLoad.h"
@implementation BookDetailCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.collectionButton.layer.cornerRadius=AppRadius;
    self.collectionButton.layer.masksToBounds=YES;
    [self.counLabel setTextColor:AppColor];
    [self.collectionButton setBackgroundColor:AppColor];
}
- (void)setModel:(GKBookListModel *)model{
    if (_model != model) {
        _model = model;
        [self.imageView setGkImageWithURL:model.cover];
        self.titleLabel.text=model.title ?: @"";
        self.subTitleLabel.text=model.desc ?: @"";
        self.counLabel.text=[NSString stringWithFormat: @"%ld本书",model.bookCount];
        [self.collectionButton setTitle:[NSString stringWithFormat: @"%ld人收藏",model.collectorCount] forState:UIControlStateNormal];
    }
}
@end
