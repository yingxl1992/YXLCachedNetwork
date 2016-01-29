//
//  YXLError.h
//  YXLCachedNetwork
//
//  Created by yingxl1992 on 16/1/28.
//  Copyright © 2016年 yingxl1992. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, YXLErrorType) {
    YXLNetworkType,
    YXLDataParseType
};

@interface YXLError : NSObject

@property (nonatomic, strong) NSError *detailError;

@property (nonatomic, assign) YXLErrorType errorType;

@end
