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
#import "YXLCacheModel.h"

@interface YXLHttpEngine()<NSURLSessionDataDelegate, NSURLSessionTaskDelegate>

@property (nonatomic, strong) NSURLSessionConfiguration *sessionConfiguration;
@property (nonatomic, strong) NSURLSession *urlSession;

@property (nonatomic, strong) YXLError *engineError;
@property (nonatomic, strong) YXLRequestModel *requestModel;
@property (nonatomic, assign) BOOL isSucceeded;
//@property (nonatomic, strong) id responseData;

@property (nonatomic, strong) YXLCache *yxlCache;

@property (nonatomic, strong) YXLCacheModel *cacheModel;

//@property (nonatomic, copy) ResponseSuceessBlock successBlock;
//
//@property (nonatomic, copy) ResponseFailureBlock failureBlock;

@end

@implementation YXLHttpEngine

#pragma mark -

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.urlSession = [NSURLSession sessionWithConfiguration:self.sessionConfiguration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
        self.yxlCache = [[YXLCache alloc] init];
    }
    return self;
}

#pragma mark - Public Methods
//获取图片数据用url，在两者之前再加判断

//获取json数据
- (void)fetchDataWithRequestModel:(YXLRequestModel *)requestModel
                          success:(ResponseSuceessBlock)sucessBlock
                          failure:(ResponseFailureBlock)failureBlock {
    self.requestModel = requestModel;
    self.successBlock = sucessBlock;
    self.failureBlock = failureBlock;
    
    self.isSucceeded = NO;
    NSString *url = [self assemblyUrl];
    
    YXLCacheModel *cachedData = [self.yxlCache cachedDataWithUrl:url];
    
    if (cachedData) {
        if (self.successBlock) {
            self.successBlock(cachedData);
        }
        return;
    }
    
    self.cacheModel = [[YXLCacheModel alloc] init];
    
    NSURLSessionDataTask *dataTask = [self.urlSession dataTaskWithURL:[NSURL URLWithString:url]];
    [dataTask resume];
}

#pragma mark - Private Methods

- (NSString *)assemblyUrl {
    NSMutableString *urlString = [NSMutableString stringWithCapacity:50];
    [urlString appendString:self.requestModel.host];
    [urlString appendFormat:@":%@", self.requestModel.port];
    [urlString appendFormat:@"/%@", self.requestModel.functionId];
    return [urlString copy];
}

- (void)spliceData:(NSData *)data withTask:(NSURLSessionDataTask *)task {
    NSDictionary *responseData = [self handleData:data];
    
    self.cacheModel = [[YXLCacheModel alloc] init];
    self.cacheModel.key = task.originalRequest.URL.absoluteString;
    self.cacheModel.expiresDate = [task.originalRequest valueForHTTPHeaderField:@"Expired"];
    self.cacheModel.lastModifiedDate = [task.originalRequest valueForHTTPHeaderField:@"Last-Modified"];
    self.cacheModel.data = responseData;
}

- (NSDictionary *)handleData:(NSData *)data {
    NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    if (responseData) //成功解析数据
    {
        self.isSucceeded = YES;
        
        //统一按照NSDictionary处理，不是字典型的也构造成字典
        if (![responseData isKindOfClass:[NSDictionary class]]) {
            
        }
        
        return responseData;
    }
    self.isSucceeded = NO;
    if (!self.engineError) {
        self.engineError = [[YXLError alloc] init];
    }
    self.engineError.detailError = [NSError errorWithDomain:YXLResponseDataErrorDomain code:YXLParseJsonEmptyError userInfo:@{NSLocalizedDescriptionKey : @"无法解析"}];
    self.engineError.errorType = YXLDataParseType;
    return nil;
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    if (!data) {
        //网络返回空数据
        self.isSucceeded = NO;
        if (!self.engineError) {
            self.engineError = [[YXLError alloc] init];
        }
        self.engineError.detailError = [NSError errorWithDomain:YXLResponseDataErrorDomain code:YXLDataEmptyError userInfo:@{NSLocalizedDescriptionKey : @"返回数据为空"}];
        self.engineError.errorType = YXLDataEmpty;
    }
    else {
        [self spliceData:data withTask:dataTask];
    }
    
    if (self.isSucceeded)
    {
        [self.yxlCache saveResponseData:self.cacheModel forUrl:dataTask.originalRequest.URL.absoluteString];
        if (self.successBlock) {
            self.successBlock(self.cacheModel.data);
        }
    }
    else
    {
        
        if (self.failureBlock) {
            self.failureBlock(self.engineError);
        }
    }
    
}

#pragma mark - NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error)//网络访问错误
    {
        self.isSucceeded = NO;
        if (!self.engineError) {
            self.engineError = [[YXLError alloc] init];
        }
        self.engineError.detailError = error;
        self.engineError.errorType = YXLNetworkType;
    }
    if (self.failureBlock) {
        self.failureBlock(self.engineError);
    }

}
@end
