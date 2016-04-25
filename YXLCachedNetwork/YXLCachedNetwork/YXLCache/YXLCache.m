//
//  YXLCache.m
//  YXLCachedNetwork
//
//  Created by yingxl1992 on 16/3/2.
//  Copyright © 2016年 yingxl1992. All rights reserved.
//

#import "YXLCache.h"
#import "YXLARCMemoryCache.h"
//#import "YXLARCDiskCache.h"
//#import "YXLMemoryCache.h"
//#import "YXLDiskCache.h"
#import "YXLCacheModel.h"

@interface YXLCache ()

@property (nonatomic, strong) YXLARCMemoryCache *memoryCache;
//@property (nonatomic, strong) YXLARCDiskCache *diskCache;

@end

@implementation YXLCache

- (instancetype)init {
    self = [super init];
    if (self) {
        self.memoryCache = [YXLARCMemoryCache ARCMemoryCache];
    }
    return self;
}

- (YXLCacheModel *)cachedDataWithUrl:(NSString *)url {
    YXLCacheModel *memoryCache = [self.memoryCache cachedMemoryDataWithUrl:url];
    return memoryCache;
}

- (void)saveResponseData:(YXLCacheModel *)data forUrl:(NSString *)url {
    [self.memoryCache setCacheData:data forKey:url];
}

@end
