//
// Created by akinsella on 29/09/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <DCKeyValueObjectMapping/DCObjectMapping.h>
#import "EBEvent.h"
#import "DCParserConfiguration+XBAdditions.h"

@implementation EBEvent

+ (DCParserConfiguration *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    config.datePattern = @"yyyy-MM-dd HH:mm:ss";

    [config addObjectMapping: [DCObjectMapping mapKeyPath:@"id" toAttribute:@"identifier" onClass:[self class]]];
    [config addObjectMapping: [DCObjectMapping mapKeyPath:@"description" toAttribute:@"description_" onClass:[self class]]];

    [config mergeConfig:[EBOrganizer mappings]];
    [config mergeConfig:[EBVenue mappings]];

    return config;
}

- (BOOL)isCompleted {
    return [self.status isEqualToString: @"Completed"];
}

@end