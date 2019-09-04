//
//  StartCollectionViewCell.m
//  novel
//
//  Created by 黎铭轩 on 17/7/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "StartCollectionViewCell.h"
@interface StartCollectionViewCell()
@property (assign, nonatomic)StartState state;
@end
@implementation StartCollectionViewCell
+ (instancetype)cellForCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath state:(StartState)state{
    StartCollectionViewCell *cell=[StartCollectionViewCell cellForCollectionView:collectionView indexPath:indexPath];
    cell.state=state;
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.layer.cornerRadius=AppRadius;
    self.titleLabel.layer.masksToBounds=YES;
    self.titleLabel.layer.borderWidth=AppLineHeight;
}
- (void)setModel:(RankModel *)model{
    _model=model;
    [self setSelect:model.select];
    self.titleLabel.text=model.shortTitle ?: @"";
}
-(void)setSelect:(BOOL)select{
    if (select) {
        self.titleLabel.layer.borderColor=[UIColor clearColor].CGColor;
        self.titleLabel.textColor=[UIColor whiteColor];
        self.titleLabel.backgroundColor=AppColor;
    }
    else{
        self.titleLabel.layer.borderColor=AppColor.CGColor;
        self.titleLabel.backgroundColor=[UIColor whiteColor];
        self.titleLabel.textColor=AppColor;
    }
}
- (void)setState:(StartState)state{
    _state=state;
    switch (state) {
        case StartStateDefault:
            [self setSelect:NO];
            break;
        case StartStateBack:
            [self setSelect:YES];
            break;
        default:{
            self.titleLabel.layer.borderColor=Appx999999.CGColor;
            self.titleLabel.backgroundColor=[UIColor whiteColor];
            self.titleLabel.textColor=Appx999999;
        }
            break;
    }
}
@end
