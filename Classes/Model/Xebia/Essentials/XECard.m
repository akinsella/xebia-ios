//
// Created by Alexis Kinsella on 09/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <DCKeyValueObjectMapping/DCObjectMapping.h>
#import <DCKeyValueObjectMapping/DCArrayMapping.h>
#import "XECard.h"
#import "XECardCategory.h"
#import "XECardFront.h"
#import "XECardBack.h"
#import "DCParserConfiguration+XBAdditions.h"
#import "XECardSponsor.h"
#import "XECardTag.h"


@implementation XECard

+ (DCParserConfiguration *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];

    [config addObjectMapping: [DCObjectMapping mapKeyPath:@"id" toAttribute:@"identifier" onClass:[self class]]];

    [config mergeConfig:[XECardCategory mappings]];
    [config mergeConfig:[XECardFront mappings]];
    [config mergeConfig:[XECardBack mappings]];

    [config addArrayMapper: [DCArrayMapping mapperForClassElements:[XECardSponsor class] forAttribute:@"sponsors" onClass:[self class]]];
    [config mergeConfig:[[XECardSponsor class] mappings]];

    [config addArrayMapper: [DCArrayMapping mapperForClassElements:[XECardTag class] forAttribute:@"tags" onClass:[self class]]];
    [config mergeConfig:[[XECardTag class] mappings]];

    return config;
}

@end