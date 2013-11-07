//
// Created by akinsella on 04/10/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <DCKeyValueObjectMapping/DCObjectMapping.h>
#import "TTTweet.h"
#import "DCParserConfiguration+XBAdditions.h"


@implementation TTRetweetedStatus

+ (DCParserConfiguration *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    config.datePattern = @"yyyy-MM-dd HH:mm:ss";

    [config addObjectMapping: [DCObjectMapping mapKeyPath:@"id" toAttribute:@"identifier" onClass:[self class]]];
    [config addObjectMapping: [DCObjectMapping mapKeyPath:@"id_str" toAttribute:@"identifier_str" onClass:[self class]]];

    [config mergeConfig:[TTUser mappings]];
    [config mergeConfig:[TTEntities mappings]];

    return config;
}

@end