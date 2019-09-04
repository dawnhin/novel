//
//  ClassflyViewController.m
//  novel
//
//  Created by 黎铭轩 on 30/8/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "ClassflyViewController.h"
#import "GKBookModel.h"
#import "ClassflyTableViewCell.h"
#import "JumpApp.h"
@interface ClassflyViewController ()
@property (strong, nonatomic)NSString *group;
@property (strong, nonatomic)NSString *name;
@property (strong, nonatomic)NSMutableArray *listData;
@end

static NSString *cellID=@"ClassflyTableViewCell";
@implementation ClassflyViewController
+ (instancetype)viewControllerWithGroup:(NSString *)group name:(NSString *)name{
    ClassflyViewController *viewController=[[ClassflyViewController alloc]init];
    viewController.hidesBottomBarWhenPushed=YES;
    viewController.group=group;
    viewController.name=name;
    return viewController;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupEmpty:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ClassflyTableViewCell class]) bundle:nil] forCellReuseIdentifier:cellID];
    [self setupRefresh:self.tableView option:ATRefreshDefault];
}
- (void)refreshData:(NSInteger)page{
    [NovelNetManager homeClssItem:self.group major:self.name page:page success:^(id  _Nonnull object) {
        GKBookInfo *bookInfo=[GKBookInfo modelWithJSON:object];
        if (page == RefreshPageStart) {
            [self.listData removeAllObjects];
            [self showNavTitle:[NSString stringWithFormat:@"%@(%ld)",self.name,bookInfo.total]];
        }
        bookInfo.books.count ? [self.listData addObjectsFromArray:bookInfo.books] : nil;
        [self.tableView reloadData];
        [self endRefresh:bookInfo.books.count >= RefreshPageSize];
    } failure:^(NSString * _Nonnull error) {
        [self endRefreshFailure];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GKBookModel *model=self.listData[indexPath.row];
    ClassflyTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.model=model;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GKBookModel *model=self.listData[indexPath.row];
    [JumpApp jumpToBookDetail:model._id];
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
