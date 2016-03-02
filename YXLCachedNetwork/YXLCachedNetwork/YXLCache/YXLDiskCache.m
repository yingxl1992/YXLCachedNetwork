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

//@property (nonatomic, strong) NSMutableDictionary *diskCaches;

@end

@implementation YXLDiskCache

- (NSDictionary *)cachedDataWithUrl:(NSString *)url {
//    YXLCacheModel *cacheModel = [_diskCaches objectForKey:url];
    NSDictionary *cacheData = [self getDataWithURL:url];
    return cacheData;
}

- (void)addCacheData:(NSData *)data forKey:(NSString *)key {
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheUrl = [array objectAtIndex:0];
    NSString *fileUrl = [cacheUrl stringByAppendingString:[NSString stringWithFormat:@"/YXLDataCache/%@.plist", [self md5Encryption:key]]];
    
    if ([self isExistAtPath:fileUrl]) {
        //增加有效期等判断
    }
    else {
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *directoryPath= [cacheUrl stringByAppendingString:@"/YXLDataCache"];
        BOOL isFolderExist = [fileManager fileExistsAtPath:directoryPath];
        if(!isFolderExist) {
            [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        [fileManager createFileAtPath:fileUrl contents:data attributes:nil];
        //增加存储限制判断
    }
}

- (NSDictionary *)getDataWithURL:(NSString *)url {
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheUrl = [array objectAtIndex:0];
    NSString *fileUrl = [cacheUrl stringByAppendingString:[NSString stringWithFormat:@"/YXLDataCache/%@.plist", [self md5Encryption:url]]];
    
    if (![self isExistAtPath:fileUrl]) {
        return nil;
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:fileUrl];
    
    return dic;
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
