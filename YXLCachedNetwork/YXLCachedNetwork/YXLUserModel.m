//
//  YXLUserModel.m
//  YXLCachedNetwork
//
//  Created by yingxl1992 on 16/1/28.
//  Copyright © 2016年 yingxl1992. All rights reserved.
//

#import "YXLUserModel.h"

@implementation YXLUserModel

- (void)modelWithData:(NSDictionary *)data {
    self.userId = data[@"id"];
    self.username = data[@"username"];
}

@end
