//
//  YXLDiskCache.m
//  YXLCachedNetwork
//
//  Created by yingxl1992 on 16/3/2.
//  Copyright © 2016年 yingxl1992. All rights reserved.
//

#import "YXLDiskCache.h"
#import "YXLCacheModel.h"


@interface YXLDiskCache ()

@property (nonatomic, assign) NSInteger memoryCapacity;

@property (nonatomic, strong) NSMutableArray *queue;

@end

@implementation YXLDiskCache

static YXLDiskCache *sharedDiskCache;

+ (instancetype)DiskCache {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDiskCache = [[YXLDiskCache alloc] init];
        sharedDiskCache.memoryCapacity = 30;
        sharedDiskCache.queue = [sharedDiskCache loadHistoryData];
    });
    
    return sharedDiskCache;
}

- (YXLCacheModel *)cachedDataWithUrl:(NSString *)url {
    NSLog(@"diskcaches的长度%ld", _queue.count);
    for (YXLCacheModel *cacheModel in _queue) {
        if ([cacheModel.key isEqualToString:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]) {
            YXLCacheModel *cacheData = [self getDataWithURL:url];
            return cacheData;
        }
    }
    return nil;
}

- (void)addCacheData:(YXLCacheModel *)data forKey:(NSString *)key {
    NSString *fileUrl = [self getFileURLforKey:key];
    [_queue insertObject:data atIndex:0];
    [NSKeyedArchiver archiveRootObject:data toFile:fileUrl];
    if (self.memoryCapacity < self.queue.count) {
        [self eliminateLastObject];
    }
    NSLog(@"diskcaches的长度%ld", _queue.count);
}

- (YXLCacheModel *)getDataWithURL:(NSString *)url {
    NSString *fileUrl = [self getFileURLforKey:url];
    YXLCacheModel *cacheModel = [NSKeyedUnarchiver unarchiveObjectWithFile:fileUrl];
    if (cacheModel) {
        [[NSFileManager defaultManager] removeItemAtPath:fileUrl error:nil];
    }
    return cacheModel;
}

- (NSString *)getFileURLforKey:(NSString *)key {
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheUrl = [array objectAtIndex:0];
    cacheUrl = [cacheUrl stringByAppendingPathExtension:@"YXLFIFOCache"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:cacheUrl]) {
        [fileManager createDirectoryAtPath:cacheUrl withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *fileUrl = [cacheUrl stringByAppendingString:[NSString stringWithFormat:@"%@.plist", [self md5Encryption:key]]];
    return fileUrl;
}

- (BOOL)isExistAtPath:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:filePath];
    return isExist;
}

- (NSMutableArray *)loadHistoryData {
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheUrl = [array objectAtIndex:0];
    cacheUrl = [cacheUrl stringByAppendingPathExtension:@"YXLFIFOCache"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:cacheUrl]) {
        [fileManager createDirectoryAtPath:cacheUrl withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *fileUrl = [cacheUrl stringByAppendingString:@"diskQueue.plist"];
    NSMutableArray *queue = [NSKeyedUnarchiver unarchiveObjectWithFile:fileUrl];
    if (!queue) {
        queue = [NSMutableArray array];
    }
    return queue;
}

- (void)eliminateLastObject {
    YXLCacheModel *cacheModel = [self.queue lastObject];
    [self.queue removeObject:cacheModel];
    [self removeCacheDataWithURL:cacheModel.key];
}

- (void)removeCacheDataWithURL:(NSString *)url {
    NSString *fileUrl = [self getFileURLforKey:url];
    [[NSFileManager defaultManager] removeItemAtPath:fileUrl error:nil];
}

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
