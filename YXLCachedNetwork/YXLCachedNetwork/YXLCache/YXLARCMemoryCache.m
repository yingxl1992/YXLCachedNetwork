//
//  YXLARCMemoryCache.m
//  YXLCachedNetwork
//
//  Created by yingxl1992 on 16/3/17.
//  Copyright © 2016年 yingxl1992. All rights reserved.
//

#import "YXLARCMemoryCache.h"
#import "YXLCacheModel.h"
#import "YXLARCDiskCache.h"
#import "NSDate+RCF.h"

@interface YXLARCMemoryCache ()
//@property (nonatomic, strong) NSMutableArray *memoryCaches;//便于实现队列等
//@property (nonatomic, assign) NSInteger memoryCapacity;//记录数据个数，超过个数限制后删除或转移对象
@property (nonatomic, strong) YXLARCDiskCache *diskCache;
@property (nonatomic, strong) NSMutableArray *L1;
@property (nonatomic, strong) NSMutableArray *L2;
@property (nonatomic, assign) NSInteger hitCount;


@end

@implementation YXLARCMemoryCache

static YXLARCMemoryCache *sharedMemoryCache;

#pragma mark - init
+ (instancetype)ARCMemoryCache {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMemoryCache = [[YXLARCMemoryCache alloc] init];
        sharedMemoryCache.memoryCapacity = 15;//代表请求个数，因为无法计算数据量，初始L1和L2大小
        sharedMemoryCache.L1 = [NSMutableArray arrayWithCapacity:sharedMemoryCache.memoryCapacity];
        sharedMemoryCache.L2 = [NSMutableArray arrayWithCapacity:sharedMemoryCache.memoryCapacity];
        sharedMemoryCache.hitCount = 0;
    });
    
    return sharedMemoryCache;
}

#pragma mark - public methods

- (YXLCacheModel *)cachedMemoryDataWithUrl:(NSString *)key {
    
    YXLCacheModel *cacheModel = nil;
    cacheModel = [self hasCache:key InQueue:self.L1];
    if (!cacheModel) {
        cacheModel = [self hasCache:key InQueue:self.L2];
        if (!cacheModel) {
            cacheModel = [self.diskCache cachedDataWithUrl:key];
        }
    }
    if (cacheModel) {
        self.hitCount ++;
        NSLog(@"===命中次数为：===%ld", (long)_hitCount);
    }
    NSLog(@"===队列1的大小：%ld", self.L1.count);
    NSLog(@"===队列2的大小：%ld", self.L2.count);
    return cacheModel;
}

- (void)setCacheData:(YXLCacheModel *)data forKey:(NSString *)key {

    YXLCacheModel *cacheModel1 = [self hasCache:key InQueue:self.L1];
    if (cacheModel1) {
        cacheModel1.visitCount ++;
        [self moveCache:cacheModel1 FromQueue:self.L1 ToQueue:self.L2];
    }
    else {
        YXLCacheModel *cacheModel2 = [self hasCache:key InQueue:self.L2];
        if (cacheModel2) {
            [self.L2 removeObject:cacheModel2];
            [self.L2 insertObject:cacheModel2 atIndex:0];
        }
        else {
            YXLCacheModel *cacheModel = [self.diskCache cachedDataWithUrl:key];
            if (cacheModel) {
                self.memoryCapacity = self.memoryCapacity + 1;
                if (cacheModel.visitCount == 1) {
                    [self.L1 insertObject:cacheModel atIndex:0];
                    [self checkQueueLimit:self.L1];
                }
                else {
                    [self.L2 insertObject:cacheModel atIndex:0];
                    [self checkQueueLimit:self.L2];
                }
            }
            else {
                [self.L1 insertObject:data atIndex:0];
                [self checkQueueLimit:self.L1];
            }
        }
    }
}

- (void)setMemoryCapacity:(NSInteger)memoryCapacity {
    _memoryCapacity = memoryCapacity;
}

#pragma mark - private methods

- (YXLCacheModel *)hasCache:(NSString *)url InQueue:(NSMutableArray *)queue {
    for (YXLCacheModel *cache in queue) {
        if ([cache.key isEqualToString:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]) {
            return cache;
        }
    }
    return nil;
}

- (void)moveCache:(YXLCacheModel *)cache FromQueue:(NSMutableArray *)queue1 ToQueue:(NSMutableArray *)queue2 {
    [queue1 removeObject:cache];
    [queue2 insertObject:cache atIndex:0];
    [self checkQueueLimit:queue2];
}

- (void)checkQueueLimit:(NSMutableArray *)queue {
    if (queue.count > _memoryCapacity) {
        [self eliminateLastObjectInQueue:queue];
    }
}

- (void)eliminateLastObjectInQueue:(NSMutableArray *)queue {
    YXLCacheModel *cacheModel = [queue lastObject];
    [queue removeObject:cacheModel];
    [self.diskCache addCacheData:cacheModel forKey:cacheModel.key];
}

@end
