//
// Created by Simone Civetta on 16/03/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferenceRatingManager.h"
#import "XBConferenceRating.h"
#import "XBConference.h"

@interface XBConferenceRatingManager()

@property (nonatomic, strong) NSMutableSet *ratings;

@end

@implementation XBConferenceRatingManager

+ (instancetype)sharedManager {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.ratings = [NSMutableSet set];
    }
    return self;
}

- (void)addRating:(XBConferenceRating *)rating {
    [self.ratings addObject:rating];
}

- (NSArray *)ratingsForConference:(XBConference *)conference {
    NSPredicate *conferenceFilterPredicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"conferenceId == %d", conference.identifier.intValue]];
    return [[self.ratings filteredSetUsingPredicate:conferenceFilterPredicate] allObjects];
}

@end