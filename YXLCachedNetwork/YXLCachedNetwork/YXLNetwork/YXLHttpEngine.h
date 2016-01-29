//
//  YXLHttpEngine.h
//  YXLCachedNetwork
//
//  Created by yingxl1992 on 16/1/28.
//  Copyright © 2016年 yingxl1992. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YXLRequestModel, YXLError;

typedef void(^ResponseSuceessBlock)(id data);
typedef void(^ResponseFailureBlock)(YXLError *error);

typedef NS_ENUM(NSInteger, YXLNetworkCode) {
    YXLNetworkSuccessCode = 0,
    YXLNetworkNotLoginCode,
    YXLNetworkTimeoutCode
};

@interface YXLHttpEngine : NSObject

- (void)fetchDataWithRequestModel:(YXLRequestModel *)requestModel
                          success:(ResponseSuceessBlock)sucessBlock
                          failure:(ResponseFailureBlock)failureBlock;

@end
