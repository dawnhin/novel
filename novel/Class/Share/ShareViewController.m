//
//  ShareViewController.m
//  novel
//
//  Created by 黎铭轩 on 14/8/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "ShareViewController.h"
#import "ShareViewCell.h"
#import <HWPanModal/HWPanModal.h>
@interface ShareViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic)GKBookListDetailModel *bookListDetailModel;
@property (strong, nonatomic)GKBookDetailModel *bookDetailModel;
@property (strong, nonatomic)NSMutableArray *listData;
@property (strong, nonatomic)NSMutableArray *listImages;
@end
static NSString * const cellID=@"ShareViewCell";
@implementation ShareViewController
+ (instancetype)viewControllerWithBookModel:(GKBookDetailModel *)model{
    ShareViewController *viewController=[[ShareViewController alloc]init];
    viewController.bookDetailModel=model;
    return viewController;
}
+ (instancetype)viewControllerWithBookListModel:(GKBookListDetailModel *)model{
    ShareViewController *viewController=[[ShareViewController alloc]init];
    viewController.bookListDetailModel=model;
    return viewController;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.cancelButton setBackgroundColor:AppColor];
    self.cancelButton.layer.cornerRadius=AppRadius;
    self.cancelButton.layer.masksToBounds=YES;
    [self.cancelButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    self.titleLabel.textColor=Appx999999;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ShareViewCell" bundle:nil] forCellWithReuseIdentifier:cellID];
    if (self.bookListDetailModel) {
        [self.listImages addObject: @"icon_system"];
        [self.listImages addObject: @"icon_copy"];
        [self.listData addObject: @"系统分享"];
        [self.listData addObject: @"复制"];
    }
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.bottom.equalTo(self.cancelButton.mas_top);
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
- (PanModalHeight)longFormHeight{
    return PanModalHeightMake(PanModalHeightTypeContent, 210);
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.listData.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ShareViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.imageView.image=[UIImage imageNamed:self.listImages[indexPath.row]];
    cell.titleLabel.text=self.listData[indexPath.row];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width;
    if (self.listData.count>4) {
        width=SCREEN_WIDTH/4.5;
    }
    else{
        width=SCREEN_WIDTH/self.listData.count;
    }
    return CGSizeMake(width, 90);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing=20;
        layout.minimumInteritemSpacing=20;
        _collectionView=[[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource=self;
        _collectionView.delegate=self;
        _collectionView.showsHorizontalScrollIndicator=NO;
    }
    return _collectionView;
}
- (NSMutableArray *)listData{
    if (!_listData) {
        _listData=[NSMutableArray arrayWithObjects:@"微信",@"朋友圈",@"QQ",@"QQ空间", nil];
    }
    return _listData;
}
- (NSMutableArray *)listImages{
    if (!_listImages) {
        _listImages=[NSMutableArray arrayWithObjects:@"icon_wechat",@"icon_line",@"icon_qq",@"icon_qqzone", nil];
    }
    return _listImages;
}
@end
