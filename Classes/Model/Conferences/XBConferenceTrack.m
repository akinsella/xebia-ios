//
// Created by Simone Civetta on 08/02/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <DCKeyValueObjectMapping/DCObjectMapping.h>
#import <DCKeyValueObjectMapping/DCCustomParser.h>
#import "XBConferenceTrack.h"
#import "DCCustomParser+XBConferenceAdditions.h"


@implementation XBConferenceTrack

+ (DCParserConfiguration *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];

    [config addCustomParsersObject:[[DCCustomParser alloc] initWithBlockParser:[DCCustomParser stringParser]
                                                              forAttributeName:@"_identifier"
                                                            onDestinationClass:[self class]]];

    [config addObjectMapping: [DCObjectMapping mapKeyPath:@"id" toAttribute:@"identifier" onClass:[self class]]];
    [config addObjectMapping: [DCObjectMapping mapKeyPath:@"description" toAttribute:@"description_" onClass:[self class]]];

    return config;
}

@end