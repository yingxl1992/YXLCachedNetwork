//
//  YXLMemeryCache.h
//  YXLCachedNetwork
//
//  Created by yingxl1992 on 16/3/2.
//  Copyright © 2016年 yingxl1992. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXLMemoryCache : NSObject

+ (instancetype)memoryCache;

- (NSDictionary *)cachedMemoryDataWithUrl:(NSString *)url;

- (void)setCacheData:(NSData *)data forKey:(NSString *)key;

@end
