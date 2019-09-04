//
//  ReadContentController.m
//  novel
//
//  Created by 黎铭轩 on 6/8/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "ReadContentController.h"

@interface ReadContentController ()
@property (strong, nonatomic)GKBookDetailModel *model;
@end

@implementation ReadContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
+ (instancetype)viewControllerWithDetailModel:(GKBookDetailModel *)model{
    ReadContentController *viewController=[[ReadContentController alloc]init];
    viewController.model=model;
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

@end
