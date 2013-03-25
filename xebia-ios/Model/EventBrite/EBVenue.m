//
// Created by akinsella on 29/09/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "EBVenue.h"
#import "DCParserConfiguration.h"
#import "DCKeyValueObjectMapping.h"

@implementation EBVenue

+ (DCParserConfiguration *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    return config;
}

@end