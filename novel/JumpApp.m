//
//  JumpApp.m
//  novel
//
//  Created by 黎铭轩 on 15/7/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "JumpApp.h"
#import "UserManager.h"
#import <UIKit/UIKit.h>
#import "StartViewController.h"
#import "LaunchViewController.h"
#import "MineSelectController.h"
#import "ReadContentController.h"
#import "BookDetailController.h"
#import "BaseNavigationController.h"
@implementation JumpApp
+(void)jumpToAppGuidePage:(Completion)completion{
    BOOL reselect=[UserManager alreadySelect];
    if (!reselect) {
        [JumpApp window].rootViewController=[StartViewController viewControllerWithCompletion:completion];
    }
    else{
        if (completion) {
            completion();
        }
    }
    [self setAppLaunchController];
}
+(void)setAppLaunchController{
    UIViewController *root=[UIViewController rootTopPresentedController];
    LaunchViewController *launch=[[LaunchViewController alloc]init];
    launch.modalPresentationStyle=UIModalPresentationFullScreen;
    [root presentViewController:launch animated:YES completion:nil];
}
+ (void)jumpToAppTheme{
    [JumpApp window].rootViewController=[[NovelTabBarController alloc]init];
}
+(UIWindow *)window{
    UIApplication *application=[UIApplication sharedApplication];
    if ([application.delegate respondsToSelector:@selector(window)]) {
        return [application.delegate window];
    }
    else{
        return [application keyWindow];
    }
}
+ (void)jumpToAddSelect{
    UIViewController *rootViewController=[UIViewController rootTopPresentedController];
    MineSelectController *viewController=[[MineSelectController alloc]init];
    viewController.hidesBottomBarWhenPushed=YES;
    [rootViewController.navigationController pushViewController:viewController animated:YES];
}
+ (void)jumptoBookRead:(GKBookDetailModel *)model{
    UIViewController *rootViewController=[UIViewController rootTopPresentedController];
    ReadContentController *readContent=[ReadContentController viewControllerWithDetailModel:model];
    BaseNavigationController *navigationController=[[BaseNavigationController alloc]initWithRootViewController:readContent];
    readContent.hidesBottomBarWhenPushed=YES;
    [rootViewController presentViewController:navigationController animated:YES completion:nil];
}
+ (void)jumpToBookCase{
    
}
+ (void)jumpToBookHistory{
    
}
+ (void)jumpToBookDetail:(NSString *)bookID{
    UIViewController *viewController=[UIViewController rootTopPresentedController];
    BookDetailController *detail=[BookDetailController viewControllerWithBookID:bookID];
    detail.hidesBottomBarWhenPushed=YES;
    [viewController.navigationController pushViewController:detail animated:YES];
}
@end
