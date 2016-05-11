//
//  YXLImageDataModel.h
//  YXLCachedNetwork
//
//  Created by yingxl1992 on 16/5/5.
//  Copyright © 2016年 yingxl1992. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YXLImageDataModel : NSObject

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) UIImage *imageData;
@property (nonatomic, assign) NSInteger cacheCapacity;

@end
