//
//  YXLRequestModel.m
//  YXLCachedNetwork
//
//  Created by yingxl1992 on 16/1/26.
//  Copyright © 2016年 yingxl1992. All rights reserved.
//

#import "YXLRequestModel.h"

@implementation YXLRequestModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = @"GET";
        self.host = @"http://127.0.0.1";
        self.port = @"8080";
        self.requestCachePolicy = YXLRequestCacheBothLocalAndRemoteData;
        self.showToast = YES;
        self.url = @"";
    }
    return self;
}

@end
