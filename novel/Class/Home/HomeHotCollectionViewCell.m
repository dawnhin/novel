//
//  HomeHotCollectionViewCell.m
//  novel
//
//  Created by 黎铭轩 on 6/8/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "HomeHotCollectionViewCell.h"
#import "GKBookModel.h"
#import "UIImageView+GKLoad.h"
#import "GKClassItemModel.h"
@implementation HomeHotCollectionViewCell
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        UIImageView *imageView=[[UIImageView alloc]init];
        self.imageView=imageView;
        UIButton *tagButton=[[UIButton alloc]init];
        self.tagButton=tagButton;
        UIButton *deleteButton=[[UIButton alloc]init];
        self.deleteButton=deleteButton;
        UILabel *titleLabel=[[UILabel alloc]init];
        titleLabel.font=[UIFont systemFontOfSize:13];
        titleLabel.textAlignment=NSTextAlignmentCenter;
        self.titleLabel=titleLabel;
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.tagButton];
        [self.contentView addSubview:self.deleteButton];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(self.imageView.mas_width).multipliedBy(1.35);
    }];
    [self.tagButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(8);
        make.height.mas_equalTo(20);
    }];
    self.tagButton.layer.cornerRadius=10;
    self.tagButton.layer.masksToBounds=YES;
    [self.tagButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:0x000000 alpha:0.35]] forState:UIControlStateNormal];
    self.tagButton.titleLabel.font=[UIFont systemFontOfSize:10];
    self.tagButton.contentEdgeInsets=UIEdgeInsetsMake(0, 8, 0, 8);
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.imageView.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
}
- (void)setModel:(id)model{
    if ([model isKindOfClass: [GKBookModel class]]) {
        GKBookModel *bookModel=model;
        [self.imageView setGkImageWithURL:bookModel.cover];
        self.titleLabel.text=bookModel.title ?: @"";
        [self.tagButton setTitle:bookModel.majorCate ?: @"" forState:UIControlStateNormal];
    }
    else if ([model isKindOfClass: [GKClassItemModel class]]){
        GKClassItemModel *itemModel=model;
        [self.imageView setGkImageWithURL:itemModel.icon];
        [self.tagButton setTitle: [NSString stringWithFormat: @"月票:%@",itemModel.monthlyCount] forState:UIControlStateNormal];
        self.titleLabel.text=itemModel.name;
    }
}
@end
