//
//  YChapterContentModel.m
//  YReaderDemo
//
//  Created by yanxuewen on 2016/12/12.
//  Copyright © 2016年 yxw. All rights reserved.
//

#import "YChapterContentModel.h"
#import "YReaderSettings.h"
#import <CoreText/CoreText.h>

@interface YChapterContentModel ()

@property (strong, nonatomic) NSMutableArray *pageArr;
@property (strong, nonatomic) NSMutableAttributedString *attributedString;

@end

@implementation YChapterContentModel

+ (NSArray *)modelPropertyWhitelist {
    return @[@"title",@"body"];
}

- (void)updateContentPaging {
    [self pagingWithBounds:CGRectMake(kYReaderLeftSpace, kYReaderTopSpace, kScreenWidth - kYReaderLeftSpace - kYReaderRightSpace, kScreenHeight - kYReaderTopSpace - kYReaderBottomSpace)];
}

- (void)pagingWithBounds:(CGRect)bounds {
    _pageArr = @[].mutableCopy;
    NSMutableAttributedString *attr = [[NSMutableAttributedString  alloc] initWithString:self.body attributes:[YReaderSettings shareReaderSettings].readerAttributes];
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) attr);
    CGPathRef path = CGPathCreateWithRect(bounds, NULL);
    CFRange range = CFRangeMake(0, 0);
    NSUInteger rangeOffset = 0;
    do {
        CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(rangeOffset, 0), path, NULL);
        range = CTFrameGetVisibleStringRange(frame);
        rangeOffset += range.length;
        [_pageArr addObject:@(range.location)];
        if (frame) {
            CFRelease(frame);
        }
    } while (range.location + range.length < attr.length);
    if (path) {
        CFRelease(path);
    }
    if (frameSetter) {
        CFRelease(frameSetter);
    }
    _pageCount = _pageArr.count;
    _attributedString = attr;
}

- (NSAttributedString *)getStringWith:(NSUInteger)page {
    if (page < _pageArr.count) {
        NSUInteger loc = [_pageArr[page] integerValue];
        NSUInteger len = 0;
        if (page == _pageArr.count - 1) {
            len = _attributedString.length - loc;
        } else {
            len = [_pageArr[page + 1] integerValue] - loc;
        }
        return [_attributedString attributedSubstringFromRange:NSMakeRange(loc, len)];
    }
    return nil;
}

+ (instancetype)chapterModelWith:(NSString *)title link:(NSString *)link load:(BOOL)isLoadCache{
    YChapterContentModel *chapterM = [[YChapterContentModel alloc] init];
    chapterM.title = title;
    chapterM.link = link;
    chapterM.isLoadCache = isLoadCache;
    chapterM.body = @"正在为您加载...";
    chapterM.isLoad = NO;
    return chapterM;
}

@end
