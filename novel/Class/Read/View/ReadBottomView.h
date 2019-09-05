//
//  ReadBottomView.h
//  novel
//
//  Created by 黎铭轩 on 4/9/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReadBottomView : UIView
@property (weak, nonatomic) IBOutlet ATImageTopButton *dayButton;
@property (weak, nonatomic) IBOutlet ATImageTopButton *setButton;
@property (weak, nonatomic) IBOutlet ATImageTopButton *cateButton;
+(instancetype)bottomView;
@end

NS_ASSUME_NONNULL_END
