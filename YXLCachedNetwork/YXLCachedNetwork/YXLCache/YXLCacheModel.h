//
//  YXLCacheModel.h
//  YXLCachedNetwork
//
//  Created by yingxl1992 on 16/3/2.
//  Copyright © 2016年 yingxl1992. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXLCacheModel : NSObject

@property (nonatomic, copy) NSString *key;

//用于内存缓存的数据存储
@property (nonatomic, strong) NSDictionary *data;

//用于磁盘缓存的数据存储
//@property (nonatomic, strong) NSString *fileUrl;

- (instancetype)initWithDic:(NSDictionary *)dic;

- (NSDictionary *)serializeModel:(YXLCacheModel *)cacheModel;

@end
