//
//  YXLHttpClient.m
//  YXLCachedNetwork
//
//  Created by yingxl1992 on 16/1/26.
//  Copyright © 2016年 yingxl1992. All rights reserved.
//

#import "YXLHttpClient.h"
#import "YXLRequestModel.h"


@interface YXLHttpClient()

@property (nonatomic, strong) YXLRequestModel *requestModel;
@property (nonatomic, strong) YXLHttpEngine *httpEngine;

@end

@implementation YXLHttpClient

- (instancetype) init {
    self = [super self];
    if (self) {
        self.httpEngine = [[YXLHttpEngine alloc] init];
    }
    return self;
}

- (void)fetchDataWithRequestModel:(YXLRequestModel *)requestModel
                          success:(ResponseSuceessBlock)sucessBlock
                          failure:(ResponseFailureBlock)failureBlock {
    
    [self.httpEngine fetchDataWithRequestModel:requestModel
                                       success:sucessBlock
                                       failure:failureBlock];
    
}

@end
