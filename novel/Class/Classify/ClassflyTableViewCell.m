//
//  ClassflyTableViewCell.m
//  novel
//
//  Created by 黎铭轩 on 10/8/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "ClassflyTableViewCell.h"
#import "UIImageView+GKLoad.h"
#import "GKBookModel.h"
@implementation ClassflyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.focusButton.layer.cornerRadius=10;
    self.focusButton.layer.masksToBounds=YES;
    self.stateButton.layer.cornerRadius=7.5;
    self.stateButton.layer.masksToBounds=YES;
    [self.focusButton setBackgroundImage:[UIImage imageWithColor:AppColor] forState:UIControlStateNormal];
    self.width.constant=SCALEW(80);
    self.nickNameLabel.textColor=AppColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(GKBookModel *)model{
    [self.image setGkImageWithURL:model.cover];
    self.titleLabel.text=model.title;
    self.subTitleLabel.text=model.shortIntro;
    self.nickNameLabel.text=model.author;
    self.MonthLabel.text=[NSString stringWithFormat: @"%ld",model.latelyFollower];
    [self.focusButton setTitle:[NSString stringWithFormat:@"关注度:%.2f%@",model.retentionRatio,@"%"] forState:UIControlStateNormal];
    [self.stateButton setTitle:model.majorCate forState:UIControlStateNormal];
}
@end
