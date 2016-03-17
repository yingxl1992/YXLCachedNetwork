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

@end

@implementation YXLDiskCache

- (YXLCacheModel *)cachedDataWithUrl:(NSString *)url {
    YXLCacheModel *cacheData = [self getDataWithURL:url];
    return cacheData;
}

- (void)addCacheData:(YXLCacheModel *)data forKey:(NSString *)key {
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheUrl = [array objectAtIndex:0];
    NSString *fileUrl = [cacheUrl stringByAppendingString:[NSString stringWithFormat:@"/YXLDataCache/%@.plist", [self md5Encryption:key]]];
    
    if ([self isExistAtPath:fileUrl]) {
        //增加有效期等判断
    }
    else {
        
        BOOL res = [NSKeyedArchiver archiveRootObject:data toFile:fileUrl];
        if (!res) {
            //失败处理
        }

        //增加存储限制判断
    }
}

- (YXLCacheModel *)getDataWithURL:(NSString *)url {
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheUrl = [array objectAtIndex:0];
    NSString *fileUrl = [cacheUrl stringByAppendingString:[NSString stringWithFormat:@"/YXLDataCache/%@.plist", [self md5Encryption:url]]];
    
//    if (![self isExistAtPath:fileUrl]) {
//        return nil;
//    }
    
    YXLCacheModel *cacheModel = [NSKeyedUnarchiver unarchiveObjectWithFile:fileUrl];
    
    return cacheModel;
}

- (BOOL)isExistAtPath:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:filePath];
    return isExist;
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
