//
//  ThemeTableViewCell.m
//  novel
//
//  Created by 黎铭轩 on 5/8/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "ThemeTableViewCell.h"

@implementation ThemeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(AppModel *)model{
    self.image.image=[UIImage imageWithColor:[UIColor colorWithHexString:model.color]];
    self.title.text=model.title ?: @"";
    AppModel *modelq=[AppTheme shareInstance].model;
    self.imageIcon.hidden=![model.title isEqualToString: modelq.title];
}
@end
