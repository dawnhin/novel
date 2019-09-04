//
//  ThemeTableViewCell.h
//  novel
//
//  Created by 黎铭轩 on 5/8/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ThemeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIImageView *imageIcon;
@property (strong, nonatomic)AppModel *model;
@end

NS_ASSUME_NONNULL_END
