//
//  YXLARCMemoryCache.h
//  YXLCachedNetwork
//
//  Created by yingxl1992 on 16/3/17.
//  Copyright © 2016年 yingxl1992. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YXLCacheModel;

@interface YXLARCMemoryCache : NSObject

+ (instancetype)ARCMemoryCache;

- (YXLCacheModel *)cachedMemoryDataWithUrl:(NSString *)url;

- (void)setCacheData:(YXLCacheModel *)data forKey:(NSString *)key;

- (void)setMemoryCapacity:(NSInteger)memoryCapacity;

@end
