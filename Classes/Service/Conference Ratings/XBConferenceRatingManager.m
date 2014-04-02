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
#import "XBConferenceRatingUploader.h"
#import "XBPListConfigurationProvider.h"
#import "XBConferenceRatingUploader.h"
#import "XBLogging.h"
#import "NSTimer+BlocksKit.h"

@interface XBConferenceRatingManager()

@property (nonatomic, strong) NSMutableSet *ratings;
@property (nonatomic, strong) NSRecursiveLock *lock;
@property(nonatomic, strong) NSTimer *synchronizationTimer;

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
        [self configureScheduler];
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

- (void)sendRatingsOfConference:(XBConference *)conference {
    NSArray *allRatings = [self.ratings allObjects];
    NSArray *ratingsToSend = Underscore.filter(allRatings, ^(XBConferenceRating *rating) {
        return (BOOL)![rating.sent boolValue];
    });
    XBHttpClient *httpClient = [[XBPListConfigurationProvider provider] httpClient];
    XBConferenceRatingUploader *ratingSendingUploader = [XBConferenceRatingUploader uploaderWithRatings:ratingsToSend conference:conference httpClient:httpClient];
    [ratingSendingUploader uploadRatingsWithSuccess:^(id responseObject) {
        [self applySentFlagForRatings:ratingsToSend];
    } failure:^(id responseObject, NSError *error) {
        XBLog(@"Could not to upload ratings");
    }];
}

- (void)applySentFlagForRatings:(NSArray *)sentRatings {
    for (XBConferenceRating *rating in self.ratings) {
        if ([sentRatings containsObject:rating]) {
            rating.sent = @(YES);
        }
    }
    [self writeToFile];
}

- (void)configureScheduler {
    XBLogDebug(@"Registered timer with interval of 2 seconds");

    self.synchronizationTimer = [NSTimer bk_timerWithTimeInterval:30 block:^(NSTimer *timer) {
        [self sendRatingsOfConference:nil];
    } repeats:YES];

    [[NSRunLoop mainRunLoop] addTimer:self.synchronizationTimer forMode:NSRunLoopCommonModes];
}

- (void)dealloc {
    XBLogDebug(@"[%d] Dealloc", self.hash);
    XBLogDebug(@"Disposing timer");
    [self.synchronizationTimer invalidate];
}


@end