//
//  NSDate+RCF.m
//  YXLCachedNetwork
//
//  Created by yingxl1992 on 16/3/3.
//  Copyright © 2016年 yingxl1992. All rights reserved.
//

#import "NSDate+RCF.h"

@implementation NSDate (RCF)

+ (NSDate *)dateFromRCFString:(NSString *)dateString {
    NSDateFormatter *rfcTimestampFormatterWithTimeZone = [[NSDateFormatter alloc] init];
    [rfcTimestampFormatterWithTimeZone setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [rfcTimestampFormatterWithTimeZone setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    
    NSDate *theDate = nil;
    NSError *error = nil;
    if (![rfcTimestampFormatterWithTimeZone getObjectValue:&theDate forString:dateString range:nil error:&error]) {
        NSLog(@"Date '%@' could not be parsed: %@", dateString, error);
    }
    
    return theDate;
}

- (NSString *)RCFString {
    static NSDateFormatter *df = nil;
    if(df == nil)
    {
        df = [[NSDateFormatter alloc] init];
        df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        df.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        df.dateFormat = @"EEE',' dd MMM yyyy HH':'mm':'ss 'GMT'";
    }
    return [df stringFromDate:self];
}

@end
