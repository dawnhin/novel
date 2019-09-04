//
//  ClassContentViewController.m
//  novel
//
//  Created by 黎铭轩 on 16/7/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "ClassContentViewController.h"
#import "NewNavigationBarView.h"
#import "VTMagicController.h"
#import "ClassItemViewController.h"
#import "KLRecycleScrollView.h"
#import "UserManager.h"
#import "UserModel.h"
#import "SearchHistoryViewController.h"
#import "StartViewController.h"
@interface ClassContentViewController ()<VTMagicViewDataSource,VTMagicViewDelegate,KLRecycleScrollViewDelegate>
@property (strong, nonatomic)NSArray<NSString *> *listTitle;
@property (strong, nonatomic)NSArray<NSString *> *listData;
@property (strong, nonatomic)NSArray *listHotWords;
@property (strong, nonatomic)NewNavigationBarView *navigationBar;
@property (strong, nonatomic)VTMagicController *magicController;
@property (strong, nonatomic)KLRecycleScrollView *recycleMessage;
@end

@implementation ClassContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.fd_prefersNavigationBarHidden=YES;
    [self.view addSubview:self.navigationBar];
    [self.navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(NAVI_BAR_HIGHT);
    }];
    [self addChildViewController:self.magicController];
    [self.view addSubview:self.magicController.view];
    [self.magicController.magicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.navigationBar.mas_bottom);
    }];
    [self.navigationBar.mainView addSubview:self.recycleMessage];
    [self.recycleMessage setValue:@(NO) forKeyPath:@"scrollView.scrollsToTop"];
    [self loadData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationBar.state=[UserManager shareInstance].user.state;
}
-(void)loadData{
    self.listTitle=@[@"男生",@"女生",@"出版社"];
    self.listData=@[@"male",@"female",@"press"];
    [self.magicController.magicView reloadData];
    self.listHotWords=[BaseMacro hotDatas];
    [self.recycleMessage reloadData:self.listHotWords.count];
}
-(void)searchAction{
    SearchHistoryViewController *search=[[SearchHistoryViewController alloc]init];
    search.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:search animated:YES];
}
-(void)addAction{
    StartViewController *start=[[StartViewController alloc]init];
    start.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:start animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView{
    return self.listTitle;
}
- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex{
    static NSString *identifier=@"button";
    UIButton *button=[magicView dequeueReusableItemWithIdentifier:identifier];
    if (!button) {
        button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.text=self.listTitle[itemIndex];
        [button setTitleColor:Appx333333 forState:UIControlStateNormal];
        [button setTitleColor:AppColor forState:UIControlStateSelected];
        button.titleLabel.font=[UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    }
    return button;
}
- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex{
    static NSString *identifier=@"magicView";
    ClassItemViewController *viewController=[magicView dequeueReusablePageWithIdentifier:identifier];
    if (!viewController) {
        viewController=[[ClassItemViewController alloc]init];
    }
    viewController.titleName=self.listData[pageIndex];
    return viewController;
}
- (UIView *)recycleScrollView:(KLRecycleScrollView *)recycleScrollView viewForItemAtIndex:(NSInteger)index{
    UILabel *label=[[UILabel alloc]init];
    label.font=[UIFont systemFontOfSize:14];
    label.textColor=Appx333333;
    label.text=self.listHotWords[index];
    return label;
}
- (void)recycleScrollView:(KLRecycleScrollView *)recycleScrollView didSelectView:(UIView *)view forItemAtIndex:(NSInteger)index{
    [self searchAction];
}
- (NewNavigationBarView *)navigationBar{
    if (!_navigationBar) {
        _navigationBar=[NewNavigationBarView navigationBar];
        [_navigationBar.moreButton addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navigationBar;
}
- (UIViewController<VTMagicProtocol> *)magicController{
    if (!_magicController) {
        _magicController=[[VTMagicController alloc]init];
        _magicController.magicView.separatorHeight=0.5;
        _magicController.magicView.separatorColor=[UIColor colorWithRGB:0xdddddd];
        _magicController.magicView.backgroundColor=[UIColor whiteColor];
        _magicController.magicView.navigationInset=UIEdgeInsetsMake(0, 7, 0, 7);
        _magicController.magicView.sliderColor=AppColor;
        _magicController.magicView.sliderExtension=1;
        _magicController.magicView.bubbleRadius=5;
        _magicController.magicView.sliderWidth=VTSliderStyleDefault;
        _magicController.magicView.layoutStyle=VTLayoutStyleCenter;
        _magicController.magicView.navigationHeight=35;
        _magicController.magicView.itemSpacing=30;
        _magicController.magicView.dataSource=self;
        _magicController.magicView.delegate=self;
        _magicController.magicView.itemScale=1.15;
        _magicController.magicView.bounces=YES;
    }
    return _magicController;
}
- (KLRecycleScrollView *)recycleMessage{
    if (!_recycleMessage) {
        _recycleMessage=[[KLRecycleScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-100, 35)];
        _recycleMessage.delegate=self;
        _recycleMessage.direction=KLRecycleScrollViewDirectionTop;
        _recycleMessage.backgroundColor=[UIColor whiteColor];
        _recycleMessage.pagingEnabled=NO;
        _recycleMessage.timerEnabled=YES;
        _recycleMessage.scrollInterval=5;
    }
    return _recycleMessage;
}
@end
