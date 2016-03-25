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

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIAlertController *alertController;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (nonatomic, copy) NSArray *dataArray;

@property (nonatomic, strong) YXLHttpClient *httpClient;

@end

@implementation ViewController

//- (IBAction)startRequese:(id)sender {
//    YXLRequestModel *model = [[YXLRequestModel alloc] init];
//    model.functionId = @"users";
//    model.params = nil;
////    model.showToast = NO;
//
//    if (!self.httpClient) {
//        self.httpClient = [[YXLHttpClient alloc] init];
//    }
//    [_httpClient fetchDataWithRequestModel:model
//                                  success:^(id data) {
//                                      if ([data isKindOfClass:[YXLCacheModel class]]) {
//                                          self.dataArray = ((YXLCacheModel *)data).data[@"userList"];
//                                          [_mainTableView reloadData];
//                                      }
//                                  }
//                                  failure:^(YXLError *error) {
//
//                                  }];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"testURL" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    self.dataArray = [data allValues];
    
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    
    [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_mainTableView reloadData];
    
    for (int i = 0; i < 200; i++) {
        NSLog(@"第%d次===", i);
        [self timerFired];
        [NSThread sleepForTimeInterval:5.0f];
    }
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
//    [timer fire];
//    for (int i = 0; i < 100; i++) {
//        dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, 3ull *NSEC_PER_SEC);
//        dispatch_after(time, dispatch_get_main_queue(), ^{
//            [self timerFired];
//        });
//    }
    
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
//    [timer fire];
    
    //GCD定时器
    //    dispatch_source_t timer=dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    //
    //    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, 5*NSEC_PER_SEC), DISPATCH_TIME_FOREVER, 1*NSEC_PER_SEC);
    //
    //    dispatch_source_set_event_handler(timer, ^{
    //        int value = arc4random() % _dataArray.count;
    //        NSString *url = _dataArray[value];
    //        [self loadDataWithURL:url];
    ////        dispatch_source_cancel(timer);
    //    });
    //
    //    dispatch_source_set_cancel_handler(timer, ^{
    //        NSLog(@"cancel");
    //    });
    //    //启动
    //    dispatch_resume(timer);
    
}

- (void)timerFired {
    int value = arc4random() % _dataArray.count;
    NSLog(@"随机数：%d", value);
    NSString *url = _dataArray[value];
    [self loadDataWithURL:url];
    
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [_dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *url = _dataArray[indexPath.row];
    [self loadDataWithURL:url];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadDataWithURL:(NSString *)url {
    
    YXLRequestModel *model = [[YXLRequestModel alloc] init];
    //    model.functionId = @"users";
    //    model.params = nil;
    model.url = url;
    //    model.showToast = NO;
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
