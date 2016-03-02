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

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        [self setDataWithDic:dic];
    }
    return self;
}

- (NSDictionary *)serializeModel:(YXLCacheModel *)cacheModel {
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
//    self.key = [dic objectForKey:@"key"];
//    self.data = [dic objectForKey:@"data"];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"undefinedValue-Key:%@-%@", value, key);
}

@end
