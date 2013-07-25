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

- (NSString *)formatDateOrTime;

- (BOOL)isToday;

- (NSString *)formatDateRelativeToNow;
@end