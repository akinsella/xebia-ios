//
// Created by Alexis Kinsella on 17/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <DCKeyValueObjectMapping/DCObjectMapping.h>
#import "XEULink.h"


@implementation XEULink

+ (DCParserConfiguration *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];

    return config;
}

@end