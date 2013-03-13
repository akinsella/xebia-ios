//
// Created by akinsella on 29/09/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "EBEvent.h"
#import "EBVenue.h"
#import "EBOrganizer.h"
#import "DCParserConfiguration.h"
#import "DCKeyValueObjectMapping.h"

@implementation EBEvent

+ (DCKeyValueObjectMapping *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    return [DCKeyValueObjectMapping mapperForClass: [self class] andConfiguration:config];
}

@end