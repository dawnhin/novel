//
//  ClassItemViewController.m
//  novel
//
//  Created by 黎铭轩 on 29/8/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "ClassItemViewController.h"
#import "GKClassItemModel.h"
#import "HomeHotCollectionViewCell.h"
#import "ClassflyViewController.h"
@interface ClassItemViewController ()
@property (strong, nonatomic)NSArray *listData;
@end

static NSString *identifier=@"HomeHotCollectionViewCell";
@implementation ClassItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupEmpty:self.collectionView];
//    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeHotCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:identifier];
    [self setupRefresh:self.collectionView option:ATRefreshDefault];
}

- (void)setTitleName:(NSString *)titleName{
    if (_titleName!=titleName) {
        _titleName=titleName;
    }
}

- (void)refreshData:(NSInteger)page{
    [NovelNetManager homeClass:self.titleName success:^(id  _Nonnull object) {
        self.listData=[NSArray modelArrayWithClass:[GKClassItemModel class] json:object];
        [self.collectionView reloadData];
//        [self endRefresh:NO];
    } failure:^(NSString * _Nonnull error) {
        [self endRefreshFailure];
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
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.listData.count;
}
//- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
//    HomeHotCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
//    cell.model=self.listData[indexPath.row];
//    cell.backgroundColor=[UIColor redColor];
//    return cell;
//}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeHotCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.model=self.listData[indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GKClassItemModel *model=self.listData[indexPath.row];
    ClassflyViewController *viewController=[ClassflyViewController viewControllerWithGroup:self.titleName name:model.name];
    [self.navigationController pushViewController:viewController animated:YES];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [collectionView ar_sizeForCellWithClassCell:[HomeHotCollectionViewCell class] indexPath:indexPath fixedValue:(SCREEN_WIDTH-4*AppTop)/3  configuration:^(__kindof HomeHotCollectionViewCell *cell) {
        cell.model=self.listData[indexPath.row];
    }];
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return AppTop;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return AppTop;
}
@end
