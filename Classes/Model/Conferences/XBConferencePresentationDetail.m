//
// Created by Simone Civetta on 22/02/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <DCKeyValueObjectMapping/DCParserConfiguration.h>
#import <DCKeyValueObjectMapping/DCObjectMapping.h>
#import <DCKeyValueObjectMapping/DCCustomParser.h>
#import <DCKeyValueObjectMapping/DCArrayMapping.h>
#import <Underscore.m/Underscore.h>
#import "XBConferencePresentationDetail.h"
#import "XBConferenceSpeaker.h"
#import "DCParserConfiguration+XBAdditions.h"
#import "XBConferencePresentation.h"

static const NSUInteger XBConferencePresentationRatingStartTime = 10;

@interface XBConferencePresentationDetail()

@property (nonatomic, strong) NSString *speakerString;

@end

@implementation XBConferencePresentationDetail

+ (DCParserConfiguration *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];

    [config addObjectMapping: [DCObjectMapping mapKeyPath:@"id" toAttribute:@"identifier" onClass:[self class]]];

    DCCustomParser *fromTimeDateParser = [[DCCustomParser alloc] initWithBlockParser:[DCCustomParser dateTimeParser]
                                                                    forAttributeName:@"_fromTime"
                                                                  onDestinationClass:[self class]];
    [config addCustomParsersObject:fromTimeDateParser];

    DCCustomParser *toTimeDateParser = [[DCCustomParser alloc] initWithBlockParser:[DCCustomParser dateTimeParser]
                                                                  forAttributeName:@"_toTime"
                                                                onDestinationClass:[self class]];

    [config addArrayMapper: [DCArrayMapping mapperForClassElements:[XBConferenceSpeaker class] forAttribute:@"speakers" onClass:[self class]]];
    [config mergeConfig:[[XBConferenceSpeaker class] mappings]];

    [config addCustomParsersObject:toTimeDateParser];

    return config;
}

- (void)mergeWithPresentation:(XBConferencePresentation *)presentation {
    self.fromTime = presentation.fromTime;
    self.toTime = presentation.toTime;
}

- (NSString *)speakerString {
    if (!_speakerString) {
        _speakerString = [Underscore.array(self.speakers).uniq.map(^(XBConferenceSpeaker *speaker){
            return speaker.name;
        }).unwrap componentsJoinedByString:@", "];
    }
    return _speakerString;
}

- (BOOL)canBeVoted {
    NSDate *endDatePostponed = [self.toTime dateByAddingTimeInterval:(XBConferencePresentationRatingStartTime * 60)];
    return !endDatePostponed || [endDatePostponed compare:[NSDate date]] == NSOrderedAscending;
}

@end