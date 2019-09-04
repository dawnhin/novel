//
//  HomeMoreTableViewController.h
//  novel
//
//  Created by 黎铭轩 on 10/8/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GKBookInfo;
@interface HomeMoreTableViewController : UITableViewController
+(instancetype)viewControllerWithBookInfo:(GKBookInfo *)bookInfo;
@end

NS_ASSUME_NONNULL_END
