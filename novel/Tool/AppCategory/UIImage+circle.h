//
//  UIImage+circle.h
//  novel
//
//  Created by 黎铭轩 on 5/9/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface UIImage (circle)
+ (UIImage *)circleImageWithName:(UIImage *)oldImage borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
+ (UIImage *)originImage:(UIImage *)image scaleToSize:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
