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

//@property (nonatomic, strong) YXLARCMemoryCache *arcMemoryCache;
//@property (nonatomic, strong) YXLMemoryCache *memoryCache;

@end

@implementation YXLCache

//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        self.arcMemoryCache = [YXLARCMemoryCache ARCMemoryCache];
//        self.memoryCache = [YXLMemoryCache memoryCache];
//    }
//    return self;
//}

- (YXLCacheModel *)cachedDataWithUrl:(NSString *)url {
    YXLCacheModel *memoryCache;
    if (_cacheType == YXLCacheType_ARC) {
        memoryCache = [[YXLARCMemoryCache ARCMemoryCache] cachedMemoryDataWithUrl:url];
    }
    else {
        memoryCache = [[YXLMemoryCache memoryCache] cachedMemoryDataWithUrl:url];
    }
    return memoryCache;
}

- (void)saveResponseData:(YXLCacheModel *)data forUrl:(NSString *)url {
    if (_cacheType == YXLCacheType_ARC) {
        [[YXLARCMemoryCache ARCMemoryCache] setCacheData:data forKey:url];
    }
    else {
        [[YXLMemoryCache memoryCache] setCacheData:data forKey:url];
    }
}

@end
