//
//  CollectionViewLayout.m
//  novel
//
//  Created by 黎铭轩 on 17/7/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "CollectionViewLayout.h"
@interface CollectionViewLayout()
@property (assign, nonatomic)LayoutStyle style;
@property (strong, nonatomic)NSMutableArray *layoutAttributeArray;
@property (assign, nonatomic)CGFloat maxHeight;
@end
@implementation CollectionViewLayout
+ (instancetype)viewControllerWithStyle:(LayoutStyle)style{
    CollectionViewLayout *viewController=[[CollectionViewLayout alloc]init];
    viewController.style=style;
    return viewController;
}
- (void)prepareLayout{
    [super prepareLayout];
    self.style == LayoutStyleTag ? [self setupTagViewLayout]:[self setupRecommendViewLayout];
}
- (CGSize)collectionViewContentSize{
    return CGSizeMake(self.collectionView.width, -_maxHeight);
}
-(void)setupTagViewLayout{
    self.layoutAttributeArray=[NSMutableArray array].mutableCopy;
    __block CGFloat x=self.minimumInteritemSpacing;
    __block CGFloat y=self.minimumLineSpacing;
    [self.dataArray enumerateObjectsUsingBlock:^(RankModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UICollectionViewLayoutAttributes *attribute=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:idx inSection:0]];
        NSString *tag=obj.shortTitle;
        CGSize size=[tag boundingRectWithSize:CGSizeMake(1000, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        size.width+=18;
        size.height+=5;
        if (x+size.width+self.minimumInteritemSpacing>self.collectionView.width) {
            x = self.minimumInteritemSpacing;
            y += size.height+self.minimumLineSpacing;
        }
        attribute.frame=CGRectMake(x, y, size.width, size.height);
        x+=attribute.frame.size.width+self.minimumInteritemSpacing;
        self.maxHeight=y+size.height+self.minimumLineSpacing;
        [self.layoutAttributeArray addObject:attribute];
    }];
}
-(void)setupRecommendViewLayout{
    self.layoutAttributeArray=[NSMutableArray array].mutableCopy;
    [self.layoutAttributeArray addObject:[self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]];
    self.headerReferenceSize=CGSizeMake(self.collectionView.width, 44);
    CGFloat ratio=45/36;
    NSInteger maxBooks=SCREEN_WIDTH > 400 ? 5:4;
    CGFloat space=SCREEN_WIDTH > 350 ? 25:20;
    CGFloat width=(self.collectionView.width-(maxBooks+1)*space)/maxBooks;
    CGFloat x=space;
    CGFloat y=self.headerReferenceSize.height;
    for (NSInteger i=0; i<MIN(self.dataArray.count, maxBooks
                              ); i++) {
        UICollectionViewLayoutAttributes *attributes=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        NSString *book=self.dataArray[i].shortTitle;
        CGSize size=[book boundingRectWithSize:CGSizeMake(width-2, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSForegroundColorAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        size.height += width*ratio+5;
        attributes.frame=CGRectMake(x, y, width, size.height);
        x += attributes.frame.size.width+space;
        if (y+size.height > self.maxHeight) {
            self.maxHeight=y+size.height;
        }
        [self.layoutAttributeArray addObject:attributes];
    }
}
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.layoutAttributeArray.copy;
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attributes=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    return attributes;
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attributes=[UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:elementKind withIndexPath:indexPath];
    attributes.frame=CGRectMake(0, 0, self.collectionView.width, 40);
    return attributes;
}
@end
