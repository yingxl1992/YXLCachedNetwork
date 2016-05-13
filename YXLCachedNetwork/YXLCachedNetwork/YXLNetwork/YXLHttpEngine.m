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
#import "YXLImageCache.h"

@interface YXLHttpEngine()<NSURLSessionDataDelegate, NSURLSessionTaskDelegate, NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSURLSessionConfiguration *sessionConfiguration;
@property (nonatomic, strong) NSURLSession *urlSession;

@property (nonatomic, strong) YXLError *engineError;
@property (nonatomic, strong) YXLRequestModel *requestModel;
@property (nonatomic, assign) BOOL isSucceeded;
//@property (nonatomic, strong) id responseData;

@property (nonatomic, strong) YXLCache *yxlCache;

@property (nonatomic, strong) YXLCacheModel *cacheModel;

@property (nonatomic, strong) NSDate *currentDate;

//@property (nonatomic, copy) ResponseSuceessBlock successBlock;
//
//@property (nonatomic, copy) ResponseFailureBlock failureBlock;

@property (nonatomic, strong) YXLImageCache *imageCache;

@property (nonatomic, assign) YXLCacheType cacheType;

@end

@implementation YXLHttpEngine

#pragma mark -

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.urlSession = [NSURLSession sessionWithConfiguration:self.sessionConfiguration delegate:self delegateQueue:nil];
        
        self.yxlCache = [[YXLCache alloc] init];
        self.imageCache = [YXLImageCache sharedImageCache];
    }
    return self;
}

#pragma mark - Public Methods
//获取图片数据用url，在两者之前再加判断
- (void)fetchImageDataWithUrl:(NSString *)imageUrl
                      success:(ResponseSuceessBlock)sucessBlock
                      failure:(ResponseFailureBlock)failureBlock {
    self.successBlock = sucessBlock;
    self.failureBlock = failureBlock;
    
    UIImage *cachedImage = [self.imageCache cachedImageDataWithUrl:imageUrl];
    if (cachedImage) {
        if(self.successBlock) {
            self.successBlock(cachedImage);
        }
        return;
        
    }
    imageUrl = [imageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURLSessionDownloadTask *downloadTask = [self.urlSession downloadTaskWithURL:[NSURL URLWithString:imageUrl]];
    [downloadTask resume];
}

//获取json数据
- (void)fetchDataWithRequestModel:(YXLRequestModel *)requestModel
                          success:(ResponseSuceessBlock)sucessBlock
                          failure:(ResponseFailureBlock)failureBlock {
    self.requestModel = requestModel;
    self.successBlock = sucessBlock;
    self.failureBlock = failureBlock;
    
    self.isSucceeded = NO;
    NSString *url = requestModel.url;
    NSString *escapedPath = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //取缓存数据
    self.cacheType = requestModel.cacheType;
    self.yxlCache.cacheType = requestModel.cacheType;
    YXLCacheModel *cachedData = [self.yxlCache cachedDataWithUrl:url];
    
    if (cachedData) {
        NSLog(@"命中===");
        if (self.successBlock) {
            self.successBlock(cachedData);
        }
//        double deltaTime = [[NSDate date] timeIntervalSinceDate:self.currentDate];
//        NSLog(@"time:%f", deltaTime);
        return;
    }
    
    self.cacheModel = [[YXLCacheModel alloc] init];
    
    NSURLSessionDataTask *dataTask = [self.urlSession dataTaskWithURL:[NSURL URLWithString:escapedPath]];
    
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
    self.cacheModel.visitCount = 1;
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
        self.isSucceeded = YES;
        [self spliceData:data withTask:dataTask];
    }
    
    if (self.isSucceeded)
    {
        self.yxlCache.cacheType = _cacheType;
        [self.yxlCache saveResponseData:self.cacheModel forUrl:dataTask.originalRequest.URL.absoluteString];
//        double deltaTime = [[NSDate date] timeIntervalSinceDate:self.currentDate];
//        NSLog(@"time:%f", deltaTime);
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
        if (self.failureBlock) {
            self.failureBlock(self.engineError);
        }
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {

    UIImage *downloadedImage = [UIImage imageWithData:
                                [NSData dataWithContentsOfURL:location]];
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtURL:location error:&error];
    if (error) {
        NSLog(@"Fail to delete downloadTask %@", location.absoluteString);
    }
    [self.imageCache setImageData:downloadedImage forUrl:downloadTask.originalRequest.URL.absoluteString];
    if (self.successBlock) {
        self.successBlock(downloadedImage);
    }
}
@end
