//
//  BookCaseViewController.m
//  novel
//
//  Created by 黎铭轩 on 16/7/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "BookCaseViewController.h"
#import "GKBookCaseDataQueue.h"
#import "HomeHotCollectionViewCell.h"
#import "JumpApp.h"
#import "ATAlertView.h"
@interface BookCaseViewController ()
@property (strong, nonatomic)NSMutableArray *listData;
@property (assign, nonatomic)BOOL needRequest;
@property (assign, nonatomic)BOOL editor;
@end

@implementation BookCaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showNavTitle: @"我的书架"];
    [self setupEmpty:self.collectionView image:[UIImage imageNamed:@"icon_data_empty"] title:@"数据空空如也...\n\r请到书籍详情页收藏你喜欢的书籍吧"];
    [self setupRefresh:self.collectionView option:ATRefreshDefault];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeHotCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeHotCollectionViewCell"];
    self.needRequest=NO;
    UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    [self.collectionView addGestureRecognizer:longPress];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)longPressAction:(UILongPressGestureRecognizer *)recognizer{
    //长按手势位置
    CGPoint point=[recognizer locationInView:self.collectionView];
    //手势位置cell的indexPath
    NSIndexPath *indexPath=[self.collectionView indexPathForItemAtPoint:point];
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:{
            if (!indexPath) {
                break;
            }
            //初始化移动
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
        }
            break;
        case UIGestureRecognizerStateChanged:
            [self.collectionView updateInteractiveMovementTargetPosition:point];
            break;
        case UIGestureRecognizerStateEnded:{
            self.editor=!self.editor;
            [self.collectionView endInteractiveMovement];
            [self.collectionView reloadData];
        }
            break;
        default:
            [self.collectionView cancelInteractiveMovement];
            break;
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.needRequest) {
        [self headerRefreshing];
    }
}
- (void)refreshData:(NSInteger)page{
    [GKBookCaseDataQueue getDatasFromDataBase:page pageSize:RefreshPageSize completion:^(NSArray<GKBookDetailModel *> * _Nonnull listData) {
        if (page == RefreshPageStart) {
            [self.listData removeAllObjects];
        }
        if (listData) {
            [self.listData addObjectsFromArray:listData];
        }
        [self.collectionView reloadData];
        self.listData.count == 0 ? [self endRefreshFailure] : [self endRefresh:listData.count >= RefreshPageSize];
    }];
}
-(void)deleteAction:(GKBookModel *)model{
    [ATAlertView showTitle:[NSString stringWithFormat: @"确定将%@从书架中移除",model.title] message:nil normalButtons:@[@"取消"] highlightButtons:@[@"确定"] completion:^(NSUInteger index, NSString *buttonTitle) {
        if (index==1) {
            [GKBookCaseDataQueue deleteDataToDataBase:model._id completion:^(BOOL success) {
                if (success) {
                    [self.listData removeObject:model];
                    self.editor=NO;
                    [self.collectionView reloadData];
                }
            }];
        }
    }];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.listData.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeHotCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"HomeHotCollectionViewCell" forIndexPath:indexPath];
    GKBookModel *model=self.listData[indexPath.row];
    cell.model=model;
    cell.deleteButton.hidden = !self.editor;
    __weak typeof(self)WeakSelf=self;
    [cell.deleteButton setBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [WeakSelf deleteAction:model];
    }];
    return cell;
}
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.editor;
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    [self.listData exchangeObjectAtIndex:destinationIndexPath.row withObjectAtIndex:sourceIndexPath.row];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    return [UICollectionReusableView viewForCollectionView:collectionView elementKind:kind indexPath:indexPath];
}
#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [collectionView ar_sizeForCellWithClassCell:[HomeHotCollectionViewCell class] indexPath:indexPath fixedValue:(SCREEN_WIDTH-4*AppTop)/3 configuration:^(__kindof HomeHotCollectionViewCell *cell) {
        cell.model=self.listData[indexPath.row];
    }];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GKBookModel *model=self.listData[indexPath.row];
    [JumpApp jumpToBookDetail:model._id];
}
- (NSMutableArray *)listData{
    if (!_listData) {
        _listData=[NSMutableArray array];
    }
    return _listData;
}
@end
