//
//  YXLHttpEngine.m
//  YXLCachedNetwork
//
//  Created by yingxl1992 on 16/1/28.
//  Copyright © 2016年 yingxl1992. All rights reserved.
//

#import "YXLError.h"
#import "YXLHttpClient.h"
#import "YXLHttpEngine.h"
#import "YXLRequestModel.h"

@interface YXLHttpEngine()

@property (nonatomic, strong) NSURLSessionConfiguration *sessionConfiguration;
@property (nonatomic, strong) NSURLSession *urlSession;

@property (nonatomic, strong) YXLError *engineError;


@end

@implementation YXLHttpEngine

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.urlSession = [NSURLSession sessionWithConfiguration:self.sessionConfiguration];
    }
    return self;
}

- (void)fetchDataWithRequestModel:(YXLRequestModel *)requestModel
                          success:(ResponseSuceessBlock)sucessBlock
                          failure:(ResponseFailureBlock)failureBlock {
    NSURL *url = [self assemblyUrlWithRequestModel:requestModel];
    NSURLSessionDataTask *dataTask = [self.urlSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error)
        {
            if (!self.engineError) {
                self.engineError = [[YXLError alloc] init];
            }
            self.engineError.detailError = error;
            self.engineError.errorType = YXLNetworkType;
            if (failureBlock) {
                failureBlock(self.engineError);
            }
            NSLog(@"Error Happened When data Parsed, The Detail Error was %@", error);
        }
        else
        {
            id responseDic = [self handleData:data];
            if (responseDic)
            {
                if (sucessBlock) {
                    sucessBlock(responseDic);
                }
            }
            else
            {
                if (failureBlock) {
                    failureBlock(self.engineError);
                }
                NSLog(@"Error Happened When data Parsed, The Detail Error was %@", error);
            }
        }
    }];
    [dataTask resume];

}

- (NSURL *)assemblyUrlWithRequestModel:(YXLRequestModel *)requestModel {
    NSMutableString *urlString = [NSMutableString stringWithCapacity:50];
    [urlString appendString:requestModel.host];
    [urlString appendFormat:@":%@", requestModel.port];
    [urlString appendFormat:@"/%@", requestModel.functionId];
    return [NSURL URLWithString:urlString];
}

- (id)handleData:(NSData *)data {
    NSError *error;
    id parsedData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (!self.engineError) {
        self.engineError = [[YXLError alloc] init];
    }
    self.engineError.detailError = error;
    self.engineError.errorType = YXLDataParseType;
    
    if (parsedData) {
        //统一按照NSDictionary处理，不是字典型的也构造成字典
        if (![parsedData isKindOfClass:[NSDictionary class]]) {
            
        }
    }
    
    
    return parsedData;
}

@end
