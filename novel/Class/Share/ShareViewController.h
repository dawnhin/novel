//
//  ShareViewController.h
//  novel
//
//  Created by 黎铭轩 on 14/8/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "BaseConnectionController.h"

NS_ASSUME_NONNULL_BEGIN
@class GKBookDetailModel;
@class GKBookListDetailModel;
@interface ShareViewController : BaseConnectionController
+(instancetype)viewControllerWithBookModel:(GKBookDetailModel *)model;
+(instancetype)viewControllerWithBookListModel:(GKBookListDetailModel *)model;
@end

NS_ASSUME_NONNULL_END
