//
// Created by akinsella on 04/10/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TTTweet.h"
#import "XBDate.h"
#import "TTRetweetedStatus.h"
#import "DCParserConfiguration.h"
#import "DCKeyValueObjectMapping.h"
#import "DCParserConfiguration+XBAdditions.h"
#import "NSDate+XBAdditions.h"


@implementation TTRetweetedStatus

+ (DCParserConfiguration *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    config.datePattern = @"yyyy-MM-dd HH:mm:ss";

    [config mergeConfig:[TTUser mappings]];
    [config mergeConfig:[TTEntities mappings]];

    return config;
}

@end