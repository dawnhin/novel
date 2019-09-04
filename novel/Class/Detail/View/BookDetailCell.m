//
//  BookDetailCell.m
//  novel
//
//  Created by 黎铭轩 on 16/8/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "BookDetailCell.h"
#import "UIImageView+GKLoad.h"
#import "GKBookDetailModel.h"
@implementation BookDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.moreButton.layer.cornerRadius=10;
    self.moreButton.layer.masksToBounds=YES;
    self.stateButton.layer.cornerRadius=10;
    self.moreButton.layer.masksToBounds=YES;
    [self.moreButton setBackgroundColor:AppColor];
    self.nickNameLabel.textColor=AppColor;
}
- (void)setModel:(GKBookDetailModel *)model{
    if (_model!=model) {
        _model=model;
        [self.imageView setGkImageWithURL:model.cover];
        self.contentLabel.text=model.longIntro ?: @"";
        self.titleLabel.text=[NSString stringWithFormat: @"%@(%@)",model.title ?: @"",model.isSerial ? @"完结":@"连载"];
        self.nickNameLabel.text=model.author ?: @"";
        self.subTitleLabel.text=model.minorCate ?: @"";
        self.wordLabel.text=[NSString stringWithFormat: @"字数:%ld",model.wordCount];
        self.detailTitleLabel.text=[NSString stringWithFormat: @"章节数:%ld",model.chaptersCount];
        [self.moreButton setTitle:[NSString stringWithFormat:@"关注度:%.2f%@",model.retentionRatio,@"%"] forState:UIControlStateNormal];
        [self.stateButton setTitle:model.majorCate forState:UIControlStateNormal];
    }
}
+ (CGFloat)heightForWidth:(CGFloat)width model:(GKBookDetailModel *)model{
    if (model.height > 0) {
        return model.height;
    }
    static BookDetailCell *cell;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell=[[NSBundle mainBundle] loadNibNamed:@"BookDetailCell" owner:nil options:nil][0];
    });
    cell.model=model;
    NSLayoutConstraint *widthConstraint=[NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:width];
    [cell.contentView addConstraint:widthConstraint];
    CGFloat height=[cell.contentView systemLayoutSizeFittingSize: UILayoutFittingExpandedSize].height;
    [cell.contentView removeConstraint:widthConstraint];
    return height;
}
@end
