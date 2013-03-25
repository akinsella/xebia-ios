//
// Created by akinsella on 01/11/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TTHashtagEntity.h"
#import "DCParserConfiguration.h"
#import "DCKeyValueObjectMapping.h"
#import "DCParserConfiguration+XBAdditions.h"


@implementation TTHashtagEntity

+ (DCParserConfiguration *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    [config mergeConfig:[TTIndices mappings]];

    return config;
}

@end