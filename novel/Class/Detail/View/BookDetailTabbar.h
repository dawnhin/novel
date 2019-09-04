//
//  BookDetailTabbar.h
//  novel
//
//  Created by 黎铭轩 on 13/8/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BookDetailTabbar : UIView
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *readButton;
@property (assign, nonatomic) BOOL collect;
@end

NS_ASSUME_NONNULL_END
