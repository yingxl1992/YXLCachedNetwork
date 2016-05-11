//
//  YXLMemeryCache.m
//  YXLCachedNetwork
//
//  Created by yingxl1992 on 16/3/2.
//  Copyright © 2016年 yingxl1992. All rights reserved.
//

#import "YXLMemoryCache.h"
#import "YXLCacheModel.h"
#import "NSDate+RCF.h"
#import "YXLDiskCache.h"

@interface YXLMemoryCache ()

@property (nonatomic, strong) NSArray *memoryCaches;//便于实现队列等

@property (nonatomic, strong) YXLDiskCache *diskCache;

@property (nonatomic, strong) NSMutableArray *L1;
@property (nonatomic, strong) NSMutableArray *L2;

@end

@implementation YXLMemoryCache

static YXLMemoryCache *sharedMemoryCache;

+ (instancetype)memoryCache {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMemoryCache = [[YXLMemoryCache alloc] init];
        sharedMemoryCache.memoryCaches = [NSArray array];
        sharedMemoryCache.memoryCapacity = 50;//代表请求个数，因为无法计算数据量
    });
    
    return sharedMemoryCache;    
}

- (YXLCacheModel *)cachedMemoryDataWithUrl:(NSString *)url {
    YXLCacheModel *cacheModel = [self hasMemoryCacheDataForUrl:url];
    if (!cacheModel) {
        [self.diskCache cachedDataWithUrl:url];
    }
    return cacheModel;
}

- (YXLCacheModel *)hasMemoryCacheDataForUrl:(NSString *)url {
    for (YXLCacheModel *cache in _memoryCaches) {
        if ([cache.key isEqualToString:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]) {
            NSMutableArray *tmpCaches = [NSMutableArray arrayWithArray:_memoryCaches];
            [tmpCaches removeObject:cache];
            [tmpCaches insertObject:cache atIndex:0];
            self.memoryCaches = [tmpCaches copy];
            return cache;
        }
    }
    return nil;
}

- (void)setCacheData:(YXLCacheModel *)data forKey:(NSString *)key {
    NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:_memoryCaches];
    [tmpArray insertObject:data atIndex:0];
    
    if (_memoryCaches.count > _memoryCapacity) {
        YXLCacheModel *deletedCacheModel = [tmpArray lastObject];
        [tmpArray removeObject:deletedCacheModel];
        
        if (!self.diskCache) {
            self.diskCache = [[YXLDiskCache alloc] init];
        }
        [self.diskCache addCacheData:deletedCacheModel forKey:key];
    }
    self.memoryCaches = [tmpArray copy];
}

//- (YXLCacheModel *)getExpiredOrLRUCacheModel {
//    for (YXLCacheModel *cacheModel in _memoryCaches) {
//        NSString *expireDateString = cacheModel.expiresDate;
//        NSDate *expireDate = [NSDate dateFromRCFString:expireDateString];
//        NSDate *currentDate = [NSDate date];
//        if ([currentDate compare:expireDate] == NSOrderedDescending) {
//            return cacheModel;
//        }
//    }
//    return [_memoryCaches objectAtIndex:0];
//}

@end
