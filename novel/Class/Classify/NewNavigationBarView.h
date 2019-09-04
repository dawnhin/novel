//
//  NewNavigationBarView.h
//  novel
//
//  Created by 黎铭轩 on 28/8/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewNavigationBarView : UIView
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (assign, nonatomic) UserState state;
+(instancetype)navigationBar;
@end

NS_ASSUME_NONNULL_END
