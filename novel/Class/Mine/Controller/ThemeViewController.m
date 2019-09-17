//
//  ThemeViewController.m
//  novel
//
//  Created by 黎铭轩 on 2/8/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "ThemeViewController.h"
#import "ThemeTableViewCell.h"
#import "ATAlertView.h"
#import "JumpApp.h"
#import "BookCaseViewController.h"
@interface ThemeViewController ()
@property (strong, nonatomic)NSMutableArray *listData;
@end

@implementation ThemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showNavTitle: @"主题切换"];
    self.tableView.estimatedRowHeight=100;
    [self setupEmpty:self.tableView];
    [self setupRefresh:self.tableView option:ATRefreshDefault];
}

- (void)refreshData:(NSInteger)page{
    NSString *path=[[NSBundle mainBundle] pathForResource:@"App" ofType:@"plist"];
    NSDictionary *dictionary=[NSDictionary dictionaryWithContentsOfFile:path];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        AppModel *model=[AppModel modelWithJSON:obj];
        [self.listData addObject:model];
    }];
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
    return self.listData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ThemeTableViewCell *cell=[ThemeTableViewCell cellForTableView:tableView indexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.model=self.listData[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AppModel *modelq=[AppTheme shareInstance].model;
    AppModel *model=self.listData[indexPath.row];
    if ([modelq.title isEqualToString:model.title]) {
        return;
    }
    [ATAlertView showTitle:@"提示" message:@"切换主题会重新启动程序" normalButtons:@[@"取消"] highlightButtons:@[@"确定"] completion:^(NSUInteger index, NSString *buttonTitle) {
        if (index==1) {
            [AppTheme saveAppTheme:model];
            [JumpApp jumpToAppGuidePage:^{
                [JumpApp jumpToAppTheme];
            }];
        }
    }];
}
- (NSMutableArray *)listData{
    if (!_listData) {
        _listData=[NSMutableArray array];
    }
    return _listData;
}
@end
