//
//  YXLCache.h
//  YXLCachedNetwork
//
//  Created by yingxl1992 on 16/3/2.
//  Copyright © 2016年 yingxl1992. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXLRequestModel.h"

#define YXLCache_DEFAULT_LIFE_EXPIRATION 864000

//#define FIFO_CACHE_POLICY

@class YXLCacheModel;

@interface YXLCache : NSObject

@property (nonatomic, assign) YXLCacheType cacheType;

- (YXLCacheModel *)cachedDataWithUrl:(NSString *)url;

- (void)saveResponseData:(YXLCacheModel *)data forUrl:(NSString *)url;

@end
