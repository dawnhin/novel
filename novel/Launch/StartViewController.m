//
//  StartViewController.m
//  novel
//
//  Created by 黎铭轩 on 15/7/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "StartViewController.h"
#import "CollectionViewLayout.h"
#import "StartCollectionViewCell.h"
#import "UserManager.h"
#import "UserModel.h"
#import "HomeCollectionReusableView.h"
#import <ATImageTopButton.h>
#import "ATAlertView.h"
@interface StartViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *boyButton;
@property (weak, nonatomic) IBOutlet UIButton *girlButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic)UIButton *sureButton;
@property (strong, nonatomic)RankInfo *rankInfo;
@property (strong, nonatomic)CollectionViewLayout *layout;
@property (assign, nonatomic)UserState userState;
@end

@implementation StartViewController
+ (instancetype)viewControllerWithCompletion:(Completion)completion{
    StartViewController *viewController=[[StartViewController alloc]init];
    viewController.completion = completion;
    return viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self showNavTitle: @"修改性别"];
    self.titleLabel.textColor=AppColor;
    [self.view addSubview:self.sureButton];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.bottom.offset(-TAB_BAR_ADDING-10);
        make.height.offset(45);
    }];
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.sureButton.mas_top).offset(-10);
        make.top.equalTo(self.view).offset(SCREEN_HEIGHT/2);
    }];
    [self setupEmpty:self.collectionView image:nil title:@""];
    [self setupRefresh:self.collectionView option:ATRefreshNone];
}
-(void)refreshData:(NSInteger)page{
    [NovelNetManager rankSuccess:^(id  _Nonnull object) {
        self.rankInfo=[RankInfo modelWithJSON:object];
        self.userState=[UserManager shareInstance].user.state ?: UserBoy;
        [self endRefresh:NO];
    } failure:^(NSString * _Nonnull error) {
        [self endRefreshFailure];
    }];
}
- (void)setUserState:(UserState)userState{
    if (_userState!=userState) {
        _userState=userState;
        userState==UserBoy ? [self ClickBoy] : [self ClickGirl];
        self.titleLabel.text = userState==UserBoy ? @"仔":@"囡";
        self.rankInfo.state=userState;
        self.layout.dataArray=self.rankInfo.listData;
        [self.collectionView reloadData];
    }
}
-(void)sureAction{
    NSPredicate *predicate=[NSPredicate predicateWithFormat: @"select = %@",@(YES)];
    NSArray *array=[self.rankInfo.listData filteredArrayUsingPredicate:predicate];
    if (array.count == 0) {
        [ATAlertView showTitle:@"选择一个或者多个做为首页推荐吧！" message:@"" normalButtons:@[@"确定"] highlightButtons:nil completion:nil];
        return;
    }
    UserModel *user=[UserModel viewControllerWithState:self.userState rankDatas:array];
    [UserManager saveUserModel:user];
    if (self.completion) {
        !self.completion ?: self.completion();
    }
    else{
        [UserManager reloadHomeData:LoadDataDefault];
        [self goBack];
    }
}
- (IBAction)boyAction:(UIButton *)sender {
    self.userState=UserBoy;
}
- (IBAction)girlAction:(UIButton *)sender {
    self.userState=UserGirl;
}
-(void)ClickBoy{
    self.boyButton.layer.cornerRadius=AppRadius;
    self.boyButton.layer.masksToBounds=YES;
    self.boyButton.layer.borderWidth=4;
    self.boyButton.layer.borderColor=AppColor.CGColor;
    self.girlButton.layer.borderColor=Appxffffff.CGColor;
}
-(void)ClickGirl{
    self.girlButton.layer.cornerRadius=AppRadius;
    self.girlButton.layer.masksToBounds=YES;
    self.girlButton.layer.borderWidth=4;
    self.girlButton.layer.borderColor=AppColor.CGColor;
    self.boyButton.layer.borderColor=Appxffffff.CGColor;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UICollectionViewDataSource
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
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, self.rankInfo.listData.count ? 40 : 0.001);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    HomeCollectionReusableView *reusableView=[HomeCollectionReusableView viewForCollectionView:collectionView elementKind:kind indexPath:indexPath];
    reusableView.title.text=@"选择2-4项做为首页推荐吧!";
    reusableView.title.font=[UIFont systemFontOfSize:20 weight:UIFontWeightBold];
    return reusableView;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    RankModel *model=self.rankInfo.listData[indexPath.row];
    model.select=!model.select;
    [collectionView reloadData];
}
- (UIButton *)sureButton{
    if (!_sureButton) {
        _sureButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton setTitleColor:Appxffffff forState:UIControlStateNormal];
        [_sureButton setBackgroundImage:[UIImage imageWithColor:AppColor] forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
        _sureButton.layer.cornerRadius=AppRadius;
        _sureButton.layer.masksToBounds=YES;
    }
    return _sureButton;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        CollectionViewLayout *layout=[[CollectionViewLayout alloc]init];
        self.layout=layout;
        layout.scrollDirection=UICollectionViewScrollDirectionVertical;
        _collectionView=[[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor=[UIColor whiteColor];
        _collectionView.dataSource=self;
        _collectionView.delegate=self;
        _collectionView.showsVerticalScrollIndicator=NO;
        _collectionView.scrollEnabled=YES;
        [_collectionView registerClass:[StartCollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        if (@available(iOS 11.0,*)) {
            _collectionView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _collectionView;
}
@end
