//
//  MineViewController.m
//  novel
//
//  Created by 黎铭轩 on 16/7/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "MineViewController.h"
#import "UserModel.h"
#import "MineTableViewCell.h"
#import "MineSelectController.h"
#import "StartViewController.h"
#import "BooCaseController.h"
#import "BookHistoryController.h"
#import "ThemeViewController.h"
@interface MineViewController ()
@property (strong, nonatomic)NSArray *listArray;
@end
static NSString *rank = @"自定义首页";
static NSString *sex = @"性别";
static NSString *bookCase = @"我的书架";
static NSString *readHistory = @"读书记录";
static NSString *theme = @"主题";
@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupEmpty:self.tableView];
    [self reloadUI];
}
- (void)reloadUI{
    AppModel *model=[AppTheme shareInstance].model;
    UserState state=[UserManager shareInstance].user.state;
    self.listArray=@[@{@"title":rank,@"subTitle":@""},@{@"title":readHistory?:@"",@"subTitle":@""},@{@"title":bookCase?:@"",@"subTitle":@""},@{@"title":sex,@"subTitle":(state == UserBoy ?@"小哥哥":@"小姐姐")},@{@"title":theme?:@"",@"subTitle":model.title?:@""}];
    [self.tableView registerNib:[UINib nibWithNibName:@"MineTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self.tableView reloadData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *dictionary=self.listArray[indexPath.row];
    cell.titleLabel.text=dictionary[@"title"];
    cell.subTitleLabel.text=dictionary[@"subTitle"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            MineSelectController *viewController=[[MineSelectController alloc]init];
            [viewController setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case 1:{
            StartViewController *viewController=[[StartViewController alloc]init];
            [viewController setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case 2:{
            BooCaseController *viewController=[[BooCaseController alloc]init];
            [viewController setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:viewController animated:YES];
            
        }
            break;
        case 3:{
            BookHistoryController *viewController=[[BookHistoryController alloc]init];
            [viewController setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case 4:{
            ThemeViewController *viewController=[[ThemeViewController alloc]init];
            [viewController setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        default:
            break;
    }
}
@end
