//
//  HomeViewController.m
//  novel
//
//  Created by 黎铭轩 on 16/7/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "HomeViewController.h"
#import "GKBookReadDataQueue.h"
#import "JumpApp.h"
#import "RankModel.h"
#import "UserModel.h"
#import "GKHomeNetManager.h"
#import "GKTimeTool.h"
#import "HomeHotCollectionViewCell.h"
#import "UICollectionView+ARDynamicCacheHeightLayoutCell.h"
#import "HomeCollectionReusableView.h"
#import <CategoryKit.h>
#import "HomeMoreTableViewController.h"
@interface HomeViewController ()
@property (strong, nonatomic)UIButton *tipButton;
@property (assign, nonatomic)LoadDataState option;
@property (strong, nonatomic)NSArray<GKBookInfo *> *listData;
@property (strong, nonatomic)GKHomeNetManager *homeManager;
@property (strong, nonatomic)GKBookInfo *bookInfo;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
    [self loadData];
}
-(void)loadUI{
    [self setNavRightItemWithImage:[UIImage imageNamed:@"icon_nav_add"] action:@selector(addAction)];
    [self.view addSubview:self.tipButton];
    [self.tipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
    }];
}
-(void)addAction{
    [JumpApp jumpToAddSelect];
}
-(void)loadData{
    self.option=LoadDataDefault;
    __weak typeof(self)WeakSelf=self;
    [UserManager reloadHomeDataNeed:^(LoadDataState option) {
        self.option=option;
        [WeakSelf headerRefreshing];
    }];
    [self setupEmpty:self.collectionView image:[UIImage imageNamed:@"icon_data_empty"] title:@"数据空空如也...\n\r请点击右上角进行添加"];
    [self setupRefresh:self.collectionView option:ATRefreshDefault];
}

- (void)setOption:(LoadDataState)option{
    _option=option;
    if (option & LoadDataDataBase) {
        __weak typeof(self)WeakSelf=self;
        [GKBookReadDataQueue getDatasFromDataBase:1 pageSize:10 completion:^(NSArray<GKBookReadModel *> * _Nonnull listData) {
            [WeakSelf setTipModel: listData.firstObject];
        }];
    }
}
- (void)refreshData:(NSInteger)page{
    NSArray <RankModel *> *listData=[UserManager shareInstance].user.rankDatas;
    __weak typeof(self)WeakSelf=self;
    [self.homeManager homeNet:listData loadData:self.option success:^(NSArray<GKBookInfo *> * _Nonnull datas) {
        WeakSelf.listData=datas;
        [WeakSelf.collectionView reloadData];
        [WeakSelf endRefresh:NO];
    } failure:^(NSString * _Nonnull error) {
        if (!WeakSelf.reachable) {
            [WeakSelf endRefreshFailure];
        }
        else{
            WeakSelf.listData=@[];
            [WeakSelf.collectionView reloadData];
            [WeakSelf endRefresh:NO];
        }
    }];
}
-(void)setTipModel:(GKBookReadModel *)model{
    self.tipButton.hidden = !model;
    NSString *title=[NSString stringWithFormat: @"最近一次阅读:%@ %@",model.bookModel.title ?: @"",[GKTimeTool timeStampTurnToTimesType:model.updateTime]];
    [self.tipButton setTitle:title forState:UIControlStateNormal];
    [self.tipButton setBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
    }];
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
    return self.listData.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    GKBookInfo *bookInfo=self.listData[section];
    return bookInfo.listData.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeHotCollectionViewCell *cell=[HomeHotCollectionViewCell cellForCollectionView:collectionView indexPath:indexPath];
    GKBookInfo *info=self.listData[indexPath.section];
    GKBookModel *model=info.listData[indexPath.row];
    if ([model isKindOfClass:[GKBookModel class]]) {
        cell.model=model;
    }
    else if ([model isKindOfClass: [GKBookReadModel class]]){
        GKBookReadModel *info=(GKBookReadModel *)model;
        cell.model=info.bookModel;
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GKBookInfo *info=self.listData[indexPath.section];
    GKBookModel *model=info.listData[indexPath.row];
    if ([model isKindOfClass:[GKBookModel class]]) {
        [JumpApp jumpToBookDetail:model._id];
    }
    else if ([model isKindOfClass:[GKBookReadModel class]]){
        GKBookReadModel *info=(GKBookReadModel *)model;
        [JumpApp jumpToBookDetail:info.bookModel._id];
    }
}
-(void)clickMore{
    if ([self.bookInfo.listData.firstObject isKindOfClass:[GKBookDetailInfo class]]) {
        [JumpApp jumpToBookCase];
    }
    else if ([self.bookInfo.listData.firstObject isKindOfClass:[GKBookModel class]]){
        HomeMoreTableViewController *viewController=[[HomeMoreTableViewController alloc]init];
        viewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else{
        [JumpApp jumpToBookHistory];
    }
}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    GKBookInfo *info=self.listData[indexPath.section];
//    GKBookModel *model=info.listData[indexPath.row];
//    return [collectionView ar_sizeForCellWithIdentifier:NSStringFromClass([HomeHotCollectionViewCell class]) indexPath:indexPath fixedWidth:(SCREEN_WIDTH-4*AppTop)/3 configuration:^(__kindof HomeHotCollectionViewCell *cell) {
//        if ([model isKindOfClass:[GKBookModel class]]) {
//            cell.model=model;
//        }
//        else if ([model isKindOfClass:[GKBookReadModel class]]){
//            GKBookReadModel *info=(GKBookReadModel *)model;
//            cell.model=info.bookModel;
//        };
//    }];
//}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREEN_WIDTH-4*AppTop)/3, 200);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return AppTop;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return AppTop;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(AppTop, AppTop, AppTop, AppTop);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    HomeCollectionReusableView *reusableView=[HomeCollectionReusableView viewForCollectionView:collectionView elementKind:kind indexPath:indexPath];
    GKBookInfo *info=self.listData[indexPath.section];
    self.bookInfo=info;
    if ([info isKindOfClass:[GKBookInfo class]]) {
        reusableView.title.text=info.shortTitle ?: @"";
        reusableView.moreButton.hidden=!info.moreData;
        [reusableView.moreButton addTarget:self action:@selector(clickMore) forControlEvents:UIControlEventTouchUpInside];
    }
    return reusableView;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, self.listData[section].listData.count ? (section == 0 ? 50:30) : 0.01);
}
- (UIButton *)tipButton{
    if (!_tipButton) {
        [_tipButton setBackgroundColor:[UIColor colorWithRGB:0xf5f5f5]];
        _tipButton.titleLabel.font=[UIFont systemFontOfSize:12];
        [_tipButton setTitleColor:AppColor forState:UIControlStateNormal];
        [_tipButton setContentEdgeInsets:UIEdgeInsetsMake(2, 5, 2, 5)];
        _tipButton.titleLabel.numberOfLines=0;
    }
    return _tipButton;
}
- (GKHomeNetManager *)homeManager{
    if (!_homeManager) {
        _homeManager=[[GKHomeNetManager alloc]init];
    }
    return _homeManager;
}
@end
