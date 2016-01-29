//
//  YXLAlertControllViewController.m
//  YXLCachedNetwork
//
//  Created by yingxl1992 on 16/1/29.
//  Copyright © 2016年 yingxl1992. All rights reserved.
//

#import "YXLAlertController.h"
#import "YXLError.h"
#import "AppDelegate.h"

@interface YXLAlertController ()

@property (nonatomic, strong) UIAlertController *alertController;

@property (nonatomic, strong) UIWindow *window;

@end

@implementation YXLAlertController

- (void)showFailureToastWithError:(YXLError *)error {
    if (!self.window) {
        self.window = ((AppDelegate *)([UIApplication sharedApplication].delegate)).window;
    }
    
    if (self.alertController) {
        [self.window.rootViewController dismissViewControllerAnimated:NO completion:nil];
        self.alertController  = nil;
    }
    
    NSString *msg = [NSString stringWithFormat:@"%@", error.detailError.userInfo[NSLocalizedDescriptionKey]];
    self.alertController = [UIAlertController alertControllerWithTitle:@"hint"
                                                               message:msg
                                                        preferredStyle:UIAlertControllerStyleAlert];
    [self.window.rootViewController presentViewController:self.alertController
                                            animated:YES
                                          completion:^{
                                              dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1ull * NSEC_PER_SEC);
                                              dispatch_after(time, dispatch_get_main_queue(), ^{
                                                  [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
                                              });
                                          }];
}

@end
