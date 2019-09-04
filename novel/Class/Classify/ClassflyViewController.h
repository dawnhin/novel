//
//  ClassflyViewController.h
//  novel
//
//  Created by 黎铭轩 on 30/8/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ClassflyViewController : BaseTableViewController
+(instancetype)viewControllerWithGroup:(NSString *)group name:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
