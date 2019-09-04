//
//  NewNavigationBarView.m
//  novel
//
//  Created by 黎铭轩 on 28/8/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "NewNavigationBarView.h"

@implementation NewNavigationBarView
+ (instancetype)navigationBar{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][0];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib{
    [super awakeFromNib];
    self.searchView.layer.cornerRadius=AppRadius;
    self.searchView.layer.masksToBounds=YES;
    self.backgroundColor=AppColor;
}
- (void)setState:(UserState)state{
    if (_state!=state) {
        _state=state;
        [self.moreButton setImage:[UIImage imageNamed:state==UserBoy ? @"icon_boy_h":@"icon_girl_h"] forState:UIControlStateNormal];
    }
}
@end
