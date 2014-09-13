//
// Created by Simone Civetta on 02/04/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <DCKeyValueObjectMapping/DCCustomParser.h>
#import <DCKeyValueObjectMapping/DCObjectMapping.h>
#import "XBConferenceRatingResponse.h"


@implementation XBConferenceRatingResponse

+ (DCParserConfiguration *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];

    [config addObjectMapping: [DCObjectMapping mapKeyPath:@"id" toAttribute:@"identifier" onClass:[self class]]];

    return config;
}

@end