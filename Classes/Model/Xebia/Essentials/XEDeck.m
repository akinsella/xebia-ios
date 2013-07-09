//
// Created by Alexis Kinsella on 09/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <DCKeyValueObjectMapping/DCArrayMapping.h>
#import "XEDeck.h"
#import "XECard.h"


@implementation XEDeck

+ (DCParserConfiguration *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];

    [config addArrayMapper: [DCArrayMapping mapperForClassElements:[XECard class] forAttribute:@"cards" onClass:[self class]]];

    return config;
}

@end