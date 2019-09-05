//
//  ReadBottomView.m
//  novel
//
//  Created by 黎铭轩 on 4/9/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "ReadBottomView.h"

@implementation ReadBottomView
+ (instancetype)bottomView{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}
- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor=Appx252631;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
