//
//  YXLImageCache.h
//  YXLCachedNetwork
//
//  Created by yingxl1992 on 16/5/4.
//  Copyright © 2016年 yingxl1992. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YXLImageCache : NSObject

@property (nonatomic, assign) NSInteger cacheCapacity;

+ (instancetype)sharedImageCache;
- (UIImage *)cachedImageDataWithUrl: (NSString *)url;
- (void)setImageData:(UIImage *)imageData forUrl:(NSString *)url;

@end
