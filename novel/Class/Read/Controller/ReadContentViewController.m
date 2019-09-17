//
//  ReadContentViewController.m
//  novel
//
//  Created by 黎铭轩 on 4/9/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "ReadContentViewController.h"
#import "ReadView.h"
#import "GKReadSetManager.h"
@interface ReadContentViewController()
@property (assign, nonatomic)NSInteger pageIndex;
@property (assign, nonatomic)NSInteger chapterIndex;
@property (strong, nonatomic)ReadView *readView;
@property (strong, nonatomic)UILabel *titleLabel;
@property (strong, nonatomic)UILabel *bookNameLabel;
@property (strong, nonatomic)UILabel *selectLabel;
@end
@implementation ReadContentViewController
- (void)setCurrentPage:(NSInteger)currentPage totalPage:(NSInteger)totalPage chapter:(NSInteger)chapter title:(NSString *)title bookName:(NSString *)bookName content:(NSAttributedString *)content{
    self.pageIndex=currentPage;
    self.chapterIndex=chapter;
    self.readView.content=content;
    self.titleLabel.text=title;
    self.bookNameLabel.text=bookName ?: @"";
    if (currentPage==totalPage) {
        currentPage=totalPage;
    }
    else{
        currentPage++;
    }
    self.selectLabel.text=[NSString stringWithFormat: @"%ld/%ld",currentPage,totalPage];
    self.selectLabel.textColor=[GKReadSetManager shareInstance].model.color;
    self.titleLabel.textColor=[GKReadSetManager shareInstance].model.color;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    //必须透明，否则背景颜色不生效
    self.view.backgroundColor=[UIColor clearColor];
    [self loadUI];
}
-(void)loadUI{
    [self.view addSubview:self.readView];
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(AppTop);
        make.top.equalTo(self.view).offset(STATUS_BAR_HIGHT);
    }];
    [self.view addSubview:self.bookNameLabel];
    [self.bookNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-AppTop);
        make.centerY.equalTo(self.titleLabel);
        make.left.equalTo(self.titleLabel.mas_right).offset(10);
    }];
    [self.titleLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.view addSubview:self.selectLabel];
    [self.selectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(-TAB_BAR_ADDING-10);
    }];
}
- (ReadView *)readView{
    if (!_readView) {
        _readView=[[ReadView alloc] initWithFrame:AppReadContent];
        _readView.backgroundColor=[UIColor clearColor];
    }
    return _readView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel=[[UILabel alloc] init];
        _titleLabel.textAlignment=NSTextAlignmentLeft;
        _titleLabel.textColor=Appx999999;
        _titleLabel.font=[UIFont systemFontOfSize:12];
    }
    return _titleLabel;
}
- (UILabel *)bookNameLabel{
    if (!_bookNameLabel) {
        _bookNameLabel=[[UILabel alloc]init];
        _bookNameLabel.textAlignment=NSTextAlignmentRight;
        _bookNameLabel.textColor=Appx999999;
        _bookNameLabel.font=[UIFont systemFontOfSize:12];
    }
    return _bookNameLabel;
}
- (UILabel *)selectLabel{
    if (!_selectLabel) {
        _selectLabel=[[UILabel alloc]init];
        _selectLabel.textAlignment=NSTextAlignmentCenter;
        _selectLabel.textColor=Appx999999;
        _selectLabel.font=[UIFont systemFontOfSize:14];
    }
    return _selectLabel;
}
@end
