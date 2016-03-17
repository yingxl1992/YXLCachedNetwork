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

- (IBAction)startRequese:(id)sender {
    YXLRequestModel *model = [[YXLRequestModel alloc] init];
    model.functionId = @"users";
    model.params = nil;
//    model.showToast = NO;
    
    if (!self.httpClient) {
        self.httpClient = [[YXLHttpClient alloc] init];
    }
    [_httpClient fetchDataWithRequestModel:model
                                  success:^(id data) {
                                      if ([data isKindOfClass:[YXLCacheModel class]]) {
                                          self.dataArray = ((YXLCacheModel *)data).data[@"userList"];
                                          [_mainTableView reloadData];
                                      }
                                  }
                                  failure:^(YXLError *error) {
                                      
                                  }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    
    [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [_dataArray objectAtIndex:indexPath.row][@"username"];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
