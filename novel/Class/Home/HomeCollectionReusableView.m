//
//  HomeCollectionReusableView.m
//  novel
//
//  Created by 黎铭轩 on 18/7/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "HomeCollectionReusableView.h"
#import <AppBaseCategory/ATImageTopButton.h>
@implementation HomeCollectionReusableView
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.baseline.equalTo(self).offset(-5);
    }];
    [self addSubview:self.moreButton];
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title.mas_right).offset(10);
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self.title.mas_baseline);
    }];
}
- (UILabel *)title{
    if (!_title) {
        _title=[[UILabel alloc]init];
        _title.font=[UIFont systemFontOfSize:28 weight:UIFontWeightHeavy];
        _title.textColor=Appx252631;
    }
    return _title;
}
- (ATImageRightButton *)moreButton{
    if (!_moreButton) {
        _moreButton=[ATImageRightButton buttonWithType:UIButtonTypeCustom];
        AppModel *model=[AppTheme shareInstance].model;
        [_moreButton setTitle:@"更多" forState:UIControlStateNormal];
        [_moreButton setImage:[UIImage imageNamed:model.icon_more] forState:UIControlStateNormal];
        _moreButton.imageMarning=0;
        _moreButton.titleLabel.font=[UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        [_moreButton setTitleColor:AppColor forState:UIControlStateNormal];
    }
    return _moreButton;
}
@end
