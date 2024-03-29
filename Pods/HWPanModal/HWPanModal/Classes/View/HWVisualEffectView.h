//
//  HWVisualEffectView.h
//  HWPanModal
//
//  Created by heath wang on 2019/6/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HWVisualEffectView : UIVisualEffectView

/**
 * tint color
 * default is nil
 */
@property (nonatomic, strong) UIColor *colorTint;
/**
 * tint color alpha
 * default is 0.0
 */
@property (nonatomic, assign) CGFloat colorTintAlpha;
/**
 * blur radius, change it to make blur affect
 * default is 0.0
 */
@property (nonatomic, assign) CGFloat blurRadius;
/**
 * scale factor.
 * default is 1.0
 */
@property (nonatomic, assign) CGFloat scale;

@end

NS_ASSUME_NONNULL_END
