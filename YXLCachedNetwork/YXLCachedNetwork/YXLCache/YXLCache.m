//
//  YXLCache.m
//  YXLCachedNetwork
//
//  Created by yingxl1992 on 16/3/2.
//  Copyright © 2016年 yingxl1992. All rights reserved.
//

#import "YXLCache.h"
#import "YXLMemoryCache.h"
#import "YXLDiskCache.h"
#import "YXLCacheModel.h"

@interface YXLCache ()

@property (nonatomic, strong) YXLMemoryCache *memoryCache;
@property (nonatomic, strong) YXLDiskCache *diskCache;

@end

@implementation YXLCache

- (instancetype)init {
    self = [super init];
    if (self) {
        self.memoryCache = [YXLMemoryCache memoryCache];
        self.diskCache = [[YXLDiskCache alloc] init];
    }
    return self;
}

- (YXLCacheModel *)cachedDataWithUrl:(NSString *)url {
    YXLCacheModel *memoryCache = [self.memoryCache cachedMemoryDataWithUrl:url];
    if (memoryCache) {
        return memoryCache;
    }
    
    YXLCacheModel *diskCache = [self.diskCache cachedDataWithUrl:url];
    if (diskCache) {
        [self.memoryCache setCacheData:diskCache forKey:url];
        return diskCache;
    }
    
    return nil;
}

- (void)saveResponseData:(YXLCacheModel *)data forUrl:(NSString *)url {
    [self.memoryCache setCacheData:data forKey:url];
    
//    [self.diskCache addCacheData:data forKey:url];
}

- (void)saveResponseData:(NSDictionary *)data forUrl:(NSString *)url withLifeExpiration:(NSInteger)expiration {
    
}

@end
