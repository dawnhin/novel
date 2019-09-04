//
//  HomeMoreTableViewController.m
//  novel
//
//  Created by 黎铭轩 on 10/8/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "HomeMoreTableViewController.h"
#import "GKBookModel.h"
#import "NovelNetManager.h"
#import "ClassflyTableViewCell.h"
#import "BookDetailController.h"
@interface HomeMoreTableViewController ()
@property (strong, nonatomic)GKBookInfo *bookInfo;
@end
static NSString *ID=@"ClassflyTableViewCell";
@implementation HomeMoreTableViewController
+ (instancetype)viewControllerWithBookInfo:(GKBookInfo *)bookInfo{
    HomeMoreTableViewController *viewController=[[HomeMoreTableViewController alloc]init];
    viewController.bookInfo=bookInfo;
    return viewController;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerNib:[UINib nibWithNibName:@"ClassflyTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
    [self showNavTitle: self.bookInfo.shortTitle];
    [self loadData];
}
-(void)loadData{
    [NovelNetManager homeHot:self.bookInfo._id success:^(id  _Nonnull object) {
        self.bookInfo=[GKBookInfo modelWithJSON:object];
        [self showNavTitle:[NSString stringWithFormat:@"%@(%ld)",self.bookInfo.shortTitle,self.bookInfo.total]];
        [self.tableView reloadData];
    } failure:^(NSString * _Nonnull error) {
        
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bookInfo.books.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClassflyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.model=self.bookInfo.books[indexPath.row];
    // Configure the cell...
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GKBookModel *model=self.bookInfo.books[indexPath.row];
    BookDetailController *detail=[BookDetailController viewControllerWithBookID:model._id];
    [self.navigationController pushViewController:detail animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
