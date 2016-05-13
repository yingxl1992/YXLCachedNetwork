//
//  ViewController.m
//  YXLCachedNetwork
//
//  Created by yingxl1992 on 16/1/26.
//  Copyright © 2016年 yingxl1992. All rights reserved.
//

#import "ViewController.h"
#import "YXLHttpClient.h"
#import "YXLRequestModel.h"
#import "YXLError.h"
#import "YXLUserModel.h"
#import "YXLCache/YXLCacheModel.h"
#import <CommonCrypto/CommonDigest.h>

@interface ViewController ()

@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, strong) YXLHttpClient *httpClient;
@property (nonatomic, assign) YXLCacheType cacheType;

@property (nonatomic, strong) NSMutableArray *testValues;
@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) UIImageView *testImageView;

@end

@implementation ViewController

- (void)testFileManager {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheUrl = [array objectAtIndex:0];
    cacheUrl = [cacheUrl stringByAppendingPathComponent:@"YXLTestDir"];
    NSError *error = nil;
    BOOL res = [fileManager createDirectoryAtPath:cacheUrl withIntermediateDirectories:YES attributes:nil error:&error];
    if (error) {
        NSLog(@"create dir error==%@", error);
    }
    if (res) {
        NSLog(@"Create YXLTestDir successed");
    }
    else {
        NSLog(@"Create cacheYXLTestDir failed");
    }
    cacheUrl = [cacheUrl stringByAppendingPathExtension:@"test.txt"];
    if (![fileManager fileExistsAtPath:cacheUrl]) {
        BOOL res = [fileManager createFileAtPath:cacheUrl contents:nil attributes:nil];
        if (!res) {
            NSLog(@"Create cacheurl successed");
        }
        else {
            NSLog(@"Create cacheurl failed");
        }
    }
    error = nil;
    [@"test" writeToFile:cacheUrl atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"error==%@", error);
    }
}

- (IBAction)startTest:(id)sender {
//    _testValues = [NSMutableArray arrayWithArray: @[@12, @12, @13, @19, @13]];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"testURL" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    self.dataArray = [data allValues];
    self.cacheType = YXLCacheType_ARC;
    self.testValues = [NSMutableArray array];
    for (int i = 0; i < 500; i++) {
        NSLog(@"第%d次===", i);
//        self.count = i;
        [self timerFired];
        [NSThread sleepForTimeInterval:5.0f];
    }
    self.cacheType = YXLCacheType_FIFO;
    for (int i = 0; i < 500; i++) {
        self.count = i;
        NSLog(@"第%d次===", i);
        [self timerFired];
        [NSThread sleepForTimeInterval:5.0f];
    }
}

- (IBAction)startTestImage:(id)sender {
    if (!self.httpClient) {
        self.httpClient = [[YXLHttpClient alloc] init];
    }
    NSString *imageUrl = @"http://m.360buyimg.com/mobilecms/s400x400_jfs/t2095/140/1463220859/279010/69131a15/56a1d73dNb054957c.jpg!q70.jpg";
    [_httpClient fetchImageDataWithUrl:imageUrl
                               success:^(id data){
                                   __weak typeof(self) weakSelf = self;
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       __strong typeof(weakSelf) strongSelf = weakSelf;
                                       if (!strongSelf) {
                                           return;
                                       }
                                       if (strongSelf.testImageView) {
                                           [strongSelf.testImageView removeFromSuperview];
                                           strongSelf.testImageView = nil;
                                       }
                                       strongSelf.testImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 400, 400)];
                                       strongSelf.testImageView.image = data;
                                       [strongSelf.view addSubview:strongSelf.testImageView];
                                   });
                                   
                               }
                               failure:^(YXLError *error) {
                                   NSLog(@"下载图片失败");
                               }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)timerFired {
    NSString *url;
    if (_cacheType == YXLCacheType_ARC) {
        int valueIndex = arc4random() % _dataArray.count;
//            int valueIndex = 10;
        NSLog(@"===index===%d", valueIndex);
        url = _dataArray[valueIndex];
//        NSLog(@"url===%@", url);
        [self.testValues addObject:[NSNumber numberWithInt:valueIndex]];
    }
    else {
        int valueIndex = ((NSNumber *)_testValues[_count]).intValue;
        NSLog(@"===index===%d", valueIndex);
        url = _dataArray[valueIndex];
    }
    
    [self loadDataWithURL:url];
}

- (void)loadDataWithURL:(NSString *)url{
    
    YXLRequestModel *model = [[YXLRequestModel alloc] init];
    model.url = url;
    model.cacheType = _cacheType;
    if (!self.httpClient) {
        self.httpClient = [[YXLHttpClient alloc] init];
    }
    [_httpClient fetchDataWithRequestModel:model
                                   success:^(id data) {

                                   }
                                   failure:^(YXLError *error) {
                                       
                                   }];
}


@end
