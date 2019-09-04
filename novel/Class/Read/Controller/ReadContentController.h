//
//  ReadContentController.h
//  novel
//
//  Created by 黎铭轩 on 6/8/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "BaseViewController.h"
@class GKBookDetailModel;
NS_ASSUME_NONNULL_BEGIN

@interface ReadContentController : BaseViewController
+(instancetype)viewControllerWithDetailModel:(GKBookDetailModel *)model;
@end

NS_ASSUME_NONNULL_END
