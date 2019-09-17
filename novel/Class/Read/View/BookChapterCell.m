//
//  BookChapterCell.m
//  novel
//
//  Created by 黎铭轩 on 7/9/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "BookChapterCell.h"
@interface BookChapterCell()
@property (strong, nonatomic)UIView *lineView;
@end
@implementation BookChapterCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.image];
        [self.contentView addSubview:self.lineView];
    }
    return self;
}
- (void)layoutSubviews{
    //布局title
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(12);
        make.bottom.mas_greaterThanOrEqualTo(-12);
        make.right.equalTo(self.image.mas_left).offset(5);
    }];
    //布局image
    [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.contentView);
        make.width.height.mas_equalTo(25);
    }];
    //布局lineView
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.6);
        make.left.equalTo(self.title.mas_left);
    }];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(GKBookSourceModel *)model{
    self.title.text=model.name ?: @"";
}
- (UILabel *)title{
    if (!_title) {
        _title=[[UILabel alloc] init];
        _title.font=[UIFont systemFontOfSize:14];
        _title.textColor=[UIColor lightGrayColor];
    }
    return _title;
}
- (UIImageView *)image{
    if (!_image) {
        _image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_select"]];
    }
    return _image;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView=[[UIView alloc]init];
        _lineView.backgroundColor=[UIColor lightGrayColor];
    }
    return _lineView;
}
@end
