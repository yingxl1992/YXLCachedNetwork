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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)timerFired {
    int valueIndex = arc4random() % _dataArray.count;
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
