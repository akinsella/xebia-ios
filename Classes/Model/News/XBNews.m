//
// Created by Alexis Kinsella on 23/10/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//


#import <DCKeyValueObjectMapping/DCObjectMapping.h>
#import <DCKeyValueObjectMapping/DCArrayMapping.h>
#import "XBNews.h"
#import "XBNewsMetadata.h"
#import "DCParserConfiguration+XBAdditions.h"


@implementation XBNews

+ (DCParserConfiguration *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    config.datePattern = @"yyyy-MM-dd HH:mm:ss";

    [config addObjectMapping: [DCObjectMapping mapKeyPath:@"id" toAttribute:@"identifier" onClass:[self class]]];

    [config addArrayMapper: [DCArrayMapping mapperForClassElements:[XBNewsMetadata class] forAttribute:@"metadata" onClass:[self class]]];
    [config mergeConfig:[[XBNewsMetadata class] mappings]];

    return config;
}

@end