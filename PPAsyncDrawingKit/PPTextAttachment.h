//
//  PPTextAttachment.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/29.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PPAsyncDrawingKitUtilities.h"

NS_ASSUME_NONNULL_BEGIN

@interface PPTextAttachment : NSObject <NSCoding>
@property (nonatomic, copy) NSString *replacementText;
@property (nonatomic, assign) PPFontMetrics baselineFontMetrics;
@property (nonatomic, strong) id contents;
@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;
@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, assign) UIViewContentMode contentType;
@property (nonatomic, copy, readonly) NSString *replacementTextForLength;
@property (nonatomic, copy, readonly) NSString *replacementTextForCopy;
@property (nonatomic, assign, readonly) PPFontMetrics fontMetricsForLayout;
@property (nonatomic, assign, readonly) CGSize placeholderSize;

+ (instancetype)attachmentWithContents:(id)contents type:(UIViewContentMode)type contentSize:(CGSize)contentSize;
- (void)updateContentEdgeInsetsWithTargetPlaceholderSize:(CGSize)placeholderSize;
- (BOOL)updateContentSizeWithOptions:(id)options;
- (CGFloat)ascentForLayout;
- (CGFloat)descentForLayout;
- (CGFloat)leadingForLayout;
@end

@interface PPTextAttachment (Updating)
- (BOOL)updateContentSizeWithOptions:(id)arg1;
@end

static void PPRunDelegateDeallocCallback(void *ref) { }

static CGFloat PPRunDelegateGetAscentCallback(void *ref) {
    PPTextAttachment *attachment = (__bridge PPTextAttachment *)(ref);
    if ([attachment isKindOfClass:[PPTextAttachment class]]) {
        CGFloat height = [attachment ascentForLayout];
        return height;
    }
    return 0.0f;
}

static CGFloat PPRunDelegateGetWidthCallback(void *ref) {
    PPTextAttachment *attachment = (__bridge PPTextAttachment *)(ref);
    if ([attachment isKindOfClass:[PPTextAttachment class]]) {
        return [attachment placeholderSize].width;
    }
    return 0.0f;
}

static CGFloat PPRunDelegateGetDecentCallback(void *ref) {
    return 0;
}

NS_ASSUME_NONNULL_END