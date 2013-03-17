//
// Created by akinsella on 31/12/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TTIndices.h"
#import "DCParserConfiguration.h"
#import "DCKeyValueObjectMapping.h"

@implementation TTIndices

+ (DCParserConfiguration *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    return config;
}

@end