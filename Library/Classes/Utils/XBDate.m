//
//  Date.m
//  Xebia Application
//
//  Created by Alexis Kinsella on 19/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//
#import "XBDate.h"


@implementation XBDate

+ (NSDate *)parseDate:(NSString *)dateStr withFormat:format {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:format];
    [df setTimeZone:[NSTimeZone localTimeZone]];
    NSDate *date = [df dateFromString:dateStr];
    
    return date;
}

@end
