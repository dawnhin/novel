//
//  ReadView.m
//  novel
//
//  Created by 黎铭轩 on 6/9/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "ReadView.h"
@interface ReadView()
@property (assign, nonatomic)CTFrameRef contentFrame;
@end
@implementation ReadView
- (void)setContent:(NSAttributedString *)content{
    _content=content;
    CTFramesetterRef setterRef=CTFramesetterCreateWithAttributedString((CFAttributedStringRef)content);
    CGPathRef pathRef=CGPathCreateWithRect(self.bounds, NULL);
    CTFrameRef frameRef=CTFramesetterCreateFrame(setterRef, CFRangeMake(0, 0), pathRef, NULL);
    if (setterRef) {
        CFRelease(setterRef);
    }
    if (pathRef) {
        CFRelease(pathRef);
    }
    self.contentFrame=frameRef;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (!_contentFrame) {
        return;
    }
    //获取上下文
    CGContextRef contextRef=UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(contextRef, CGAffineTransformIdentity);
    CGContextTranslateCTM(contextRef, 0, self.bounds.size.height);
    CGContextScaleCTM(contextRef, 1, -1);
    //描绘边框
    CTFrameDraw(_contentFrame, contextRef);
}
- (void)dealloc
{
    if (_contentFrame) {
        CFRelease(_contentFrame);
    }
}

@end
