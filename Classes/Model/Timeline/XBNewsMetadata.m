//
// Created by Alexis Kinsella on 12/11/2013.
// Copyright (c) 2013 Xebia. All rights reserved.
//


#import <DCKeyValueObjectMapping/DCArrayMapping.h>
#import "XBNewsMetadata.h"

@implementation XBNewsMetadata

+ (DCParserConfiguration *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];

    return config;
}

@end