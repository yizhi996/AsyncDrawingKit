//
//  PPTextLayout.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/14.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPTextLayout.h"
#import <objc/objc-sync.h>
#import "PPTextLayoutLine.h"

@implementation PPTextLayout
{
    struct {
        unsigned int needsLayout: 1;
    } flags;
}

- (instancetype)init
{
    if (self = [super init]) {
        flags.needsLayout = 1;
        PPFontMetrics fontMetrics;
        self.baselineFontMetrics = fontMetrics;
    }
    return self;
}

- (instancetype)initWithAttributedString:(NSAttributedString *)attributedString
{
    if (self = [self init]) {
        self.attributedString = attributedString;
    }
    return self;
}

- (PPTextLayoutFrame *)layoutFrame
{
    if (flags.needsLayout != 0 || _layoutFrame == nil) {
        @synchronized (self) {
            _layoutFrame = [self createLayoutFrame];
        }
        flags.needsLayout = 0;
    }
    return _layoutFrame;
}

- (PPTextLayoutFrame *)createLayoutFrame
{
    PPTextLayoutFrame *textLayoutFrame;
    if (self.attributedString.length > 0) {
        CGMutablePathRef mutablePath;
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedString);
        if (self.exclusionPaths.count) {
            
        } else {
            mutablePath = CGPathCreateMutable();
            CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
            CGAffineTransform transform = CGAffineTransformIdentity;
            CGPathAddRect(mutablePath, &transform, rect);
        }
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, self.attributedString.length), mutablePath, NULL);
        CGPathRelease(mutablePath);
        CFRelease(framesetter);
        if (frame) {
            textLayoutFrame = [[PPTextLayoutFrame alloc] initWithCTFrame:frame layout:self];
            CFRelease(frame);
        }
    }
    return textLayoutFrame;
//    if (self.attributedString.length > 0) {
//        CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
//        UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
//        CGAffineTransform transform = CGAffineTransformIdentity;
//        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedString);
//        CTFrameRef frame;
//        if (self.exclusionPaths.count != 0) {
//            [self.exclusionPaths enumerateObjectsUsingBlock:^(UIBezierPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                [path appendPath:obj.copy];
//                [path applyTransform:transform];
//            }];
//            path.usesEvenOddFillRule = YES;
//            frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, self.attributedString.length), path.CGPath, NULL);
//        } else {
//            CGMutablePathRef mutablePath = CGPathCreateMutable();
//            CGPathAddRect(mutablePath, &transform, rect);
//            frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, self.attributedString.length), mutablePath, NULL);
//            CGPathRelease(mutablePath);
//        }
//        CFRelease(framesetter);
//        if (frame) {
//            PPTextLayoutFrame *textLayoutFrame = [[PPTextLayoutFrame alloc] initWithCTFrame:frame layout:self];
//            return textLayoutFrame;
//        }
//        return nil;
//    } else {
//        return nil;
//    }
}

- (void)setNeedsLayout
{
    flags.needsLayout = 1;
}

- (void)setAttributedString:(NSAttributedString *)attributedString
{
    if (_attributedString != attributedString) {
        @synchronized (self) {
            _attributedString = attributedString;
        }
        flags.needsLayout = 1;
    }
}

- (void)setExclusionPaths:(NSArray<UIBezierPath *> *)exclusionPaths
{
    if (_exclusionPaths != exclusionPaths) {
        _exclusionPaths = exclusionPaths;
        flags.needsLayout = 1;
    }
}

- (void)setSize:(CGSize)size
{
    if (!CGSizeEqualToSize(_size, size)) {
        _size = size;
        flags.needsLayout = 1;
    }
}

- (void)setMaximumNumberOfLines:(NSUInteger)maximumNumberOfLines
{
    if (_maximumNumberOfLines != maximumNumberOfLines) {
        _maximumNumberOfLines = maximumNumberOfLines;
        flags.needsLayout = 1;
    }
}

- (CGFloat)layoutHeight
{
    return self.layoutSize.height;
}

- (CGSize)layoutSize
{
    if (self.layoutFrame) {
        return self.layoutFrame.layoutSize;
    } else {
        return CGSizeZero;
    }
}
@end

@implementation PPTextLayout (LayoutResult)
- (NSRange)containingStringRange
{
    return [self containingStringRangeWithLineLimited:0];
}

- (NSRange)containingStringRangeWithLineLimited:(NSUInteger)lineLimited
{
    NSUInteger count = self.layoutFrame.lineFragments.count;
    NSRange range;
    if (count) {
        PPTextLayoutLine *line;
        if (count >= lineLimited) {
            line = self.layoutFrame.lineFragments[lineLimited];
        } else {
            line = self.layoutFrame.lineFragments.lastObject;
        }
        range = line.stringRange;
    }
    return range;
}

- (void)enumerateEnclosingRectsForCharacterRange:(NSRange)range usingBlock:(nonnull void (^)(CGRect, BOOL * _Nonnull))block
{
    [self.layoutFrame enumerateEnclosingRectsForCharacterRange:range usingBlock:block];
}
@end

@implementation PPTextLayout (Coordinates)
- (CGPoint)convertPointToCoreText:(CGPoint)point
{
    return CGPointMake(point.x, self.size.height - point.y);
}

- (CGPoint)convertPointFromCoreText:(CGPoint)point
{
    return CGPointMake(point.x, self.size.height - point.y);
}
@end