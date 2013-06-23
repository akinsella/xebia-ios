//
// Created by akinsella on 01/11/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TTUserMentionEntity.h"
#import "DCParserConfiguration.h"
#import "DCKeyValueObjectMapping.h"
#import "DCParserConfiguration+XBAdditions.h"


@implementation TTUserMentionEntity

+ (DCParserConfiguration *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    [config mergeConfig:[TTIndices mappings]];

    return config;
}

@end