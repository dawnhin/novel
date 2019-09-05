//
//  BookChapterController.m
//  novel
//
//  Created by 黎铭轩 on 4/9/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "BookChapterController.h"
#import "GKBookChapterModel.h"
#import "BookChapterTableViewCell.h"
@interface BookChapterController()
@property (assign, nonatomic)NSInteger chapterItem;
@property (strong, nonatomic)NSString *bookSourceID;
@property (copy, nonatomic)void(^Completion)(NSInteger selectIndex);
@property (strong, nonatomic)GKBookChapterInfo *chapterInfo;
@end
static NSString * const cellID=@"BookChapterTableViewCell";
@implementation BookChapterController
+ (instancetype)viewControllerWithChapter:(NSString *)bookSourceID chapter:(NSInteger)chapter completion:(void (^)(NSInteger))completion{
    BookChapterController *viewController=[[BookChapterController alloc] init];
    viewController.chapterItem=chapter;
    viewController.bookSourceID=bookSourceID;
    viewController.Completion = completion;
    return viewController;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    [self loadUI];
}
-(void)loadUI{
    [self showNavTitle: @"章节选择"];
    [self setupEmpty:self.tableView];
    [self setupRefresh:self.tableView option:ATRefreshNone];
    [self.tableView registerNib:[UINib nibWithNibName:@"BookChapterTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
}
- (void)refreshData:(NSInteger)page{
    [NovelNetManager bookChapters:self.bookSourceID success:^(id  _Nonnull object) {
        self.chapterInfo=[GKBookChapterInfo modelWithJSON:object];
        [self.tableView reloadData];
        [self endRefresh:NO];
    } failure:^(NSString * _Nonnull error) {
        [self endRefreshFailure];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.chapterInfo.chapters.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BookChapterTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    GKBookChapterModel *model=self.chapterInfo.chapters[indexPath.row];
    cell.title.text=model.title;
    cell.image.hidden=(indexPath.row != self.chapterItem);
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
@end
