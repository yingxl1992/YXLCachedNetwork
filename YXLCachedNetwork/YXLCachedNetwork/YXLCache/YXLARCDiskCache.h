//
//  YXLARCDiskMemoryCache.h
//  YXLCachedNetwork
//
//  Created by Alice on 16/3/17.
//  Copyright © 2016年 yingxl1992. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@class YXLCacheModel;

@interface YXLARCDiskCache : NSObject

+ (instancetype)ARCDiskCache;

//- (BOOL)hasEliminateDataForKey:(NSString *)key;

- (YXLCacheModel *)cachedDataWithUrl:(NSString *)url;

- (void)addCacheData:(YXLCacheModel *)data forKey:(NSString *)key;

@end
