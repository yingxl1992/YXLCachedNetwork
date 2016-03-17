//
//  YXLCacheModel.m
//  YXLCachedNetwork
//
//  Created by yingxl1992 on 16/3/2.
//  Copyright © 2016年 yingxl1992. All rights reserved.
//

#import "YXLCacheModel.h"
#import <objc/runtime.h>

@implementation YXLCacheModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.key = [aDecoder decodeObjectForKey:@"key"];
        self.data = [aDecoder decodeObjectForKey:@"data"];
        self.expiresDate = [aDecoder decodeObjectForKey:@"expiresDate"];
        self.lastModifiedDate = [aDecoder decodeObjectForKey:@"lastModifiedDate"];
        self.visitCount = [aDecoder decodeIntegerForKey:@"visitCount"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.key forKey:@"key"];
    [aCoder encodeObject:self.data forKey:@"data"];
    [aCoder encodeObject:self.expiresDate forKey:@"expiresDate"];
    [aCoder encodeObject:self.lastModifiedDate forKey:@"lastModifiedDate"];
    [aCoder encodeInteger:self.visitCount forKey:@"visitCount"];
}

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        [self setDataWithDic:dic];
    }
    return self;
}

+ (NSDictionary *)serializeModel:(YXLCacheModel *)cacheModel {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([cacheModel class], &propsCount);
    for (int i = 0; i < propsCount; i++) {
        objc_property_t prop = props[i];
        
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        id value = [cacheModel valueForKey:propName];
        if (!value) {
            value = [NSNull null];
        }
        [dic setValue:value forKey:propName];
    }
    return dic;
}

- (void)setDataWithDic:(NSDictionary *)dic {
    [self setValuesForKeysWithDictionary:dic];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"undefinedValue-Key:%@-%@", value, key);
}

@end
