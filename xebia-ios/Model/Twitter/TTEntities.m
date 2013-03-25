//
// Created by akinsella on 18/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TTEntities.h"
#import "DCParserConfiguration.h"
#import "TTHashtagEntity.h"
#import "DCArrayMapping.h"
#import "DCParserConfiguration+XBAdditions.h"
#import "TTUrlEntity.h"
#import "TTUserMentionEntity.h"

@implementation TTEntities

+ (DCParserConfiguration *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];

    [config addArrayMapper: [DCArrayMapping mapperForClassElements:[TTHashtagEntity class] forAttribute:@"hashtags" onClass:[self class]]];
    [config mergeConfig:[[TTHashtagEntity class] mappings]];

    [config addArrayMapper: [DCArrayMapping mapperForClassElements:[TTUrlEntity class] forAttribute:@"urls" onClass:[self class]]];
    [config mergeConfig:[[TTUrlEntity class] mappings]];

    [config addArrayMapper: [DCArrayMapping mapperForClassElements: [TTUserMentionEntity class] forAttribute:@"user_mentions" onClass:[self class]]];
    [config mergeConfig:[[TTUserMentionEntity class] mappings]];

    return config;
}

@end