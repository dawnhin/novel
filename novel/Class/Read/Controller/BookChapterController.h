//
//  BookChapterController.h
//  novel
//
//  Created by 黎铭轩 on 4/9/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BookChapterController : BaseTableViewController
+(instancetype)viewControllerWithChapter:(NSString *)bookSourceID chapter:(NSInteger)chapter completion:(void (^)(NSInteger index))completion;
@end

NS_ASSUME_NONNULL_END
