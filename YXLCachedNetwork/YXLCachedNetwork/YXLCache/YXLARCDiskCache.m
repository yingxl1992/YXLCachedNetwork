//
//  YXLARCDiskMemoryCache.m
//  YXLCachedNetwork
//
//  Created by Alice on 16/3/17.
//  Copyright © 2016年 yingxl1992. All rights reserved.
//

#import "YXLARCDiskCache.h"
#import "YXLCacheModel.h"

NSString *const YXLARCDiskCacheB1Path = @"/YXLDataCache/B1.plist";
NSString *const YXLARCDiskCacheB2Path = @"/YXLDataCache/B2.plist";

@interface YXLARCDiskCache ()

@property (nonatomic, assign) NSInteger memoryCapacity;
@property (nonatomic, strong) NSMutableArray *B1;
@property (nonatomic, strong) NSMutableArray *B2;

@end

@implementation YXLARCDiskCache

static YXLARCDiskCache *sharedDiskCache;

#pragma mark - init
+ (instancetype)ARCDiskCache {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDiskCache = [[YXLARCDiskCache alloc] init];
        sharedDiskCache.memoryCapacity = 15     ;//代表请求个数，因为无法计算数据量，初始L1和L2大小
        sharedDiskCache.B1 = [sharedDiskCache loadHistoryDataWithFlag:0];
        sharedDiskCache.B2 = [sharedDiskCache loadHistoryDataWithFlag:1];
    });
    
    return sharedDiskCache;
}

#pragma mark - public methods

- (YXLCacheModel *)cachedDataWithUrl:(NSString *)url {
    YXLCacheModel *cacheData = nil;
    
    BOOL hasCacheInB1 = [self hasCacheDataForKey:url inQueue:self.B1];
    if (hasCacheInB1) {
        cacheData = [self getDataWithURL:url inQueueType:0];
        [self removeCacheDataWithURL:url inQueueType:0];
    }
    BOOL hasCacheInB2 = [self hasCacheDataForKey:url inQueue:self.B2];
    if (hasCacheInB2) {
        cacheData = [self getDataWithURL:url inQueueType:1];
        [self removeCacheDataWithURL:url inQueueType:1];
    }
    
    return cacheData;
}

- (void)addCacheData:(YXLCacheModel *)data forKey:(NSString *)key {
    
    if (data.visitCount == 1) {
        [self.B1 insertObject:key atIndex:0];
        [self writeData:data ToQueue:0];
        [self checkQueueLimitation:self.B1];
    }
    else {
        [self.B2 insertObject:key atIndex:0];
        [self writeData:data ToQueue:1];
        [self checkQueueLimitation:self.B2];
    }
}

#pragma mark - private methods

- (NSMutableArray *)loadHistoryDataWithFlag:(NSInteger)queueFlag {
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheUrl = [array objectAtIndex:0];
    NSString *expandPath;
    if(0 == queueFlag) {
        expandPath = YXLARCDiskCacheB1Path;
    }
    else if(1 == queueFlag) {
        expandPath = YXLARCDiskCacheB2Path;
    }
    NSString *fileUrl = [cacheUrl stringByAppendingString:expandPath];
    NSMutableArray *queue = [NSKeyedUnarchiver unarchiveObjectWithFile:fileUrl];
    return queue;
}

- (BOOL)hasCacheDataForKey:(NSString *)key inQueue:(NSMutableArray *)queue {
    for(NSString *url in queue) {
        if([url isEqualToString:[key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]) {
            return YES;
        }
    }
    return NO;
}

- (YXLCacheModel *)getDataWithURL:(NSString *)url inQueueType: (NSInteger)queueType{
    NSString *fileUrl = [self getFileURLWithQueueType:queueType forKey:url];
    YXLCacheModel *cacheModel = [NSKeyedUnarchiver unarchiveObjectWithFile:fileUrl];
    return cacheModel;
}

- (void)removeCacheDataWithURL:(NSString *)url inQueueType:(NSInteger)queueType {
    NSString *fileUrl = [self getFileURLWithQueueType:queueType forKey:url];
    [[NSFileManager defaultManager] removeItemAtPath:fileUrl error:nil];
}

- (void)writeData:(YXLCacheModel *)data ToQueue: (NSInteger)queueType{
    NSString *fileUrl = [self getFileURLWithQueueType:queueType forKey:data.key];
    [NSKeyedArchiver archiveRootObject:data toFile:fileUrl];
}

- (void)checkQueueLimitation: (NSMutableArray *)queue {
    if (queue.count > _memoryCapacity) {
        [self eliminateLastObjectInQueue:queue];
    }
}

- (void)eliminateLastObjectInQueue:(NSMutableArray *)queue {
    YXLCacheModel *cacheModel = [queue lastObject];
    [queue removeObject:cacheModel];
    if (cacheModel.visitCount == 1) {
        [self removeCacheDataWithURL:cacheModel.key inQueueType:0];
    }
    else {
        [self removeCacheDataWithURL:cacheModel.key inQueueType:1];
    }
}

- (NSString *)getFileURLWithQueueType:(NSInteger)queueType forKey:(NSString *)key {
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheUrl = [array objectAtIndex:0];
    NSString *expandPath;
    if (queueType == 0) {
        expandPath = @"/YXLDataCache/YXLARCDiskB1Cache";
    }
    else {
        expandPath = @"/YXLDataCache/YXLARCDiskB2Cache";
    }
    NSString *fileUrl = [cacheUrl stringByAppendingString:[NSString stringWithFormat:@"%@%@.plist", expandPath, key]];
    return fileUrl;
}

#pragma mark - utility
- (NSString *)md5Encryption:(NSString *)string {
    const char *cstr = [string UTF8String];
    unsigned char result[16];
    CC_MD5(cstr, (CC_LONG)strlen(cstr), result);
    
    return [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1],
            result[2], result[3],
            result[4], result[5],
            result[6], result[7],
            result[8], result[9],
            result[10], result[11],
            result[12], result[13],
            result[14], result[15]];
}

@end
