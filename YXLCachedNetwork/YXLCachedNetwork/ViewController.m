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

@interface ViewController ()

@property (nonatomic, strong) UIAlertController *alertController;

@end

@implementation ViewController

- (IBAction)startRequese:(id)sender {
    YXLRequestModel *model = [[YXLRequestModel alloc] init];
    model.functionId = @"users";
    model.params = nil;
//    model.showToast = NO;
    
    YXLHttpClient *httpClient = [[YXLHttpClient alloc] init];
    [httpClient fetchDataWithRequestModel:model
                                  success:^(id data) {
                                      if ([data isKindOfClass:[NSArray class]]) {
                                          NSLog(@"NSArray");
                                      }
                                      if ([data isKindOfClass:[NSDictionary class]]) {
                                          NSLog(@"NSDictionary");
                                      }
                                  }
                                  failure:^(YXLError *error) {
                                      
                                  }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
