//
//  BookDetailController.h
//  novel
//
//  Created by 黎铭轩 on 13/8/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "BaseConnectionController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BookDetailController : BaseConnectionController
+(instancetype)viewControllerWithBookID:(NSString *)bookID;
@end

NS_ASSUME_NONNULL_END
