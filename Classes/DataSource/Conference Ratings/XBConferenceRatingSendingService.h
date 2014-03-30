//
// Created by Simone Civetta on 30/03/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XBHttpClient;


@interface XBConferenceRatingSendingService : NSObject

- (id)initWithHttpClient:(XBHttpClient *)httpClient ratings:(NSArray *)ratings;

+ (id)dataSourceWithHttpClient:(XBHttpClient *)httpClient ratings:(NSArray *)ratings;

@end