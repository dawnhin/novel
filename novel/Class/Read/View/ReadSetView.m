//
//  ReadSetView.m
//  novel
//
//  Created by 黎铭轩 on 5/9/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "ReadSetView.h"
#import "UIImage+circle.h"
#import "GKReadSetManager.h"
#import "ReadSetCell.h"
@interface ReadSetView()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic)NSArray *listData;
@end
@implementation ReadSetView
+ (instancetype)setView{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self loadUI];
    [self loadData];
}
-(void)loadUI{
    self.backgroundColor=Appx252631;
    self.slider.thumbTintColor=AppColor;
    self.slider.minimumTrackTintColor=AppColor;
    self.slider.maximumTrackTintColor=Appxdddddd;
    UIImage *image=[UIImage circleImageWithName:[UIImage originImage:[UIImage imageWithColor:AppColor] scaleToSize:CGSizeMake(15, 15)] borderWidth:2 borderColor:Appxdddddd];
    [self.slider setThumbImage:image forState:UIControlStateNormal|UIControlStateSelected];
    [self.slider addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventValueChanged];
    __weak typeof(self)WeakSelf=self;
    [self.slider addBlockForControlEvents:UIControlEventTouchUpInside block:^(UISlider *slider) {
        WeakSelf.Setbrightness(WeakSelf, slider.value);
    }];
    self.segmentControl.tintColor=AppColor;
    [self.segmentControl setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} forState:UIControlStateNormal|UIControlStateSelected];
    [self.segmentControl addBlockForControlEvents:UIControlEventValueChanged block:^(UISegmentedControl *segmentControl) {
        CGFloat font=2*segmentControl.selectedSegmentIndex+18;
        [GKReadSetManager setFont:font];
        if (WeakSelf.Setfont) {
            WeakSelf.Setfont(WeakSelf, font);
        }
    }];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ReadSetCell" bundle:nil] forCellWithReuseIdentifier:@"ReadSetCell"];
    self.collectionView.backgroundView.backgroundColor=Appx252631;
}
-(void)loadData{
    self.slider.value=[[UIScreen mainScreen] brightness];
    self.segmentControl.selectedSegmentIndex=([GKReadSetManager shareInstance].model.font-18)*0.5;
    self.listData=[GKReadSetManager defaultSkinDatas];
    [self.collectionView reloadData];
}
-(void)changeAction:(UISlider *)slider{
    [[UIScreen mainScreen] setBrightness:slider.value];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.listData.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ReadSetCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"ReadSetCell" forIndexPath:indexPath];
    GKReadSkinModel *model=self.listData[indexPath.row];
    cell.imageView.image=[UIImage imageNamed:model.skin];
    cell.titleLabel.text=model.title;
    cell.imageIcon.hidden=model.state != [GKReadSetManager shareInstance].model.state;
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(70, 50);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GKReadSkinModel *model=self.listData[indexPath.row];
    if (model.state != [GKReadSetManager shareInstance].model.state) {
        [GKReadSetManager setReadState:model.state];
        if (self.Setstate) {
            self.Setstate(self, model.state);
        }
    }
    [self loadData];
}
@end
