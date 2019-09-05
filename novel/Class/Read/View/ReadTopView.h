//
//  ReadTopView.h
//  novel
//
//  Created by 黎铭轩 on 4/9/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReadTopView : UIView
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
+(instancetype)readView;
@end

NS_ASSUME_NONNULL_END
