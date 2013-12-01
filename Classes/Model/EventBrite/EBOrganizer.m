//
// Created by akinsella on 29/09/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <DCKeyValueObjectMapping/DCObjectMapping.h>
#import "EBOrganizer.h"

@implementation EBOrganizer

+ (DCParserConfiguration *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];

    [config addObjectMapping: [DCObjectMapping mapKeyPath:@"id" toAttribute:@"identifier" onClass:[self class]]];

    return config;
}

@end