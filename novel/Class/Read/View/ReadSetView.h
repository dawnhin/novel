//
//  ReadSetView.h
//  novel
//
//  Created by 黎铭轩 on 5/9/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKReadSetManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface ReadSetView : UIView
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (copy, nonatomic) void(^Setbrightness)(ReadSetView *setView,CGFloat brightness);
@property (copy, nonatomic) void(^Setfont)(ReadSetView *setView,CGFloat font);
@property (copy, nonatomic) void(^Setstate)(ReadSetView *setView,GKReadState state);
+(instancetype)setView;
- (void)loadData;
@end

NS_ASSUME_NONNULL_END
