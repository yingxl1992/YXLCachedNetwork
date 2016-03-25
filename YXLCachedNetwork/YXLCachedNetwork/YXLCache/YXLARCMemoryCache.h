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

@property (nonatomic, assign) NSInteger memoryCapacity;//记录数据个数，超过个数限制后删除或转移对象

+ (instancetype)ARCMemoryCache;

- (YXLCacheModel *)cachedMemoryDataWithUrl:(NSString *)url;

- (void)setCacheData:(YXLCacheModel *)data forKey:(NSString *)key;

- (void)setMemoryCapacity:(NSInteger)memoryCapacity;

@end
