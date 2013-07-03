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

+ (NSString *)formattedDateRelativeToNow:(NSDate *)date {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *midnight = [df dateFromString:[df stringFromDate:date]];

    NSInteger dayDiff = (int)[midnight timeIntervalSinceNow] / (60 * 60 * 24);

    if(dayDiff == 0) {
        NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
        [df2 setDateFormat:NSLocalizedString(@"HH:mm", nil)];
        NSString *dateFormatted = [df2 stringFromDate:date];
//        NSLog(@"Date formatted: %@", dateFormatted);
        return [NSString stringWithFormat:NSLocalizedString(@"Today, %@", nil), dateFormatted];
    }
    else if(dayDiff == -1) {
        return NSLocalizedString(@"Yesterday", nil);
    }
    else if(dayDiff == -2) {
        return NSLocalizedString(@"Two days ago", nil);
    }
    else if(dayDiff > -7 && dayDiff <= -2) {
        return NSLocalizedString(@"This week", nil);
    }
    else if(dayDiff > -14 && dayDiff <= -7) {
        return NSLocalizedString(@"Last week", nil);
    }
    else if(dayDiff >= -30 && dayDiff <= -14) {
        return NSLocalizedString(@"This month", nil);
    }
    else if(dayDiff >= -60 && dayDiff <= -30) {
        return NSLocalizedString(@"Last month", nil);
    }
    else if(dayDiff >= -90 && dayDiff <= -60) {
        return NSLocalizedString(@"Within last three months", nil);
    }
    else if(dayDiff >= -180 && dayDiff <= -90) {
        return NSLocalizedString(@"Within last six months", nil);
    }
    else if(dayDiff >= -365 && dayDiff <= -180) {
        return NSLocalizedString(@"Within this year", nil);
    }
    else if(dayDiff < -365) {
        return NSLocalizedString(@"A long time ago", nil);
    }
    else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:NSLocalizedString(@"yyyy'/'MM'/'dd', 'hh':'mm", nil)];
        return [dateFormatter stringFromDate:date];        
    }

}

+ (NSString *)formatDateTime:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:NSLocalizedString(@"yyyy'/'MM'/'dd', 'hh':'mm", nil)];
    return [dateFormatter stringFromDate:date];
}
@end
