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

- (NSDictionary *)cachedDataWithUrl:(NSString *)url {
    NSDictionary *memoryCache = [self.memoryCache cachedMemoryDataWithUrl:url];
    if (memoryCache) {
        return memoryCache;
    }
    
    NSDictionary *diskCache = [self.diskCache cachedDataWithUrl:url];
    if (diskCache) {
        return diskCache;
    }
    
    return nil;
}

- (void)saveResponseData:(NSData *)data forUrl:(NSString *)url {
    [self.memoryCache setCacheData:data forKey:url];
    
    [self.diskCache addCacheData:data forKey:url];
}

@end
