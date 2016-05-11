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

@interface ViewController ()

@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, strong) YXLHttpClient *httpClient;

@property (nonatomic, strong) UIImageView *testImageView;

@end

@implementation ViewController

- (IBAction)startTest:(id)sender {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"testURL" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    self.dataArray = [data allValues];
    for (int i = 0; i < 100; i++) {
        NSLog(@"第%d次===", i);
        [self timerFired];
        [NSThread sleepForTimeInterval:10.0f];
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
                                       
//                                       UIImage *tmpImage = [UIImage imageWithData:data];
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
    int valueIndex = arc4random() % _dataArray.count;
//    int valueIndex = 10;
    NSLog(@"===index===%d", valueIndex);
    NSString *url = _dataArray[valueIndex];
    [self loadDataWithURL:url];
}

- (void)loadDataWithURL:(NSString *)url {
    
    YXLRequestModel *model = [[YXLRequestModel alloc] init];
    model.url = url;
    if (!self.httpClient) {
        self.httpClient = [[YXLHttpClient alloc] init];
    }
    [_httpClient fetchDataWithRequestModel:model
                                   success:^(id data) {
//                                       if ([data isKindOfClass:[YXLCacheModel class]]) {
//                                           
//                                       }
                                   }
                                   failure:^(YXLError *error) {
                                       
                                   }];
}

@end
