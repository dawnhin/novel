//
//  SearchTextView.h
//  novel
//
//  Created by 黎铭轩 on 3/9/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchTextView : UIView
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
+(instancetype) searchView;
@end

NS_ASSUME_NONNULL_END
