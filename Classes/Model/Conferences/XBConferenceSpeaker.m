//
// Created by Simone Civetta on 26/01/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <DCKeyValueObjectMapping/DCObjectMapping.h>
#import <DCKeyValueObjectMapping/DCArrayMapping.h>
#import "XBConferenceSpeaker.h"
#import "XBConferenceSpeakerTalk.h"
#import "DCParserConfiguration+XBAdditions.h"


@implementation XBConferenceSpeaker

+ (DCParserConfiguration *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];

    [config addObjectMapping: [DCObjectMapping mapKeyPath:@"id" toAttribute:@"identifier" onClass:[self class]]];

    [config addArrayMapper: [DCArrayMapping mapperForClassElements:[XBConferenceSpeakerTalk class] forAttribute:@"talks" onClass:[self class]]];
    [config mergeConfig:[[XBConferenceSpeakerTalk class] mappings]];

    return config;
}

@end