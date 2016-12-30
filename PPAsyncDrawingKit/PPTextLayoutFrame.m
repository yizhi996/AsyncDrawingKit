//
//  PPTextLayoutFrame.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/14.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPTextLayoutFrame.h"
#import "PPTextLayout.h"
#import "PPTextLayoutLine.h"

@implementation PPTextLayoutFrame

- (instancetype)initWithCTFrame:(CTFrameRef)frame layout:(PPTextLayout *)layout
{
    if (self = [super init]) {
        if (layout) {
            self.layout = layout;
            [self setupWithCTFrame:frame];
        }
    }
    return self;
}

- (void)setupWithCTFrame:(CTFrameRef)frame
{
//    NSInteger maxLines = self.layout.maximumNumberOfLines;
//    CFArrayRef lineRefs = CTFrameGetLines(frame);
//    CFIndex lineCount = CFArrayGetCount(lineRefs);
//    NSMutableArray *lines = [NSMutableArray array];
//    CGRect rect = CGRectZero;
//    if (lineCount > 0) {
//        CGPoint *origins = malloc(lineCount * sizeof(CGPoint));
//        CTFrameGetLineOrigins(frame, CFRangeMake(0, lineCount), origins);
//        
//        for (NSInteger i = 0; i < lineCount; i++) {
//            CTLineRef lineRef = CFArrayGetValueAtIndex(lineRefs, i);
//            if (maxLines == 0) {
//                PPTextLayoutLine *line = [[PPTextLayoutLine alloc] initWithCTLine:lineRef origin:origins[i] layout:self.layout];
//                [lines addObject:line];
//                if (i == 0) {
//                    rect = line.fragmentRect;
//                } else {
//                    rect = CGRectUnion(rect, line.fragmentRect);
//                }
//            } else if (maxLines - 1 != 0) {
//                NSLog(@"%zd", self.layout.maximumNumberOfLines);
//            } else {
//                NSLog(@"%zd", self.layout.maximumNumberOfLines);
//            }
//
//        }
//    }
//    self.lineFragments = [NSArray arrayWithArray:lines];
//    self.layoutSize = rect.size;
    NSInteger maxLines = self.layout.maximumNumberOfLines;
    CFArrayRef lineRefs = CTFrameGetLines(frame);
    if (maxLines == 0) {
        maxLines = CFArrayGetCount(lineRefs);
    }
    CGPoint origins[maxLines];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
    NSMutableArray *lines = [NSMutableArray array];
    CGRect rect = CGRectZero;
    for (NSInteger i = 0; i < maxLines; i++) {
        CTLineRef lineRef = CFArrayGetValueAtIndex(lineRefs, i);
        PPTextLayoutLine *line = [[PPTextLayoutLine alloc] initWithCTLine:lineRef origin:origins[i] layout:self.layout];
        [lines addObject:line];
        if (i == 0) {
            rect = line.fragmentRect;
        } else {
            rect = CGRectUnion(rect, line.fragmentRect);
        }
    }
    self.lineFragments = [NSArray arrayWithArray:lines];
    self.layoutSize = rect.size;
}

- (CTLineRef)textLayout:(PPTextLayout *)layout truncateLine:(CTLineRef)truncateLine atIndex:(NSUInteger)index truncated:(BOOL)truncated
{
//    if (truncateLine) {
//        CFRange stringRange = CTLineGetStringRange(truncateLine);
//        if (layout) {
//            
//        }
//        CGFloat maxWidth = [self textLayout:layout maximumWidthForTruncatedLine:truncateLine atIndex:index];
//        CGFloat width = CTLineGetTypographicBounds(truncateLine, 0, 0, 0);
//        NSAttributedString *attributedString = layout.attributedString;
//        NSDictionary<NSString *, id> *attributes = [attributedString attributesAtIndex:index effectiveRange:nil];
//        NSArray *keys = @[(id)kCTForegroundColorAttributeName, (id)kCTFontAttributeName, (id)kCTParagraphStyleAttributeName];
//        attributes = [attributes dictionaryWithValuesForKeys:keys];
//        [attributes enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//            
//        }];
//        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
//    }
    return nil;
}

- (CGFloat)textLayout:(PPTextLayout *)layout maximumWidthForTruncatedLine:(CTLineRef)maximumWidthForTruncatedLine atIndex:(NSUInteger)index
{
    if ([layout.delegate respondsToSelector:@selector(textLayout:maximumWidthForLineTruncationAtIndex:)]) {
        return [layout.delegate textLayout:layout maximumWidthForLineTruncationAtIndex:index];
    } else {
        return layout.size.width;
    }
}

@end

@implementation PPTextLayoutFrame (LayoutResult)
- (CGRect)firstSelectionRectForCharacterRange:(NSRange)range
{
    [self enumerateSelectionRectsForCharacterRange:range usingBlock:^{
        
    }];
    return CGRectZero;
}

- (NSUInteger)lineFragmentIndexForCharacterAtIndex:(NSUInteger)index
{
    [self.lineFragments enumerateObjectsUsingBlock:^(PPTextLayoutLine * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
    }];
    return 0;
}

- (void)enumerateLineFragmentsForCharacterRange:(NSRange)range usingBlock:(void (^)(void))block
{
    [self.lineFragments enumerateObjectsUsingBlock:^(PPTextLayoutLine * _Nonnull line, NSUInteger idx, BOOL * _Nonnull stop) {
//        line.fragmentRect;
//        line.stringRange;
    }];
}

- (void)enumerateEnclosingRectsForCharacterRange:(NSRange)range usingBlock:(nonnull void (^)(CGRect, BOOL * _Nonnull))block
{
    if (block) {
        if (self.lineFragments.count) {
            __block CGFloat y = 0;
            [self.lineFragments enumerateObjectsUsingBlock:^(PPTextLayoutLine * _Nonnull line, NSUInteger idx, BOOL * _Nonnull stop) {
//                if (range.location >= line.stringRange.location && (range.location + range.length) <= line.stringRange.location + line.stringRange.length) {
                NSRange lineRange = line.stringRange;
                if (range.location >= lineRange.location) {
                    if (range.length + range.location <= lineRange.length + lineRange.location) {
                        CGFloat left = [line offsetXForCharacterAtIndex:range.location];
                        CGFloat right = [line offsetXForCharacterAtIndex:range.location + range.length];
                        CGRect rect = CGRectMake(left, (line.fragmentRect.size.height + 1) * idx, right - left, line.fragmentRect.size.height);
                        block(rect, stop);
                    }
                }

//                }
            }];
        }
    }
}

- (CGRect)enumerateSelectionRectsForCharacterRange:(NSRange)range usingBlock:(void (^)(void))block
{
//    [self enumerateEnclosingRectsForCharacterRange:range usingBlock:^{
//        
//    }];
    return CGRectZero;
}

@end