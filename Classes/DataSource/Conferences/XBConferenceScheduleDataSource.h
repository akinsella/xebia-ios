//
// Created by Simone Civetta on 04/02/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBReloadableArrayDataSource.h"


@interface XBConferenceScheduleDataSource : XBReloadableArrayDataSource

- (instancetype)initWithResourcePath:(NSString *)resourcePath;

- (void)loadAndFilterDistinctDays:(void (^)())callback;

+ (instancetype)dataSourceWithResourcePath:(NSString *)resourcePath;

- (void)loadAndFilterByDay:(NSDate *)day callback:(void (^)())callback;

- (void)loadAndFilterByIdentifiers:(NSArray *)identifiers callback:(void (^)())callback;
@end