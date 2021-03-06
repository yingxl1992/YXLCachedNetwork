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
@property (nonatomic, copy) NSArray *B1;
@property (nonatomic, copy) NSArray *B2;

@end

@implementation YXLARCDiskCache

static YXLARCDiskCache *sharedDiskCache;

#pragma mark - init
+ (instancetype)ARCDiskCache {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDiskCache = [[YXLARCDiskCache alloc] init];
        sharedDiskCache.memoryCapacity = 15;//代表请求个数，因为无法计算数据量，初始L1和L2大小
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
        NSMutableArray *tmpQueue = [NSMutableArray arrayWithArray:self.B1];
        [tmpQueue insertObject:data atIndex:0];
        [self writeData:data ToQueue:0];
        [self checkQueueLimitation:tmpQueue];
        self.B1 = [tmpQueue copy];
    }
    else {
        NSMutableArray *tmpQueue = [NSMutableArray arrayWithArray:self.B2];
        [tmpQueue insertObject:data atIndex:0];
        [self writeData:data ToQueue:0];
        [self checkQueueLimitation:tmpQueue];
        self.B2 = [tmpQueue copy];
    }
}

#pragma mark - private methods

- (NSMutableArray *)loadHistoryDataWithFlag:(NSInteger)queueFlag {
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheUrl = [array objectAtIndex:0];
    cacheUrl = [cacheUrl stringByAppendingPathExtension:@"YXLDataCache"];
    NSString *expandPath;
    if (queueFlag == 0) {
        expandPath = @"YXLARCDiskB1Cache";
    }
    else {
        expandPath = @"YXLARCDiskB2Cache";
    }
    cacheUrl = [cacheUrl stringByAppendingPathExtension:expandPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:cacheUrl]) {
        [fileManager createDirectoryAtPath:cacheUrl withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *fileUrl = [cacheUrl stringByAppendingString:@"diskQueue.plist"];
    if(![fileManager fileExistsAtPath:fileUrl]){
        if (![fileManager createFileAtPath:fileUrl contents:nil attributes:nil]) {
            NSLog(@"fail");
        }
    }

    NSMutableArray *queue = [NSKeyedUnarchiver unarchiveObjectWithFile:fileUrl];
    if (!queue) {
        queue = [NSMutableArray array];
    }
    return queue;
}

- (BOOL)hasCacheDataForKey:(NSString *)key inQueue:(NSArray *)queue {
    for(YXLCacheModel *cacheModel in queue) {
        if([cacheModel.key isEqualToString:[key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]) {
            return YES;
        }
    }
    return NO;
}

- (YXLCacheModel *)getDataWithURL:(NSString *)url inQueueType: (NSInteger)queueType{
    NSString *fileUrl = [self getFileURLWithQueueType:queueType forKey:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    YXLCacheModel *cacheModel = [NSKeyedUnarchiver unarchiveObjectWithFile:fileUrl];
    return cacheModel;
}

- (void)removeCacheDataWithURL:(NSString *)url inQueueType:(NSInteger)queueType {
    NSString *fileUrl = [self getFileURLWithQueueType:queueType forKey:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
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
    cacheUrl = [cacheUrl stringByAppendingPathExtension:@"YXLDataCache"];
    NSString *expandPath;
    if (queueType == 0) {
        expandPath = @"YXLARCDiskB1Cache";
    }
    else {
        expandPath = @"YXLARCDiskB2Cache";
    }
    cacheUrl = [cacheUrl stringByAppendingPathExtension:expandPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:cacheUrl]) {
        [fileManager createDirectoryAtPath:cacheUrl withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *fileUrl = [cacheUrl stringByAppendingString:[NSString stringWithFormat:@"/%@.plist", [self md5Encryption:key]]];
    if(![fileManager fileExistsAtPath:fileUrl]){
        if (![fileManager createFileAtPath:fileUrl contents:nil attributes:nil]) {
            NSLog(@"fail");
        }
    }
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
