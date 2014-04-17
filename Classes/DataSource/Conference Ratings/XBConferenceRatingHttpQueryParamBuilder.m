//
// Created by Simone Civetta on 30/03/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferenceRatingHttpQueryParamBuilder.h"
#import "XBConference.h"
#import "XBConferenceRating.h"

@interface XBConferenceRatingHttpQueryParamBuilder()

@property (nonatomic, strong) NSArray *ratings;

@end

@implementation XBConferenceRatingHttpQueryParamBuilder

- (NSDateFormatter *)dateFormatter {
    static dispatch_once_t once;
    static NSDateFormatter *sharedConferenceHomeDateCellDateFormatter;
    dispatch_once(&once, ^ {
        sharedConferenceHomeDateCellDateFormatter = [[NSDateFormatter alloc] init];
        sharedConferenceHomeDateCellDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ssZZZ";
    });
    return sharedConferenceHomeDateCellDateFormatter;
}

- (instancetype)initWithRatings:(NSArray *)ratings {
    self = [super init];
    if (self) {
        self.ratings = ratings;
    }

    return self;
}

+ (instancetype)builderWithRatings:(NSArray *)ratings {
    return [[self alloc] initWithRatings:ratings];
}

- (id)build {
    NSMutableArray *ratingsToSend = [NSMutableArray array];
    NSString *deviceIdentifier = [[UIDevice currentDevice].identifierForVendor UUIDString];
    for (XBConferenceRating *rating in self.ratings) {
        NSMutableDictionary *ratingDict = [NSMutableDictionary dictionary];
        ratingDict[@"deviceId"] = deviceIdentifier;
        ratingDict[@"conferenceId"] = rating.conferenceId;
        ratingDict[@"presentationId"] = rating.presentationId;
        ratingDict[@"rating"] = @(rating.value.intValue + 1);
        ratingDict[@"date"]  = [self.dateFormatter stringFromDate:rating.dateTaken ? rating.dateTaken: [NSDate new]];
        [ratingsToSend addObject:ratingDict];
    }
    return ratingsToSend;
}

@end