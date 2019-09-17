//
//  ReadContentViewController.h
//  novel
//
//  Created by 黎铭轩 on 4/9/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "BaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface ReadContentViewController : BaseViewController
@property (assign, nonatomic, readonly)NSInteger pageIndex;
@property (assign, nonatomic, readonly)NSInteger chapterIndex;
-(void)setCurrentPage:(NSInteger)currentPage totalPage:(NSInteger)totalPage chapter:(NSInteger)chapter title:(NSString *)title bookName:(NSString *)bookName content:(NSAttributedString *)content;
@end

NS_ASSUME_NONNULL_END
