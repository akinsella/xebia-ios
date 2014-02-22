//
// Created by Alexis Kinsella on 26/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@interface NSDate (XBAdditions)

- (NSString *)formatDateTime;

- (NSString *)formatDate;

- (NSString *)formatDayMonth;

- (NSString *)formatTime;

- (NSString *)formatAuto;

- (NSString *)formatDateOrTime;

- (NSInteger)day;

- (NSInteger)month;

- (NSInteger)hours;

- (NSString *)formatDayLongMonth;

- (BOOL)isToday;

- (NSString *)formatDateRelativeToNow;

- (BOOL)equalsToDayInDate:(NSDate *)date;

@end