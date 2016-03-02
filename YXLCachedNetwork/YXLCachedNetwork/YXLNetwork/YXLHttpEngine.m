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
#import "YXLCache.h"

@interface YXLHttpEngine()

@property (nonatomic, strong) NSURLSessionConfiguration *sessionConfiguration;
@property (nonatomic, strong) NSURLSession *urlSession;

@property (nonatomic, strong) YXLError *engineError;
@property (nonatomic, strong) YXLRequestModel *requestModel;
@property (nonatomic, assign) BOOL isSucceeded;
@property (nonatomic, strong) id responseData;

@property (nonatomic, strong) YXLCache *yxlCache;

@end

@implementation YXLHttpEngine

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.urlSession = [NSURLSession sessionWithConfiguration:self.sessionConfiguration];
        
        self.yxlCache = [[YXLCache alloc] init];
    }
    return self;
}

- (void)fetchDataWithRequestModel:(YXLRequestModel *)requestModel
                          success:(ResponseSuceessBlock)sucessBlock
                          failure:(ResponseFailureBlock)failureBlock {
    self.requestModel = requestModel;
    self.isSucceeded = NO;
    NSString *url = [self assemblyUrl];
    
    NSData *cachedData = [self.yxlCache cachedDataWithUrl:url];
    
    if (cachedData) {
        if (sucessBlock) {
            sucessBlock(cachedData);
        }
        return;
    }
    
    NSURLSessionDataTask *dataTask = [self.urlSession dataTaskWithURL:[NSURL URLWithString:url]
                                                    completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                        if (error)//网络访问错误
                                                        {
                                                            self.isSucceeded = NO;
                                                            if (!self.engineError) {
                                                                self.engineError = [[YXLError alloc] init];
                                                            }
                                                            self.engineError.detailError = error;
                                                            self.engineError.errorType = YXLNetworkType;
                                                        }
                                                        else
                                                        {
                                                            if (!data) //网络返回空数据
                                                            {
                                                                self.isSucceeded = NO;
                                                                if (!self.engineError) {
                                                                    self.engineError = [[YXLError alloc] init];
                                                                }
                                                                self.engineError.detailError = [NSError errorWithDomain:YXLResponseDataErrorDomain code:YXLDataEmptyError userInfo:@{NSLocalizedDescriptionKey : @"返回数据为空"}];
                                                                self.engineError.errorType = YXLDataEmpty;
                                                            }
                                                            else
                                                            {
                                                                [self handleData:data];
                                                            }
                                                        }
                                                        if (self.isSucceeded)
                                                        {
                                                            //转换Data->dic
                                                            [self.yxlCache saveResponseData:self.responseData forUrl:url];
                                                            if (sucessBlock) {
                                                                sucessBlock(data);
                                                            }
                                                        }
                                                        else
                                                        {
                                                            
                                                            if (failureBlock) {
                                                                failureBlock(self.engineError);
                                                            }
                                                        }
                                                    }];
    [dataTask resume];
    
}


- (NSString *)assemblyUrl {
    NSMutableString *urlString = [NSMutableString stringWithCapacity:50];
    [urlString appendString:self.requestModel.host];
    [urlString appendFormat:@":%@", self.requestModel.port];
    [urlString appendFormat:@"/%@", self.requestModel.functionId];
    return [urlString copy];
}

- (void)handleData:(NSData *)data {
    self.responseData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    if (self.responseData) //成功解析数据
    {
        self.isSucceeded = YES;
        //统一按照NSDictionary处理，不是字典型的也构造成字典
        if (![self.responseData isKindOfClass:[NSDictionary class]]) {
            
        }
    }
    else
    {
        self.isSucceeded = NO;
        if (!self.engineError) {
            self.engineError = [[YXLError alloc] init];
        }
        self.engineError.detailError = [NSError errorWithDomain:YXLResponseDataErrorDomain code:YXLParseJsonEmptyError userInfo:@{NSLocalizedDescriptionKey : @"无法解析"}];
        self.engineError.errorType = YXLDataParseType;
    }
}

@end
