//
//  ClassflyTableViewCell.h
//  novel
//
//  Created by 黎铭轩 on 10/8/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GKBookModel;
NS_ASSUME_NONNULL_BEGIN

@interface ClassflyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *focusButton;
@property (weak, nonatomic) IBOutlet UIButton *stateButton;
@property (weak, nonatomic) IBOutlet UILabel *MonthLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width;
@property (strong, nonatomic)GKBookModel *model;
@end

NS_ASSUME_NONNULL_END
