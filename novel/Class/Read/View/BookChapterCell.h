//
//  BookChapterCell.h
//  novel
//
//  Created by 黎铭轩 on 7/9/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKBookSourceModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BookChapterCell : UITableViewCell
@property (strong, nonatomic)UILabel *title;
@property (strong, nonatomic)UIImageView *image;
@property (strong, nonatomic)GKBookSourceModel *model;
@end

NS_ASSUME_NONNULL_END
