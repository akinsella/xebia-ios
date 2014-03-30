//
// Created by Simone Civetta on 30/03/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferenceRatingHttpQueryParamBuilder.h"

@interface XBConferenceRatingHttpQueryParamBuilder()

@property (nonatomic, strong) NSArray *ratings;

@end

@implementation XBConferenceRatingHttpQueryParamBuilder

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

- (NSDictionary *)build {
    // TODO: implement this
    return [self.dictionary copy];
}

@end