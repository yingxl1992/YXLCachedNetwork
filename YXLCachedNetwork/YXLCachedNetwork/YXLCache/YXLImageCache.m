//
//  YXLImageCache.m
//  YXLCachedNetwork
//
//  Created by yingxl1992 on 16/5/4.
//  Copyright © 2016年 yingxl1992. All rights reserved.
//

#import "YXLImageDataModel.h"
#import "YXLImageCache.h"

@interface YXLImageCache()

@property (nonatomic, copy) NSArray<YXLImageDataModel *> *queue;

@end

@implementation YXLImageCache

static YXLImageCache *sharedImageCache;

+ (instancetype)sharedImageCache {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedImageCache = [[YXLImageCache alloc] init];
        sharedImageCache.queue = [NSArray array];
        sharedImageCache.cacheCapacity = 50;
    });
    
    return sharedImageCache;
}

- (UIImage *)cachedImageDataWithUrl:(NSString *)url {
    YXLImageDataModel *imageDataModel = [self searchImageInQueueForUrl:url];
    if (!imageDataModel) {
        UIImage *imageData = [self searchImageInDiskForUrl:url];
        return imageData;
    }
    return imageDataModel.imageData;
}

- (void)setImageData:(UIImage *)imageData forUrl:(NSString *)url {
    YXLImageDataModel *imageDataModel = [self searchImageInQueueForUrl:url];
    if (imageDataModel) {
        NSMutableArray *mutableQueue = [NSMutableArray arrayWithArray:self.queue];
        [mutableQueue removeObject:imageDataModel];
        [mutableQueue insertObject:imageDataModel atIndex:0];
        self.queue = [mutableQueue copy];
    }
    else {
        imageDataModel = [[YXLImageDataModel alloc] init];
        imageDataModel.url = url;
        imageDataModel.imageData = imageData;
        NSMutableArray *mutableQueue = [NSMutableArray arrayWithArray:self.queue];
        [mutableQueue insertObject:imageDataModel atIndex:0];
        self.queue = [mutableQueue copy];
        
        NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *pathString = pathArray[0];
        if (self.queue.count > self.cacheCapacity) {
            YXLImageDataModel *lastModel = [self.queue lastObject];
            NSString *imagePath = [pathString stringByAppendingString:lastModel.url];
            NSData *tmpImageData = UIImagePNGRepresentation(lastModel.imageData);
            [tmpImageData writeToFile:imagePath atomically:YES];
            
            NSMutableArray *mutableQueue = [NSMutableArray arrayWithArray:self.queue];
            [mutableQueue removeObject:lastModel];
            self.queue = [mutableQueue copy];
        }
        UIImage *tmpData = [self searchImageInDiskForUrl:url];
        if (tmpData) {
            NSString *imagePath = [pathString stringByAppendingString:url];
            NSError *error = nil;
            [[NSFileManager defaultManager] removeItemAtPath:imagePath error:&error];
            if (error) {
                NSLog(@"Fail to delete file %@", imagePath);
            }
        }
    }
}

#pragma mark - private methods
- (YXLImageDataModel *)searchImageInQueueForUrl:(NSString *)url {
    for (YXLImageDataModel *imageDataModel in self.queue) {
        if ([imageDataModel.url isEqualToString:url]) {
            return imageDataModel;
        }
    }
    return nil;
}

- (UIImage *)searchImageInDiskForUrl:(NSString *)url {
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *pathString = pathArray[0];
    NSString *imagePath = [pathString stringByAppendingString:url];
    UIImage *imageData = [UIImage imageWithContentsOfFile:imagePath];
    return imageData;
}

@end
