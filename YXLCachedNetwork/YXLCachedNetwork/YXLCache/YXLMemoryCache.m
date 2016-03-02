//
//  YXLMemeryCache.m
//  YXLCachedNetwork
//
//  Created by yingxl1992 on 16/3/2.
//  Copyright © 2016年 yingxl1992. All rights reserved.
//

#import "YXLMemoryCache.h"
#import "YXLCacheModel.h"

@interface YXLMemoryCache ()

@property (nonatomic, strong) NSMutableArray *memoryCaches;//便于实现队列等

@end

@implementation YXLMemoryCache

static YXLMemoryCache *sharedMemoryCache;

+ (instancetype)memoryCache {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMemoryCache = [[YXLMemoryCache alloc] init];
        sharedMemoryCache.memoryCaches = [NSMutableArray array];
    });
    
    return sharedMemoryCache;    
}

- (NSDictionary *)cachedMemoryDataWithUrl:(NSString *)url {
    for (YXLCacheModel *cache in _memoryCaches) {
        if ([cache.key isEqualToString:url]) {
            [_memoryCaches removeObject:cache];
            return cache.data;
        }
    }
    return nil;
}

- (void)setCacheData:(NSDictionary *)data forKey:(NSString *)key {
    YXLCacheModel *cacheModel = [[YXLCacheModel alloc] init];
    cacheModel.key = key;
    cacheModel.data = data;
    [_memoryCaches addObject:cacheModel];
    
    //进行存储限制判断
}

@end
