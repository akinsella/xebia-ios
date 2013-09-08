//
// Created by Alexis Kinsella on 26/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NSDate+XBAdditions.h"

@implementation NSDate (XBAdditions)

- (BOOL)isToday {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *midnight = [df dateFromString:[df stringFromDate:self]];

    NSInteger dayDiff = (int)[midnight timeIntervalSinceNow] / (60 * 60 * 24);

    return dayDiff == 0;
}

- (NSString *)formatDateRelativeToNow {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *midnight = [df dateFromString:[df stringFromDate:self]];

    NSInteger dayDiff = (int)[midnight timeIntervalSinceNow] / (60 * 60 * 24);

    if(dayDiff == 0) {
        NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
        [df2 setDateFormat:NSLocalizedString(@"HH:mm", nil)];
        NSString *dateFormatted = [df2 stringFromDate:self];
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
        [dateFormatter setDateFormat:NSLocalizedString(@"yyyy'/'MM'/'dd', 'HH':'mm", nil)];
        return [dateFormatter stringFromDate:self];
    }

}

- (NSString *)formatDateTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:NSLocalizedString(@"yyyy'/'MM'/'dd', 'HH':'mm", nil)];
    return [dateFormatter stringFromDate:self];
}

- (NSString *)formatDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:NSLocalizedString(@"dd'/'MM'/'yyyy", nil)];
    return [dateFormatter stringFromDate:self];
}

- (NSString *)formatDayMonth {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:NSLocalizedString(@"dd'/'MM", nil)];
    return [dateFormatter stringFromDate:self];
}

- (NSString *)formatTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:NSLocalizedString(@"HH':'mm", nil)];
    return [dateFormatter stringFromDate:self];
}


- (NSString *)formatDateOrTime {
    NSDateFormatter *dmnf = [[NSDateFormatter alloc] init];
    [dmnf setDateFormat:@"yyyy-MM-dd"];
    NSDate *midnight = [dmnf dateFromString:[dmnf stringFromDate:self]];

    NSInteger dayDiff = (int)[midnight timeIntervalSinceNow] / (60 * 60 * 24);

    if(dayDiff == 0) {
        NSDateFormatter *tf = [[NSDateFormatter alloc] init];
        [tf setDateFormat:NSLocalizedString(@"HH:mm", nil)];
        return [tf stringFromDate:self];
    }
    else {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:NSLocalizedString(@"dd'/'MM", nil)];
        return [df stringFromDate:self];
    }

}

@end