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
@property (nonatomic, copy) NSArray *L1;
@property (nonatomic, copy) NSArray *L2;
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
        sharedMemoryCache.L1 = [NSArray array];
        sharedMemoryCache.L2 = [NSArray array];
        sharedMemoryCache.hitCount = 0;
    });
    
    return sharedMemoryCache;
}

#pragma mark - public methods

- (YXLCacheModel *)cachedMemoryDataWithUrl:(NSString *)key {
    YXLCacheModel *cacheModel = nil;
    cacheModel = [self hasCache:key InQueue:self.L1];//查找L1队列
    if (cacheModel) {
        [self moveCache:cacheModel FromQueue:self.L1 ToQueue:self.L2];
        NSLog(@"在L1中命中");
    }
    else {
        cacheModel = [self hasCache:key InQueue:self.L2];//查找L2队列
        if (!cacheModel) {
            cacheModel = [self.diskCache cachedDataWithUrl:key];//查询B1和B2，若有数据，则转移。。。
            
            if(cacheModel) {
                self.memoryCapacity = self.memoryCapacity + 1;
                if (cacheModel.visitCount == 1) {
                    NSMutableArray *tmpQueue = [NSMutableArray arrayWithArray:self.L1];
                    [tmpQueue insertObject:cacheModel atIndex:0];
                    [self checkQueueLimit:tmpQueue];
                    self.L1 = [tmpQueue copy];
                }
                else {
                    NSMutableArray *tmpQueue = [NSMutableArray arrayWithArray:self.L2];
                    [tmpQueue insertObject:cacheModel atIndex:0];
                    [self checkQueueLimit:tmpQueue];
                    self.L2 = [tmpQueue copy];
                }
            }
        }
        else {
            NSLog(@"在L2中命中");
        }
    }
    if (cacheModel) {
        cacheModel.visitCount ++;
        self.hitCount ++;
        NSLog(@"===命中次数为：===%ld", (long)_hitCount);
    }
    NSLog(@"===队列1的大小：%ld", self.L1.count);
    NSLog(@"===队列2的大小：%ld", self.L2.count);
    return cacheModel;
}

- (void)setCacheData:(YXLCacheModel *)data forKey:(NSString *)key {
    NSMutableArray *tmpQueue1 = [NSMutableArray arrayWithArray:self.L1];
    [tmpQueue1 insertObject:data atIndex:0];
    [self checkQueueLimit:tmpQueue1];
    self.L1 = [tmpQueue1 copy];
    NSLog(@"===队列1的大小：%ld", self.L1.count);
    NSLog(@"===队列2的大小：%ld", self.L2.count);
}

- (void)setMemoryCapacity:(NSInteger)memoryCapacity {
    _memoryCapacity = memoryCapacity;
}

#pragma mark - private methods

- (YXLCacheModel *)hasCache:(NSString *)url InQueue:(NSArray *)queue {
    for (YXLCacheModel *cache in queue) {
        if ([cache.key isEqualToString:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]) {
            return cache;
        }
    }
    return nil;
}

- (void)moveCache:(YXLCacheModel *)cache FromQueue:(NSArray *)queue1 ToQueue:(NSArray *)queue2 {
    NSMutableArray *tmpQueue1 =[NSMutableArray arrayWithArray:queue1];
    NSMutableArray *tmpQueue2 =[NSMutableArray arrayWithArray:queue2];
    [tmpQueue1 removeObject:cache];
    [tmpQueue2 insertObject:cache atIndex:0];
    [self checkQueueLimit:tmpQueue2];
    self.L1 = [tmpQueue1 copy];
    self.L2 = [tmpQueue2 copy];
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
