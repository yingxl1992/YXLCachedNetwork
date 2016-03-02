//
//  YXLCache.h
//  YXLCachedNetwork
//
//  Created by yingxl1992 on 16/3/2.
//  Copyright © 2016年 yingxl1992. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXLCache : NSObject

- (NSData *)cachedDataWithUrl:(NSString *)url;

- (void)saveResponseData:(NSData *)data forUrl:(NSString *)url;

@end
