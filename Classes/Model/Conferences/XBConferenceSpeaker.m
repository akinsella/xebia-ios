//
// Created by Simone Civetta on 26/01/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <DCKeyValueObjectMapping/DCObjectMapping.h>
#import "XBConferenceSpeaker.h"


@implementation XBConferenceSpeaker

+ (DCParserConfiguration *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];

    [config addObjectMapping: [DCObjectMapping mapKeyPath:@"id" toAttribute:@"identifier" onClass:[self class]]];

    return config;
}

@end