//
//  YXLHttpClient.h
//  YXLCachedNetwork
//
//  Created by yingxl1992 on 16/1/26.
//  Copyright © 2016年 yingxl1992. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXLHttpEngine.h"

@class YXLRequestModel;
/**
 *  公开调用的网络请求类
 */
@interface YXLHttpClient : NSObject

- (void)fetchDataWithRequestModel:(YXLRequestModel *)requestModel
                          success:(ResponseSuceessBlock)sucessBlock
                          failure:(ResponseFailureBlock)failureBlock;

@end
