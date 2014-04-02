//
// Created by Simone Civetta on 16/03/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <Underscore.m/Underscore.h>
#import "XBConferenceRatingManager.h"
#import "XBConferenceRating.h"
#import "XBConference.h"
#import "XBConferencePresentation.h"
#import "XBConferencePresentationDetail.h"
#import "XBConferenceRatingSendingService.h"
#import "XBPListConfigurationProvider.h"

@interface XBConferenceRatingManager()

@property (nonatomic, strong) NSMutableSet *ratings;
@property (nonatomic, strong) NSRecursiveLock *lock;
@property (nonatomic, strong) XBConferenceRatingSendingService *ratingSendingService;

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
        [self loadFromFile];
    }
    return self;
}

- (void)addRating:(XBConferenceRating *)rating {
    if ([self.ratings containsObject:rating]) {
        [self.ratings removeObject:rating];
    }
    [self.ratings addObject:rating];

    [self writeToFile];
}

- (NSArray *)ratingsForConference:(XBConference *)conference {
    NSPredicate *conferenceFilterPredicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"conferenceId == %@", conference.identifier]];
    return [[self.ratings filteredSetUsingPredicate:conferenceFilterPredicate] allObjects];
}

- (XBConferenceRating *)ratingForPresentation:(XBConferencePresentationDetail *)presentation {
    NSPredicate *conferenceFilterPredicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"presentationId = %@ AND conferenceId == %@", presentation.identifier, presentation.conferenceId]];
    return [[[self.ratings filteredSetUsingPredicate:conferenceFilterPredicate] allObjects] firstObject];
}

- (void)loadFromFile {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.lock lock];
        NSArray *ratings = [NSKeyedUnarchiver unarchiveObjectWithFile:self.filePath];
        [self.ratings addObjectsFromArray:ratings];
        [self.lock unlock];
    });
}

- (void)writeToFile {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.lock lock];
        [NSKeyedArchiver archiveRootObject:[self.ratings allObjects] toFile:self.filePath];
        [self.lock unlock];
    });
}

- (NSString *)filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return [documentsDirectory stringByAppendingPathComponent:@"ratings"];
}

- (void)sendRatings {
    NSArray *allRatings = [self.ratings allObjects];
    NSArray *ratingsToSend = Underscore.filter(allRatings, ^(XBConferenceRating *rating) {
        return (BOOL)![rating.sent boolValue];
    });
    XBHttpClient *httpClient = [[XBPListConfigurationProvider provider] httpClient];
    self.ratingSendingService = [[XBConferenceRatingSendingService alloc] initWithHttpClient:httpClient ratings:ratingsToSend];

    // TODO: At the end, call 'applySentFlagForRatings'
}

- (void)applySentFlagForRatings:(NSArray *)sentRatings {
    for (XBConferenceRating *rating in self.ratings) {
        if ([sentRatings containsObject:rating]) {
            rating.sent = @(YES);
        }
    }
    [self writeToFile];
}

@end