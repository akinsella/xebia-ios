//
// Created by Simone Civetta on 30/03/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBBasicHttpQueryParamBuilder.h"


@interface XBConferenceRatingHttpQueryParamBuilder : XBBasicHttpQueryParamBuilder

- (instancetype)initWithRatings:(NSArray *)ratings;
+ (instancetype)builderWithRatings:(NSArray *)ratings;

@end