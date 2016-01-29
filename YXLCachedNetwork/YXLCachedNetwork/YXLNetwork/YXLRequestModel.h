//
//  YXLRequestModel.h
//  YXLCachedNetwork
//
//  Created by yingxl1992 on 16/1/26.
//  Copyright © 2016年 yingxl1992. All rights reserved.
//

#import <Foundation/Foundation.h>

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

@end
