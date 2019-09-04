//
//  SearchTextView.m
//  novel
//
//  Created by 黎铭轩 on 3/9/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "SearchTextView.h"

@implementation SearchTextView
+ (instancetype)searchView{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}
- (void)awakeFromNib{
    [super awakeFromNib];
    self.searchView.layer.cornerRadius=AppRadius;
    self.searchView.layer.masksToBounds=YES;
    self.backgroundColor=AppColor;
    self.textField.placeholder=@"作者/书名";
    [self.textField notifyChange:^NSInteger(UITextField *textField, NSString *text) {
        return 12;
    }];
    self.textField.tintColor=AppColor;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
