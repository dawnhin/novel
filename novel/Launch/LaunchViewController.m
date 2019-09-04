//
//  LaunchViewController.m
//  novel
//
//  Created by 黎铭轩 on 16/7/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "LaunchViewController.h"
#import "LaunchSubView.h"
#import "Lottie.h"
@interface LaunchViewController ()
@property (strong, nonatomic)LaunchSubView *launchSubView;
@property (strong, nonatomic)UIButton *skipButton;
@property (strong, nonatomic)NSTimer *timer;
@property (strong, nonatomic)LOTAnimationView *playView;
@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.launchSubView];
    [self.launchSubView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-TAB_BAR_ADDING);
        make.height.mas_equalTo(150);
    }];
    [self.view addSubview:self.skipButton];
    [self.skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(44);
        make.top.equalTo(self.view).offset(STATUS_BAR_HIGHT);
        make.left.equalTo(self.view).offset(20);
    }];
    [self.skipButton addTarget:self action:@selector(skipAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playView];
    [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.height.offset(SCALEW(250));
    }];
    __weak typeof(self)WeakSelf=self;
    [self.playView playFromProgress:0 toProgress:2 withCompletion:^(BOOL animationFinished) {
        if (animationFinished) {
            WeakSelf.playView.alpha=1;
            [UIView animateWithDuration:0.25 animations:^{
                WeakSelf.playView.alpha=1;
            }completion:^(BOOL finished) {
                if (finished) {
                    [WeakSelf.playView removeFromSuperview];
                }
            }];
        }
    }];
    [self startTimer];
}
-(void)skipAction{
    [self stopTimer];
    [self dismissController];
}
#pragma mark - 开启定时器
-(void)startTimer{
    __block NSInteger time=4;
    [self.skipButton setTitle:[NSString stringWithFormat:@"%ldS",time] forState:UIControlStateNormal];
    __weak typeof(self)WeakSelf=self;
    self.timer=[NSTimer timerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
        if (time==1) {
            [WeakSelf skipAction];
        }
        time -= 1;
        [WeakSelf.skipButton setTitle:[NSString stringWithFormat:@"%ldS",time] forState:UIControlStateNormal];
    } repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
#pragma mark - 关闭定时器
-(void)stopTimer{
    if ([self.timer isValid]) {
        [self.timer invalidate];
    }
    self.skipButton.hidden=YES;
    self.timer=nil;
}
#pragma mark - 返回
-(void)dismissController{
    [UIView animateWithDuration:0.35 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.view.alpha=0;
    } completion:^(BOOL finished) {
        [self goBack];
    }];
}
- (void)dealloc
{
    NSLog(@"dealloc");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (UIButton *)skipButton{
    if (!_skipButton) {
        _skipButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _skipButton.titleLabel.font=[UIFont systemFontOfSize:16];
        [_skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _skipButton.backgroundColor=Appx999999;
        _skipButton.layer.cornerRadius=22;
        _skipButton.layer.masksToBounds=YES;
    }
    return _skipButton;
}
- (LOTAnimationView *)playView{
    if (!_playView) {
        _playView=[LOTAnimationView animationNamed:@"Launch.json"];
        _playView.loopAnimation=NO;
    }
    return _playView;
}
- (LaunchSubView *)launchSubView{
    if (!_launchSubView) {
        _launchSubView=[LaunchSubView instanceView];
    }
    return _launchSubView;
}
@end
