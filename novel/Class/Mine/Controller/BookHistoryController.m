//
//  BookHistoryController.m
//  novel
//
//  Created by 黎铭轩 on 2/8/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "BookHistoryController.h"
#import "GKBookReadDataQueue.h"
#import "ClassflyTableViewCell.h"
#import "ATAlertView.h"
#import <SVProgressHUD/SVProgressHUD.h>
@interface BookHistoryController ()
@property (assign, nonatomic)BOOL needRequest;
@property (strong, nonatomic)NSMutableArray *listData;
@end

@implementation BookHistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
    [self.tableView registerNib:[UINib nibWithNibName:@"ClassflyTableViewCell" bundle:nil] forCellReuseIdentifier:@"ClassflyTableViewCell"];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.needRequest) {
        [self headerRefreshing];
    }
    self.needRequest=YES;
}
-(void)loadUI{
    [self showNavTitle: @"读书记录"];
    self.tableView.estimatedRowHeight=44;
    [self setupEmpty:self.tableView image:[UIImage imageNamed:@"icon_data_empty"] title:@"数据空空如也...\n\r请到书籍详情页观看你喜欢的书籍吧"];
    [self setupRefresh:self.tableView option:ATRefreshDefault];
}
- (void)refreshData:(NSInteger)page{
    [GKBookReadDataQueue getDatasFromDataBase:^(NSArray<GKBookReadModel *> * _Nonnull listData) {
        if (page == RefreshPageStart) {
            [self.listData removeAllObjects];
        }
        if (listData) {
            [self.listData addObjectsFromArray:listData];
        }
        [self.tableView reloadData];
        self.listData.count == 0 ? [self endRefreshFailure] : [self endRefresh:listData.count >= RefreshPageSize];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassflyTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ClassflyTableViewCell" forIndexPath:indexPath];
    GKBookReadModel *model=self.listData[indexPath.row];
    cell.model=model.bookModel;
    cell.subTitleLabel.text=[NSString stringWithFormat: @"最近阅读: %@\n\r%@",model.bookChapter.title,model.bookModel.updateTime];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
//允许编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    GKBookReadModel *model=self.listData[indexPath.row];
    UITableViewRowAction *topButton=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self topAction:model];
    }];
    UITableViewRowAction *deleteButton=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [ATAlertView showTitle:[NSString stringWithFormat:@"确定将《%@》从历史记录删除吗？",model.bookModel.title] message:nil normalButtons:@[@"取消"] highlightButtons:@[@"好"] completion:^(NSUInteger index, NSString *buttonTitle) {
            if (index==1) {
                [self.listData removeObjectAtIndex:indexPath.row];
                [GKBookReadDataQueue deleteDataToDataBase:model.bookId completion:^(BOOL success) {
                    if (success) {
                        [ATAlertView showTitle:[NSString stringWithFormat: @"成功将《%@》删除",model.bookModel.title] message:nil normalButtons:@[@"好"] highlightButtons:nil completion:nil];
                        [self.tableView reloadData];
                    }
                }];
            }
        }];
    }];
    return @[topButton,deleteButton];
}
-(void)topAction:(GKBookReadModel *)model{
    model.updateTime=@"";
    [GKBookReadDataQueue updateDataToDataBase:model completion:^(BOOL success) {
        if (success) {
            [self headerRefreshing];
        }
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
- (NSMutableArray *)listData{
    if (!_listData) {
        _listData=[NSMutableArray array];
    }
    return _listData;
}
@end
