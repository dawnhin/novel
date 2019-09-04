//
//  BookDetailTabbar.m
//  novel
//
//  Created by 黎铭轩 on 13/8/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "BookDetailTabbar.h"

@implementation BookDetailTabbar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib{
    [super awakeFromNib];
    [self.addButton setTitle:@"缓存到书架" forState:UIControlStateNormal|UIControlStateHighlighted];
    [self.addButton setTitle:@"已在书架中" forState:UIControlStateSelected];
    [self.readButton setBackgroundColor:AppColor];
    [self.addButton setTitleColor:AppColor forState:UIControlStateNormal];
    [self.addButton setTitleColor:Appx999999 forState:UIControlStateSelected];
}
- (void)setCollect:(BOOL)collect{
    if (_collect!=collect) {
        _collect=collect;
        self.addButton.selected=collect;
    }
}
@end
