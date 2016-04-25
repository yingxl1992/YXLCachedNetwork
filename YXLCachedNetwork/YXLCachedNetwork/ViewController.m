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

@property (nonatomic, strong) UIAlertController *alertController;

@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, copy) NSArray *indexs;
@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) YXLHttpClient *httpClient;

@end

@implementation ViewController

- (IBAction)startTest:(id)sender {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"testURL" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    self.dataArray = [data allValues];
    self.indexs = @[@1, @1, @1, @1, @2, @2, @2, @2, @2,@2];
    self.count = 0;
    //
    //    for (int i = 0; i < self.indexs.count; i++, self.count = self.count + 1) {
    //        NSLog(@"第%d次===", i);
    //
    //
    //        [self timerFired];
    //        [NSThread sleepForTimeInterval:5.0f];
    //    }
    for (int i = 0; i < 50; i++) {
        NSLog(@"第%d次===", i);
        
        
        [self timerFired];
        [NSThread sleepForTimeInterval:5.0f];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)timerFired {
    NSInteger valueIndex = ((NSNumber *)_indexs[_count]).integerValue;
    NSString *url = _dataArray[valueIndex];
    NSLog(@"url为%@", url);
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
                                       if ([data isKindOfClass:[YXLCacheModel class]]) {
                                           //                                           self.dataArray = ((YXLCacheModel *)data).data[@"userList"];
                                           //                                           [_mainTableView reloadData];
                                       }
                                   }
                                   failure:^(YXLError *error) {
                                       
                                   }];
}

@end
