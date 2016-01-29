//
//  YXLAlertControllViewController.h
//  YXLCachedNetwork
//
//  Created by yingxl1992 on 16/1/29.
//  Copyright © 2016年 yingxl1992. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YXLError;

@interface YXLAlertController : UIViewController

- (void)showFailureToastWithError:(YXLError *)error;

@end
