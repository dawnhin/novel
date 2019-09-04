//
//  NovelTabBarController.m
//  novel
//
//  Created by 黎铭轩 on 16/7/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "NovelTabBarController.h"
#import "BaseNavigationController.h"
#import "HomeViewController.h"
#import "ClassContentViewController.h"
#import "BookCaseViewController.h"
#import "MineViewController.h"
@interface NovelTabBarController ()
@property (strong, nonatomic)NSMutableArray *listData;
@end

@implementation NovelTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
}
-(void)loadUI{
    AppModel *model=[AppTheme shareInstance].model;
//    self.listData=[NSMutableArray array];
    //取消tabBar半透明
    self.tabBar.translucent=NO;
    UIViewController *viewController;
    viewController=[[HomeViewController alloc]init];
    [self viewController:viewController title:@"首页" normal:model.icon_home_n select:model.icon_home_h];
    viewController=[[ClassContentViewController alloc]init];
    [self viewController:viewController title:@"分类" normal:model.icon_class_n select:model.icon_class_h];
    viewController=[[BookCaseViewController alloc]init];
    [self viewController:viewController title:@"书架" normal:model.icon_case_n select:model.icon_case_h];
    viewController=[[MineViewController alloc]init];
    [self viewController:viewController title:@"我" normal:model.icon_mine_n select:model.icon_mine_h];
    
    self.viewControllers=self.listData;
}
#pragma mark - 设置Tabbar控制器
-(void)viewController:(UIViewController *)viewController title:(NSString *)title normal:(NSString *)normal select:(NSString *)select{
    BaseNavigationController *navigation=[[BaseNavigationController alloc]initWithRootViewController:viewController];
    [viewController showNavTitle:title backItem:NO];
    navigation.title=title;
    navigation.tabBarItem.image=[[UIImage imageNamed:normal] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navigation.tabBarItem.selectedImage=[[UIImage imageNamed:select] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [navigation.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGB:0x888888]} forState:UIControlStateNormal];
    [navigation.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:AppColor} forState:UIControlStateSelected];
    [self.listData addObject: navigation];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSMutableArray *)listData{
    if (!_listData) {
        _listData=[NSMutableArray array];
    }
    return _listData;
}
@end
