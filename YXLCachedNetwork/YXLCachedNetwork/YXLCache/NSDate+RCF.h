//
//  NSDate+RCF.h
//  YXLCachedNetwork
//
//  Created by yingxl1992 on 16/3/3.
//  Copyright © 2016年 yingxl1992. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (RCF)

+ (NSDate *)dateFromRCFString:(NSString *)dateString;

- (NSString *)RCFString;

@end
