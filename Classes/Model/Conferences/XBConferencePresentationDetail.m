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
#import "DCCustomParser+XBConferenceAdditions.h"

static const NSUInteger XBConferencePresentationRatingStartTime = 10;

@interface XBConferencePresentationDetail()

@property (nonatomic, strong) NSString *speakerString;

@end

@implementation XBConferencePresentationDetail

+ (DCParserConfiguration *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    
    [config addCustomParsersObject:[[DCCustomParser alloc] initWithBlockParser:[DCCustomParser stringParser]
                                                              forAttributeName:@"_identifier"
                                                            onDestinationClass:[self class]]];

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
    if (![presentation respondsToSelector:@selector(fromTime)] ||
        ![presentation respondsToSelector:@selector(toTime)]) {
        return;
    }
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

#if TARGET_IPHONE_SIMULATOR && DEBUG
    return YES;
#endif
    
    NSTimeInterval dayInSeconds = 24 * 60 * 60;
    NSDate *endDateWithThreeDaysAdded = [self.toTime dateByAddingTimeInterval:7 * dayInSeconds];
    if ([endDateWithThreeDaysAdded compare:[NSDate date]] == NSOrderedAscending) {
        return NO;
    }

    NSDate *endDateAdvanced = [self.toTime dateByAddingTimeInterval: - (XBConferencePresentationRatingStartTime * 60)];
    return endDateAdvanced && [endDateAdvanced compare:[NSDate date]] == NSOrderedAscending;
}

- (NSString *)presentationIdentifier {
    return self.identifier;
}

@end