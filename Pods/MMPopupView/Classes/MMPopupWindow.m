//
//  MMPopupWindow.m
//  MMPopupView
//
//  Created by Ralph Li on 9/6/15.
//  Copyright © 2015 LJC. All rights reserved.
//

#import "MMPopupWindow.h"
#import "MMPopupCategory.h"
#import "MMPopupDefine.h"
#import "MMPopupView.h"

@interface MMPopupWindow()
<
UIGestureRecognizerDelegate
>

@end

@implementation MMPopupWindow

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if ( self )
    {
        self.windowLevel = UIWindowLevelStatusBar + 1;
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)];
        gesture.cancelsTouchesInView = NO;
        gesture.delegate = self;
        [self addGestureRecognizer:gesture];
    }
    return self;
}

+ (MMPopupWindow *)sharedWindow
{
    static MMPopupWindow *window;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        window = [[MMPopupWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        window.rootViewController = [UIViewController new];
    });
    
    return window;
}

- (void)cacheWindow
{
    [self makeKeyAndVisible];
    [[[UIApplication sharedApplication].delegate window] makeKeyAndVisible];
    
    [self attachView].mm_dimBackgroundView.hidden = YES;
    self.hidden = YES;
}

- (void)actionTap:(UITapGestureRecognizer*)gesture
{
    if ( !self.mm_dimBackgroundAnimating )
    {
        for ( MMPopupView *v in [self attachView].mm_dimBackgroundView.subviews )
        {
            if ( [v isKindOfClass:[MMPopupView class]] && v.touchWildToHide)
            {
                [v hide];
                if (v.touchToHideBlock) {
                    v.touchToHideBlock(v);
                }
            }
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return ( touch.view == self.attachView.mm_dimBackgroundView );
}

- (UIView *)attachView
{
    return self.rootViewController.view;
}

#pragma mark - autorotate
- (UIViewController *)preferredVC {
    return [[[UIApplication sharedApplication] delegate] window].rootViewController;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return [[self preferredVC] preferredStatusBarStyle];
}
- (BOOL)prefersStatusBarHidden {
    return [[self preferredVC] prefersStatusBarHidden];
}
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return [[self preferredVC] preferredStatusBarUpdateAnimation];
}
- (BOOL)shouldAutorotate {
    return [[self preferredVC] shouldAutorotate];
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [[self preferredVC] supportedInterfaceOrientations];
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [[self preferredVC] preferredInterfaceOrientationForPresentation];
}
@end
