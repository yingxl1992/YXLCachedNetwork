//
//  YXLHttpClient.m
//  YXLCachedNetwork
//
//  Created by yingxl1992 on 16/1/26.
//  Copyright © 2016年 yingxl1992. All rights reserved.
//

#import "YXLHttpClient.h"
#import "YXLRequestModel.h"
#import "YXLError.h"
#import "YXLAlertController.h"

@interface YXLHttpClient()

@property (nonatomic, strong) YXLRequestModel *requestModel;
@property (nonatomic, strong) YXLHttpEngine *httpEngine;

@property (nonatomic, strong) YXLAlertController *alertController;

@property (nonatomic, assign) ResponseFailureBlock failureBlock;
@property (nonatomic, strong) YXLError *error;

@end

@implementation YXLHttpClient

- (void)fetchDataWithRequestModel:(YXLRequestModel *)requestModel
                          success:(ResponseSuceessBlock)sucessBlock
                          failure:(ResponseFailureBlock)failureBlock {
    
    self.requestModel = requestModel;
    self.failureBlock = failureBlock;
    
    if (!self.httpEngine) {
        self.httpEngine = [[YXLHttpEngine alloc] init];
    }
    
    [self.httpEngine fetchDataWithRequestModel:requestModel
                                       success:sucessBlock
                                       failure:^(YXLError *error){
                                           self.error = error;
//                                           [self handleFailureBlock];
                                       }];
}

- (void)handleFailureBlock {
    dispatch_async(dispatch_get_main_queue(), ^{
            if (self.requestModel.showToast) {
                if (!self.alertController) {
                    self.alertController = [[YXLAlertController alloc] init];
                }
                [self.alertController showFailureToastWithError:self.error];
            }
    });
    if (self.failureBlock) {
        self.failureBlock(self.error);
    }
}

@end
