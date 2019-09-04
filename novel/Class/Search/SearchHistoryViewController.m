//
//  SearchHistoryViewController.m
//  novel
//
//  Created by 黎铭轩 on 2/9/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "SearchHistoryViewController.h"
#import "SearchTextView.h"
#import "GKSearchDataQueue.h"
#import "StartCollectionViewCell.h"
#import "HomeCollectionReusableView.h"
#import <AppBaseCategory/ATImageTopButton.h>
@interface SearchHistoryViewController ()
@property (strong, nonatomic)NSMutableArray *searchDatas;
@property (strong, nonatomic)SearchTextView *searchView;
@property (strong, nonatomic)NSArray *listDatas;
@end
static NSString * const identifier=@"StartCollectionViewCell";
@implementation SearchHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.fd_prefersNavigationBarHidden=YES;
    [self.view addSubview:self.searchView];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(NAVI_BAR_HIGHT);
    }];
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.searchView.mas_bottom);
    }];
    [self.collectionView registerNib:[UINib nibWithNibName:@"StartCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:identifier];
//    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:@"header" withReuseIdentifier:@"HomeCollectionReusableView"];
    [self setupEmpty:self.collectionView];
    [self setupRefresh:self.collectionView option:ATRefreshDefault];
}
- (void)refreshData:(NSInteger)page{
    NSArray *data=[BaseMacro hotDatas];
    [GKSearchDataQueue getDatasFromDataBase:page pageSize:RefreshPageSize completion:^(NSArray<NSString *> * _Nonnull listData) {
        if (page == RefreshPageStart) {
            [self.searchDatas removeAllObjects];
        }
        listData.count ? [self.searchDatas addObjectsFromArray:listData] : nil;
        NSInteger index=arc4random()%(data.count-6);
        self.listDatas=[data subarrayWithRange:NSMakeRange(index, 6)];
        [self.collectionView reloadData];
        [self endRefresh:listData.count>=RefreshPageSize];
    }];
}
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
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
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return section==0 ? self.listDatas.count:self.searchDatas.count;
};
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    StartCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSArray *listData=indexPath.section==0 ? self.listDatas : self.searchDatas;
    cell.titleLabel.text=listData[indexPath.row];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *listData=indexPath.section == 0 ? self.listDatas : self.searchDatas;
    NSString *title=listData[indexPath.row];
    CGFloat width=[title sizeForFont:[UIFont systemFontOfSize:14] size:CGSizeMake(MAXFLOAT, MAXFLOAT) mode:NSLineBreakByTruncatingTail].width;
    return CGSizeMake(width+20, 30);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    HomeCollectionReusableView *reusableView=[HomeCollectionReusableView viewForCollectionView:collectionView elementKind:kind indexPath:indexPath];
//    [collectionView dequeueReusableSupplementaryViewOfKind:@"header" withReuseIdentifier:@"HomeCollectionReusableView" forIndexPath:indexPath];
    NSArray *listData=indexPath.section == 0 ? self.listDatas : self.searchDatas;
    reusableView.title.font=[UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    reusableView.hidden=listData.count==0;
    if (indexPath.section==0) {
        reusableView.title.text=@"热门词语";
        [reusableView.moreButton setTitle:@"换一换" forState:UIControlStateNormal];
    }
    else{
        reusableView.title.text=@"历史记录";
        [reusableView.moreButton setTitle:@"删除" forState:UIControlStateNormal];
    }
    return reusableView;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, section==0 ? (self.listDatas.count ? 40:0.01):(self.searchDatas.count ? 40:0.01));
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (NSMutableArray *)searchDatas{
    if (!_searchDatas) {
        _searchDatas=[NSMutableArray array];
    }
    return _searchDatas;
}
- (SearchTextView *)searchView{
    if (!_searchView) {
        _searchView=[SearchTextView searchView];
        [_searchView.cancelButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchView;
}
@end
