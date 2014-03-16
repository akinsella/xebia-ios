//
// Created by Simone Civetta on 16/03/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XBConferenceRating;
@class XBConference;


@interface XBConferenceRatingManager : NSObject

+ (instancetype)sharedManager;

- (void)addRating:(XBConferenceRating *)rating;

- (NSArray *)ratingsForConference:(XBConference *)conference;
@end