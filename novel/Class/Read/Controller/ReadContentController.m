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
@interface ReadContentController ()
@property (strong, nonatomic)GKBookDetailModel *model;
@property (strong, nonatomic)UIImageView *mainView;
@property (strong, nonatomic)ReadTopView *topView;
@property (strong, nonatomic)ReadBottomView *bottomView;
@property (strong, nonatomic)GKBookSourceInfo *bookSource;
@property (assign, nonatomic)NSInteger chapter;
@end

@implementation ReadContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
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
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(NAVI_BAR_HIGHT);
    }];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(TAB_BAR_ADDING+49);
    }];
}

-(void)goBack{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)moreAction{
    
}
-(void)setAction{
    
}
#pragma mark - 获取章节内容
-(void)loadBookContent:(BOOL)history chapter:(NSInteger)chapterIndex{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
        [_bottomView.dayButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(ATImageTopButton *sender) {
            sender.selected = !sender.selected;
            GKReadState state=(sender.selected==NO) ? GKReadDefault : GKReadBlack;
            [GKReadSetManager setReadState:state];
            self.mainView.image=[GKReadSetManager defaultSkin];
        }];
        [_bottomView.cateButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(ATImageTopButton *sender) {
            BookChapterController *viewController=[BookChapterController viewControllerWithChapter:self.bookSource.bookSourceId chapter:self.chapter completion:^(NSInteger index) {
                self.chapter=index;
                [self loadBookContent:NO chapter:index];
            }];
            [self.navigationController pushViewController:viewController animated:YES];
        }];
    }
    return _bottomView;
}
@end
