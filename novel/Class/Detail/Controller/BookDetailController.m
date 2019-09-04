//
//  BookDetailController.m
//  novel
//
//  Created by 黎铭轩 on 13/8/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "BookDetailController.h"
#import "BookDetailTabbar.h"
#import "UIView+ATKit.h"
#import "ShareViewController.h"
#import "GKBookCaseDataQueue.h"
#import "GKBookReadDataQueue.h"
#import "GKTimeTool.h"
#import <HWPanModal/HWPanModal.h>
#import "BookDetailCell.h"
#import <UICollectionView+ARDynamicCacheHeightLayoutCell.h>
#import "HomeHotCollectionViewCell.h"
#import "ATAlertView.h"
#import "GKBookCacheTool.h"
#import "ASProgressPopUpView.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "JumpApp.h"
#import "BookDetailCollectionViewCell.h"
@interface BookDetailController ()
@property (strong, nonatomic)NSString *bookID;
@property (weak, nonatomic) BookDetailTabbar *Tabbar;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (strong, nonatomic)GKBookDetailInfo *bookDetail;
@property (strong, nonatomic)GKBookCacheTool *bookCache;
@property (strong, nonatomic)ASProgressPopUpView *progressView;
@end

@implementation BookDetailController
+ (instancetype)viewControllerWithBookID:(NSString *)bookID{
    BookDetailController *viewController=[[BookDetailController alloc]init];
    viewController.bookID=bookID;
    return viewController;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadUI];
    [self loadData];
    
}
-(void)loadUI{
    [self showNavTitle:@"书籍详情"];
    self.tipLabel.textColor=AppColor;
    self.tipLabel.backgroundColor=[UIColor colorWithRGB:0xf6f6f6];
    [self setupEmpty:self.collectionView];
    [self setupRefresh:self.collectionView option:ATRefreshDefault];
    [self.view addSubview:self.Tabbar];
    [self.Tabbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(49);
        make.bottom.equalTo(self.view).mas_equalTo(-24);
    }];
    [self.view addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.Tabbar.mas_top);
    }];
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.Tabbar.mas_top);
    }];
    [self setNavRightItemWithImage:[UIImage imageNamed:@"icon_share"] action:@selector(shareAction)];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BookDetailCell" bundle:nil] forCellWithReuseIdentifier:@"BookDetailCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeHotCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeHotCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BookDetailCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"BookDetailCollectionViewCell"];
}
-(void)loadData{
    [GKBookCaseDataQueue getDataFromDataBase:self.bookID completion:^(GKBookDetailModel * _Nonnull bookModel) {
        if (bookModel) {
            [self reloadUI:YES];
        }
    }];
    [GKBookReadDataQueue getDataFromDataBase:self.bookID completion:^(GKBookReadModel * _Nonnull bookModel) {
        [self setTip:bookModel];
    }];
}
- (void)refreshData:(NSInteger)page{
    [GKBookDetailInfo bookDetail:self.bookID success:^(GKBookDetailInfo * _Nonnull info) {
        self.bookDetail=info;
        [self.collectionView reloadData];
        [self endRefresh:NO];
    } failure:^(NSString * _Nonnull error) {
        [self endRefreshFailure];
    }];
}
-(void)setTip:(GKBookReadModel *)model{
    self.tipLabel.hidden=!model;
    self.tipLabel.text=[NSString stringWithFormat: @"本书阅读到: %@\n%@",model.bookChapter.title,[GKTimeTool timeStampTurnToTimesType:model.updateTime]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view).mas_equalTo(35);
        }];
        [UIView animateWithDuration:0.5 animations:^{
            //刷新layout
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.tipLabel.hidden=finished;
        }];
    });
}
-(void)reloadUI:(BOOL)collect{
    self.Tabbar.collect=collect;
}
-(void)addAction:(UIButton *)button{
    if (button.selected) {
        [ATAlertView showTitle:@"从书架中移除会删除本地已下载章节？" message:nil normalButtons:@[@"取消"] highlightButtons:@[@"确定"] completion:^(NSUInteger index, NSString *buttonTitle) {
            if (index>0) {
                [GKBookCaseDataQueue deleteDataToDataBase:self.bookDetail.bookModel._id completion:^(BOOL success) {
                    if (success) {
                        [self reloadUI:NO];
                    }
                }];
            }
            else{
                [GKBookCaseDataQueue insertDataToDataBase:self.bookDetail.bookModel completion:^(BOOL success) {
                    if (success) {
                        [self reloadUI:YES];
                    }
                }];
                __weak typeof(self)WeakSelf=self;
                [self.bookCache downloadData:self.bookDetail.bookModel._id progress:^(NSInteger index, NSInteger total) {
                    CGFloat download= index / total;
                    [WeakSelf.progressView setHidden:NO];
                    [WeakSelf.progressView setProgress:download animated:YES];
                } completion:^(BOOL finish, NSString *error) {
                    if (finish) {
                        [SVProgressHUD showSuccessWithStatus: @"下载成功!"];
                        [self.progressView setHidden:YES];
                    }
                }];
            }
        }];
    }
    else{
        [GKBookCaseDataQueue insertDataToDataBase:self.bookDetail.bookModel completion:^(BOOL success) {
            if (success) {
                [self reloadUI:YES];
            }
        }];
        [self.bookCache downloadData:self.bookDetail.bookModel._id progress:^(NSInteger index, NSInteger total) {
            CGFloat download=index/total;
            [self.progressView setHidden:NO];
            [self.progressView setProgress:download animated:YES];
        } completion:^(BOOL finish, NSString *error) {
            if (finish) {
                [SVProgressHUD showSuccessWithStatus: @"下载成功！"];
                [self.progressView setHidden:YES];
            }
        }];
    }
}
-(void)readAction{
    [JumpApp jumptoBookRead:self.bookDetail.bookModel];
}
-(void)shareAction{
    [self presentPanModal:[ShareViewController viewControllerWithBookModel:self.bookDetail.bookModel]];
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
    return self.bookDetail.listData.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *listData=self.bookDetail.listData[section];
    return listData.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *list=self.bookDetail.listData[indexPath.section];
    id object=list[indexPath.row];
    if ([object isKindOfClass:[GKBookDetailModel class]]) {
        BookDetailCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"BookDetailCell" forIndexPath:indexPath];
        cell.model=object;
        return cell;
    }
    else if ([object isKindOfClass:[GKBookModel class]]){
        HomeHotCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"HomeHotCollectionViewCell" forIndexPath:indexPath];
        cell.model=object;
        return cell;
    }
    else if ([object isKindOfClass:[GKBookListModel class]]){
        BookDetailCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"BookDetailCollectionViewCell" forIndexPath:indexPath];
        cell.model=object;
        return cell;
    }
    return [UICollectionViewCell cellForCollectionView:collectionView indexPath:indexPath];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *list=self.bookDetail.listData[indexPath.section];
    id object=list[indexPath.row];
    if ([object isKindOfClass:[GKBookDetailModel class]]) {
//        CGSize size=[collectionView ar_sizeForCellWithIdentifier:@"BookDetailCell" indexPath:indexPath fixedWidth:SCREEN_WIDTH configuration:^(__kindof BookDetailCell *cell) {
//            cell.model=object;
//        }];
//        return size;
//        CGFloat height=[BookDetailCell heightForWidth:SCREEN_WIDTH model:object];
//        return CGSizeMake(SCREEN_WIDTH, height);
        return [collectionView ar_sizeForCellWithClassCell:[BookDetailCell class] indexPath:indexPath fixedValue:SCREEN_WIDTH configuration:^(__kindof BookDetailCell *cell) {
            cell.model=object;
        }];
    }
    else if ([object isKindOfClass:[GKBookModel class]]){
        return [collectionView ar_sizeForCellWithClassCell:[HomeHotCollectionViewCell class] indexPath:indexPath fixedValue:(SCREEN_WIDTH-4*AppTop)/3 configuration:^(__kindof HomeHotCollectionViewCell *cell) {
            cell.model=object;
        }];
    }
    else if ([object isKindOfClass:[GKBookListModel class]]){
        return [collectionView ar_sizeForCellWithClassCell:[BookDetailCollectionViewCell class] indexPath:indexPath fixedValue:SCREEN_WIDTH configuration:^(__kindof BookDetailCollectionViewCell *cell) {
            cell.model=object;
        }];
    }
    return CGSizeMake(SCREEN_WIDTH, 0.001);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    NSArray *list=self.bookDetail.listData[section];
    if (section == [list.firstObject isKindOfClass:[GKBookModel class]] && section != 0) {
        return AppTop;
    }
    else{
        return 0;
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    NSArray *list=self.bookDetail.listData[section];
    if (section == [list.firstObject isKindOfClass:[GKBookModel class]] && section != 0) {
        return AppTop;
    }
    else{
        return 0;
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    CGFloat space;
    NSArray *list=self.bookDetail.listData[section];
    if (section == [list.firstObject isKindOfClass:[GKBookModel class]] && section != 0) {
        space=AppTop;
    }
    else{
        space=0;
    }
    return UIEdgeInsetsMake(space, space, space, space);
}
- (BookDetailTabbar *)Tabbar{
    if (!_Tabbar) {
        _Tabbar=[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([BookDetailTabbar class]) owner:nil options:nil][0];
        [_Tabbar.addButton addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
        [_Tabbar.readButton addTarget:self action:@selector(readAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _Tabbar;
}
- (ASProgressPopUpView *)progressView{
    if (!_progressView) {
        _progressView=[[ASProgressPopUpView alloc]init];
        _progressView.hidden=YES;
        _progressView.popUpViewColor=[UIColor colorWithRGB:0xed5641];
        _progressView.popUpViewCornerRadius=AppRadius;
        _progressView.font=[UIFont systemFontOfSize:12];
        _progressView.textColor=[UIColor whiteColor];
        [_progressView showPopUpViewAnimated:YES];
    }
    return _progressView;
}
- (GKBookCacheTool *)bookCache{
    if (!_bookCache) {
        _bookCache=[[GKBookCacheTool alloc]init];
    }
    return _bookCache;
}
@end
