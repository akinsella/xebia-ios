//
// Created by Simone Civetta on 26/01/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <DCKeyValueObjectMapping/DCObjectMapping.h>
#import <DCKeyValueObjectMapping/DCArrayMapping.h>
#import <DCKeyValueObjectMapping/DCCustomParser.h>
#import "XBConferenceSpeaker.h"
#import "XBConferenceSpeakerTalk.h"
#import "DCParserConfiguration+XBAdditions.h"
#import "DCCustomParser+XBConferenceAdditions.h"


@implementation XBConferenceSpeaker

+ (DCParserConfiguration *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];

    [config addCustomParsersObject:[[DCCustomParser alloc] initWithBlockParser:[DCCustomParser stringParser]
                                                              forAttributeName:@"_identifier"
                                                            onDestinationClass:[self class]]];

    [config addObjectMapping: [DCObjectMapping mapKeyPath:@"id" toAttribute:@"identifier" onClass:[self class]]];

    [config addArrayMapper: [DCArrayMapping mapperForClassElements:[XBConferenceSpeakerTalk class] forAttribute:@"talks" onClass:[self class]]];
    [config mergeConfig:[[XBConferenceSpeakerTalk class] mappings]];

    return config;
}

- (BOOL)isEqual:(id)object
{
    if ([super isEqual:object]) {
        return YES;
    }
    
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    XBConferenceSpeaker *speaker = (XBConferenceSpeaker *)object;
    return [speaker.identifier intValue] == [self.identifier intValue];
}

- (NSUInteger)hash {
    return [self.identifier hash];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ (%@ %@)", self.name, self.firstName, self.lastName];
}

@end