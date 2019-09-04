//
//  MineSelectController.m
//  novel
//
//  Created by 黎铭轩 on 2/8/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "MineSelectController.h"
#import "HomeCollectionReusableView.h"
#import "StartCollectionViewCell.h"
#import "UserModel.h"
#import <AppBaseCategory/ATImageTopButton.h>
@interface MineSelectController ()
@property (strong, nonatomic)UIButton *sureButton;
@property (strong, nonatomic)RankInfo *rankInfo;
@end

@implementation MineSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showNavTitle:@"首页数据"];
    [self.view addSubview:self.sureButton];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(45);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    [self setupEmpty:self.collectionView];
    [self setupRefresh:self.collectionView option:ATRefreshNone];
}
- (void)refreshData:(NSInteger)page{
    [NovelNetManager rankSuccess:^(id  _Nonnull object) {
        self.rankInfo=[RankInfo modelWithJSON:object];
        self.rankInfo.state=[UserManager shareInstance].user.state;
        [self.collectionView reloadData];
    } failure:^(NSString * _Nonnull error) {
        [self endRefreshFailure];
    }];
}
-(void)sureAction{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.rankInfo.listData.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    StartCollectionViewCell *cell=[StartCollectionViewCell cellForCollectionView:collectionView indexPath:indexPath];
    RankModel *model=self.rankInfo.listData[indexPath.row];
    cell.model=model;
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width=(SCREEN_WIDTH-4*20)/3;
    CGFloat height=40;
    return CGSizeMake(width, height);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(20, 20, 20, 20);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 20;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, 45);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    HomeCollectionReusableView *reusable=[HomeCollectionReusableView viewForCollectionView:collectionView elementKind:kind indexPath:indexPath];
    reusable.moreButton.hidden=YES;
    reusable.title.text=@"选择几个项目作为首页数据";
    return reusable;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    RankModel *model=self.rankInfo.listData[indexPath.row];
    model.select = !model.select;
    [collectionView reloadData];
}
- (UIButton *)sureButton{
    if (!_sureButton) {
        _sureButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton setTitleColor:Appxffffff forState:UIControlStateNormal];
        [_sureButton setBackgroundColor:AppColor];
        [_sureButton addTarget:self action:@selector(sureButton) forControlEvents:UIControlEventTouchUpInside];
        _sureButton.layer.cornerRadius=AppRadius;
        _sureButton.layer.masksToBounds=YES;
    }
    return _sureButton;
}
@end
