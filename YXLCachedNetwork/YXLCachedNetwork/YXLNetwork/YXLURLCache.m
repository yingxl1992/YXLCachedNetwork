//
//  YXLURLCache.m
//  YXLCachedNetwork
//
//  Created by yingxl1992 on 16/1/29.
//  Copyright © 2016年 yingxl1992. All rights reserved.
//

#import "YXLURLCache.h"

@implementation YXLURLCache

+ (instancetype)sharedYXLCache {
    static YXLURLCache *sharedYXLURLCache = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedYXLURLCache = [[self alloc] init];
    });
    return sharedYXLURLCache;
}

@end
