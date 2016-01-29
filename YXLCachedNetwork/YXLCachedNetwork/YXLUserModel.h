//
//  YXLUserModel.h
//  YXLCachedNetwork
//
//  Created by yingxl1992 on 16/1/28.
//  Copyright © 2016年 yingxl1992. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXLUserModel : NSObject

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *username;

- (void)modelWithData:(NSDictionary *)data;

@end
