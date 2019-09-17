//
//  ReadContentController.m
//  novel
//
//  Created by 黎铭轩 on 6/8/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "ReadContentController.h"
#import "ReadTopView.h"
#import "ReadBottomView.h"
#import "GKReadSetManager.h"
#import "ATImageTopButton.h"
#import "ReadContentViewController.h"
#import "BookChapterController.h"
#import "GKBookSourceModel.h"
#import "ReadSetView.h"
#import "GKBookReadDataQueue.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "NovelNetManager.h"
#import "GKBookCacheTool.h"
#define SetHeight (180 + TAB_BAR_ADDING)
@interface ReadContentController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@property (strong, nonatomic)GKBookDetailModel *model;
@property (strong, nonatomic)UIImageView *mainView;
@property (strong, nonatomic)ReadTopView *topView;
@property (strong, nonatomic)ReadBottomView *bottomView;
@property (strong, nonatomic)GKBookSourceInfo *bookSource;
@property (assign, nonatomic)NSInteger chapter;
@property (strong, nonatomic)UIPageViewController *pageViewController;
@property (strong, nonatomic)ReadSetView *setView;
@property (strong, nonatomic)GKBookReadModel *bookModel;
@property (strong, nonatomic)GKBookContentModel *bookContent;
@property (strong, nonatomic)GKBookChapterInfo *bookChapter;
@property (assign, nonatomic)NSInteger bookIndex;
@property (assign, nonatomic)NSInteger pageIndex;
@end

@implementation ReadContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
    [self loadData];
}
+ (instancetype)viewControllerWithDetailModel:(GKBookDetailModel *)model{
    ReadContentController *viewController=[[ReadContentController alloc]init];
    viewController.model=model;
    return viewController;
}
-(void)loadUI{
    self.fd_prefersNavigationBarHidden=YES;
    [self.view addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.pageViewController didMoveToParentViewController:self];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(TAB_BAR_ADDING+49);
    }];
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(NAVI_BAR_HIGHT);
    }];
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button];
    button.backgroundColor=[UIColor redColor];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(SCALEW(120));
        make.center.equalTo(self.view);
    }];
    [button addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.setView];
    [self.setView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(SetHeight);
        make.bottom.offset(SetHeight);
    }];
    [self.setView setHidden:YES];
}
-(void)loadData{
    [self readSetView:nil state:GKReadDefault];
    [GKBookReadDataQueue getDataFromDataBase:self.model._id completion:^(GKBookReadModel * _Nonnull bookModel) {
        if (bookModel.bookSource.bookSourceId && bookModel.bookChapter.link) {
            self.bookModel=bookModel;
            self.bookSource=bookModel.bookSource;
            self.chapter=bookModel.bookChapter.chapterIndex ?: 0;
            self.bookIndex=bookModel.bookContent.pageIndex ?: 0;
            [self loadBookContent:YES chapter:self.chapter];
        }
        else{
            self.chapter=0;
            self.bookIndex=0;
            [self loadBookSummary];
        }
    }];
}
-(void)tapAction{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(tapAction) object:nil];
    if (!self.setView.hidden) {
        [self setAction];
    }
    else{
        self.topView.hidden ? [self tapViewShow] : [self tapViewHidden];
    }
}
#pragma mark - 点击显示
-(void)tapViewShow{
    self.topView.hidden=NO;
    self.bottomView.hidden=NO;
    [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(NAVI_BAR_HIGHT);
    }];
    CGFloat height=TAB_BAR_ADDING+49;
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(height);
    }];
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            [self setNeedsStatusBarAppearanceUpdate];
        }
    }];
}
#pragma mark - 点击隐藏
-(void)tapViewHidden{
    [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(NAVI_BAR_HIGHT);
        make.bottom.equalTo(self.view.mas_top);
    }];
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(TAB_BAR_ADDING+49);
        make.top.equalTo(self.view.mas_bottom);
    }];
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            self.topView.hidden=YES;
            self.bottomView.hidden=YES;
            //设置状态栏隐藏
            [self setNeedsStatusBarAppearanceUpdate];
        }
    }];
}
#pragma mark - 状态栏
- (BOOL)prefersStatusBarHidden{
    return self.topView.hidden;
}
-(void)goBack{
    [self insertDataQueue];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)moreAction{
    BookSourceController *bookSource=[BookSourceController viewControllerWithChapter:self.model._id sourceID:self.bookSource.bookSourceId completion:^(NSInteger index) {
        [self loadBookChapters:index];
    }];
    [self.navigationController pushViewController:bookSource animated:YES];
}
-(void)setAction{
    if (self.setView.hidden) {
        [self.setView loadData];
        self.setView.hidden=NO;
        __weak typeof(self)WeakSelf=self;
        self.setView.Setstate = ^(ReadSetView * _Nonnull setView, GKReadState state) {
            [GKReadSetManager setReadState:state];
            WeakSelf.mainView.image=[GKReadSetManager defaultSkin];
            WeakSelf.bottomView.dayButton.selected=[GKReadSetManager shareInstance].model.state==GKReadBlack;
        };
        self.setView.Setfont = ^(ReadSetView * _Nonnull setView, CGFloat font) {
            [WeakSelf.bookContent setContentPage];
            WeakSelf.pageIndex=WeakSelf.pageIndex<WeakSelf.bookContent.pageCount ? WeakSelf.pageIndex : WeakSelf.bookContent.pageCount-1;
            [WeakSelf insertDataQueue];
            UIViewController *viewController=[WeakSelf viewControllerAtPage:WeakSelf.pageIndex chapter:WeakSelf.chapter];
            [WeakSelf.pageViewController setViewControllers:[NSArray arrayWithObject:viewController] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
        };
        [self.setView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.mas_equalTo(SetHeight);
        }];
        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
    else{
        [self.setView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(SetHeight);
            make.top.equalTo(self.view.mas_bottom);
        }];
        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.setView.hidden=YES;
        }];
    }
}
-(void)readSetView:(ReadSetView *)setView state:(GKReadState)state{
    self.mainView.image=[GKReadSetManager defaultSkin];
    self.bottomView.dayButton.selected=[GKReadSetManager shareInstance].model.state == GKReadBlack;
}

#pragma mark - 获取源
-(void)loadBookSummary{
    [SVProgressHUD show];
    [NovelNetManager bookSummary:self.model._id success:^(id  _Nonnull object) {
        [SVProgressHUD dismiss];
        self.bookSource.listData=[NSArray modelArrayWithClass:[GKBookSourceModel class] json:object];
        [self loadBookChapters:0];
    } failure:^(NSString * _Nonnull error) {
        [SVProgressHUD dismiss];
    }];
}
#pragma mark - 加载章节列表
-(void)loadBookChapters:(NSInteger)sourceIndex{
    [SVProgressHUD show];
    self.bookSource.sourceIndex=sourceIndex;
    [NovelNetManager bookChapters:self.bookSource.bookSourceId success:^(id  _Nonnull object) {
        [SVProgressHUD dismiss];
        self.bookChapter=[GKBookChapterInfo modelWithJSON:object];
        [self loadBookContent:NO chapter:self.chapter];
    } failure:^(NSString * _Nonnull error) {
        [SVProgressHUD dismiss];
    }];
}
#pragma mark - 加载章节内容
-(void)loadBookContent:(BOOL)history chapter:(NSInteger)chapterIndex{
    GKBookChapterModel *model;
    if (history) {
        model=self.bookModel.bookChapter;
    }
    if (!self.bookChapter) {
        [self loadBookSummary];
        return;
    }
    if (self.bookChapter.chapters.count>chapterIndex) {
        model=self.bookChapter.chapters[chapterIndex];
    }
    else{
        [SVProgressHUD dismiss];
        [SVProgressHUD showInfoWithStatus:@"没有下一章了"];
        return;
    }
    model.chapterIndex=chapterIndex;
    BOOL maxIndex=(self.pageIndex+1==self.bookContent.pageCount);
    [GKBookCacheTool bookContent:model.link contentId:model._id bookId:self.model._id sameSource:self.bookSource.sourceIndex success:^(GKBookContentModel *model) {
        self.bookContent=model;
        [self.bookContent setContentPage];
        [self reloadUI:history maxIndex:maxIndex];
        [SVProgressHUD dismiss];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
}
-(void)reloadUI:(BOOL)history maxIndex:(BOOL)maxIndex{
    if (!history) {
        self.pageIndex=maxIndex ? self.bookContent.pageCount-1 : 0;
        [self insertDataQueue];
        UIViewController *viewController=[self viewControllerAtPage:self.pageIndex chapter:self.chapter];
        [self.pageViewController setViewControllers:[NSArray arrayWithObjects:viewController, nil] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    }
}
-(void)insertDataQueue{
    GKBookChapterModel *chapterModel=[self.bookChapter.chapters objectSafeAtIndex:self.chapter] ? : self.bookModel.bookChapter;
    GKBookSourceInfo *bookSource=self.bookSource.bookSourceId ? self.bookSource : self.bookModel.bookSource;
    GKBookContentModel *contentModel=self.bookContent ? : self.bookModel.bookContent;
    chapterModel.chapterIndex=self.chapter;
    contentModel.pageIndex=self.pageIndex;
    
    GKBookReadModel *readModel=[GKBookReadModel vcWithBookId:self.model._id bookSource:bookSource bookChapter:chapterModel bookContent:contentModel bookModel:self.model];
    [GKBookReadDataQueue  insertDataToDataBase:readModel completion:^(BOOL success) {
        if (success) {
            NSLog(@"成功插入数据");
        }
    }];
}
-(UIViewController *)viewControllerAtPage:(NSUInteger)pageIndex chapter:(NSInteger)chapterIndex{
    ReadContentViewController *viewController=[[ReadContentViewController alloc] init];
    self.pageIndex=pageIndex;
    if (self.chapter != chapterIndex) {
        self.chapter = chapterIndex;
        [self loadBookContent:NO chapter:chapterIndex];
    }
    [viewController setCurrentPage:pageIndex totalPage:self.bookContent.pageCount chapter:self.chapter title:self.bookContent.title bookName:self.model.title content:[self.bookContent getContentAtt:pageIndex]];
    if (self.bookContent.pageCount > pageIndex && pageIndex == 0 && self.bookChapter.chapters.count > chapterIndex+1) {
        GKBookChapterModel *model=self.bookChapter.chapters[chapterIndex+1];
        [GKBookCacheTool bookContent:model.link contentId:model._id bookId:self.bookChapter._id sameSource:self.bookSource.sourceIndex success:nil failure:nil];
    }
    return viewController;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(ReadContentViewController *)viewController{
    NSInteger pageIndex=viewController.pageIndex;
    NSUInteger chapter=viewController.chapterIndex;
    if (pageIndex==0 && chapter==0) {
        return nil;
    }
    if (pageIndex >= 0) {
        pageIndex--;
    }
    else{
        chapter--;
        pageIndex=self.bookContent.pageCount-1;
    }
    return [self viewControllerAtPage:pageIndex chapter:chapter];
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(ReadContentViewController *)viewController{
    NSInteger pageIndex=viewController.pageIndex;
    NSInteger chapter=viewController.chapterIndex;
    if (pageIndex == self.bookContent.pageCount) {
        pageIndex=0;
        chapter++;
    }
    else{
        pageIndex++;
    }
    return [self viewControllerAtPage:pageIndex chapter:chapter];
}
- (UIImageView *)mainView{
    if (!_mainView) {
        _mainView=[[UIImageView alloc] init];
        _mainView.userInteractionEnabled=YES;
        _mainView.contentMode=UIViewContentModeScaleAspectFill;
    }
    return _mainView;
}
- (ReadTopView *)topView{
    if (!_topView) {
        _topView=[ReadTopView readView];
        [_topView.closeButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        [_topView.moreButton addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topView;
}
- (ReadBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView=[ReadBottomView bottomView];
        [_bottomView.setButton addTarget:self action:@selector(setAction) forControlEvents:UIControlEventTouchUpInside];
        __weak typeof(self)Weakself=self;
        [_bottomView.dayButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(ATImageTopButton *sender) {
            sender.selected = !sender.selected;
            GKReadState state=(sender.selected==NO) ? GKReadDefault : GKReadBlack;
            [GKReadSetManager setReadState:state];
            Weakself.mainView.image=[GKReadSetManager defaultSkin];
        }];
        [_bottomView.cateButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(ATImageTopButton *sender) {
            BookChapterController *viewController=[BookChapterController viewControllerWithChapter:Weakself.bookSource.bookSourceId chapter:Weakself.chapter completion:^(NSInteger index) {
                Weakself.chapter=index;
                [Weakself loadBookContent:NO chapter:index];
            }];
            [Weakself.navigationController pushViewController:viewController animated:YES];
        }];
    }
    return _bottomView;
}
- (UIPageViewController *)pageViewController{
    if (!_pageViewController) {
        _pageViewController=[[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{}];
        _pageViewController.doubleSided=YES;
        _pageViewController.dataSource=self;
        _pageViewController.delegate=self;
    }
    return _pageViewController;
}
- (ReadSetView *)setView{
    if (!_setView) {
        _setView=[ReadSetView setView];
    }
    return _setView;
}
- (GKBookSourceInfo *)bookSource{
    if (!_bookSource) {
        _bookSource=[[GKBookSourceInfo alloc] init];
    }
    return _bookSource;
}
@end
