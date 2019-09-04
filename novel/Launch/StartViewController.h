//
//  StartViewController.h
//  novel
//
//  Created by 黎铭轩 on 15/7/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "BaseConnectionController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^Completion)(void);
@interface StartViewController : BaseConnectionController
@property (copy, nonatomic)Completion completion;
+(instancetype)viewControllerWithCompletion:(Completion)completion;
@end

NS_ASSUME_NONNULL_END
