//
// Created by Alexis Kinsella on 09/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <DCKeyValueObjectMapping/DCObjectMapping.h>
#import <DCKeyValueObjectMapping/DCArrayMapping.h>
#import "XECard.h"
#import "XECategory.h"
#import "DCParserConfiguration+XBAdditions.h"
#import "XESponsor.h"
#import "XETag.h"


@implementation XECard

+ (DCParserConfiguration *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];

    [config addObjectMapping: [DCObjectMapping mapKeyPath:@"id" toAttribute:@"identifier" onClass:[self class]]];
    
    [config addObjectMapping: [DCObjectMapping mapKeyPath:@"description" toAttribute:@"description_" onClass:[self class]]];
    
    [config mergeConfig:[XECategory mappings]];

    [config addArrayMapper: [DCArrayMapping mapperForClassElements:[XESponsor class] forAttribute:@"sponsors" onClass:[self class]]];
    [config mergeConfig:[[XESponsor class] mappings]];

    [config addArrayMapper: [DCArrayMapping mapperForClassElements:[XETag class] forAttribute:@"tags" onClass:[self class]]];
    [config mergeConfig:[[XETag class] mappings]];

    return config;
}

@end