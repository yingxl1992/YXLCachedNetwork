//
//  YXLCacheModel.h
//  YXLCachedNetwork
//
//  Created by yingxl1992 on 16/3/2.
//  Copyright © 2016年 yingxl1992. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXLCacheModel : NSObject<NSCoding>

@property (nonatomic, copy) NSString *key;

//用于json等文本数据存储
@property (nonatomic, copy) NSDictionary *data;

@property (nonatomic, strong) NSString *expiresDate;

@property (nonatomic, strong) NSString *lastModifiedDate;



- (instancetype)initWithDic:(NSDictionary *)dic;

+ (NSDictionary *)serializeModel:(YXLCacheModel *)cacheModel;

@end
