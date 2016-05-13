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

@property (nonatomic, strong) NSMutableArray *memoryCaches;//便于实现队列等
@property (nonatomic, assign) NSInteger hitCount;

@end

@implementation YXLMemoryCache

static YXLMemoryCache *sharedMemoryCache;

+ (instancetype)memoryCache {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMemoryCache = [[YXLMemoryCache alloc] init];
        sharedMemoryCache.memoryCaches = [NSMutableArray array];
        sharedMemoryCache.memoryCapacity = 30;//代表请求个数，因为无法计算数据量
        sharedMemoryCache.hitCount = 0;
    });
    
    return sharedMemoryCache;    
}

- (YXLCacheModel *)cachedMemoryDataWithUrl:(NSString *)url {
    NSLog(@"memerycache的长度%ld", _memoryCaches.count);
    YXLCacheModel *cacheModel = [self hasMemoryCacheDataForUrl:url];
    if (!cacheModel) {
        [[YXLDiskCache DiskCache] cachedDataWithUrl:url];
    }
    if (cacheModel) {
        self.hitCount ++;
        NSLog(@"===命中次数为：===%ld", (long)_hitCount);
    }

    return cacheModel;
}

- (YXLCacheModel *)hasMemoryCacheDataForUrl:(NSString *)url {
    NSArray *tmpArray = [_memoryCaches copy];
    for (YXLCacheModel *cache in tmpArray) {
        if ([cache.key isEqualToString:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]) {
            [_memoryCaches removeObject:cache];
            [_memoryCaches insertObject:cache atIndex:0];
            return cache;
        }
    }
    return nil;
}

- (void)setCacheData:(YXLCacheModel *)data forKey:(NSString *)key {
    [_memoryCaches insertObject:data atIndex:0];
    
    if (_memoryCaches.count > _memoryCapacity) {
        YXLCacheModel *deletedCacheModel = [_memoryCaches lastObject];
        [_memoryCaches removeObject:deletedCacheModel];
        [[YXLDiskCache DiskCache] addCacheData:deletedCacheModel forKey:key];
    }
    NSLog(@"memerycache的长度%ld", _memoryCaches.count);
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
