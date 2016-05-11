//
//  YXLCache.m
//  YXLCachedNetwork
//
//  Created by yingxl1992 on 16/3/2.
//  Copyright © 2016年 yingxl1992. All rights reserved.
//

#import "YXLCache.h"
#import "YXLARCMemoryCache.h"
#import "YXLMemoryCache.h"
#import "YXLCacheModel.h"

@interface YXLCache ()

@property (nonatomic, strong) YXLARCMemoryCache *arcMemoryCache;
@property (nonatomic, strong) YXLMemoryCache *memoryCache;

@end

@implementation YXLCache

- (instancetype)init {
    self = [super init];
    if (self) {
        self.arcMemoryCache = [YXLARCMemoryCache ARCMemoryCache];
        self.memoryCache = [YXLMemoryCache memoryCache];
    }
    return self;
}

- (YXLCacheModel *)cachedDataWithUrl:(NSString *)url {
#ifndef FIFO_CACHE_POLICY
    YXLCacheModel *memoryCache = [self.arcMemoryCache cachedMemoryDataWithUrl:url];
#endif
#ifdef FIFO_CACHE_POLICY
    YXLCacheModel *memoryCache = [self.memoryCache cachedMemoryDataWithUrl:url];
#endif
    return memoryCache;
}

- (void)saveResponseData:(YXLCacheModel *)data forUrl:(NSString *)url {
#ifndef FIFO_CACHE_POLICY
    [self.arcMemoryCache setCacheData:data forKey:url];
#endif
#ifdef FIFO_CACHE_POLICY
    [self.memoryCache setCacheData:data forKey:url];
#endif
}

@end
