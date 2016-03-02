//
//  YXLDiskCache.h
//  YXLCachedNetwork
//
//  Created by yingxl1992 on 16/3/2.
//  Copyright © 2016年 yingxl1992. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface YXLDiskCache : NSObject

- (NSDictionary *)cachedDataWithUrl:(NSString *)url;

- (void)addCacheData:(NSData *)data forKey:(NSString *)key;

@end
