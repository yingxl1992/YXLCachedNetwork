//
//  YXLRequestModel.h
//  YXLCachedNetwork
//
//  Created by yingxl1992 on 16/1/26.
//  Copyright © 2016年 yingxl1992. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  URL缓存策略
 */
typedef NS_ENUM(NSInteger, YXLRequestCachePolicy) {
    /**
     *  先返回缓存数据（如果存在），再请求网络数据
     */
    YXLRequestCacheBothLocalAndRemoteData,
    /**
     *  忽略缓存，重新请求数据
     */
    YXLRequestCacheIgnoringLocalData,
    /**
     *  使用缓存数据，若无缓存，请求网络数据
     */
    YXLRequestCacheLocalDataElseLoad,
    /**
     *  只使用缓存数据，不请求网络数据
     */
    YXLRequestCacheLocalDataDontLoad
};

typedef NS_ENUM(NSInteger, YXLCacheType) {
    YXLCacheType_FIFO,
    YXLCacheType_ARC
};

@interface YXLRequestModel : NSObject

/**
 *  指定请求类型，可选GET和POST两种方法，默认为GET
 */
@property (nonatomic, strong) NSString *requestMethod;

@property (nonatomic, strong) NSDictionary *params;

/**
 *  默认为本机
 */
@property (nonatomic, strong) NSString *host;

/**
 *  默认是8080
 */
@property (nonatomic, strong) NSString *port;

@property (nonatomic, strong) NSString *functionId;

/**
 *  默认是YXLRequestCacheBothLocalAndRemoteData
 */
@property (nonatomic, assign) YXLRequestCachePolicy requestCachePolicy;

/**
 *  采用的缓存类型，默认ARC
 */
@property (nonatomic, assign) YXLCacheType cacheType;

/**
 *  默认为YES
 */
@property (nonatomic, assign) BOOL showToast;

@property (nonatomic, strong) NSString *url;

@end
