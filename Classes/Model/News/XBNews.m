//
// Created by Alexis Kinsella on 23/10/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//


#import <DCKeyValueObjectMapping/DCObjectMapping.h>
#import "XBNews.h"


@implementation XBNews

+ (DCParserConfiguration *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    config.datePattern = @"yyyy-MM-dd HH:mm:ss";

    [config addObjectMapping: [DCObjectMapping mapKeyPath:@"id" toAttribute:@"identifier" onClass:[self class]]];

    return config;
}

@end