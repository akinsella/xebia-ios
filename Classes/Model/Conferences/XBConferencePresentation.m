//
// Created by Simone Civetta on 04/02/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <DCKeyValueObjectMapping/DCObjectMapping.h>
#import <DCKeyValueObjectMapping/DCCustomParser.h>
#import "XBConferencePresentation.h"
#import "DCCustomParser+XBConferenceAdditions.h"


@implementation XBConferencePresentation

+ (DCParserConfiguration *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];

    [config addObjectMapping: [DCObjectMapping mapKeyPath:@"presentation.id" toAttribute:@"identifier" onClass:[self class]]];
    [config addObjectMapping: [DCObjectMapping mapKeyPath:@"id" toAttribute:@"scheduleId" onClass:[self class]]];

    DCCustomParser *fromTimeDateParser = [[DCCustomParser alloc] initWithBlockParser:[DCCustomParser dateTimeParser]
                                                            forAttributeName:@"_fromTime"
                                                          onDestinationClass:[self class]];
    [config addCustomParsersObject:fromTimeDateParser];

    DCCustomParser *toTimeDateParser = [[DCCustomParser alloc] initWithBlockParser:[DCCustomParser dateTimeParser]
                                                            forAttributeName:@"_toTime"
                                                          onDestinationClass:[self class]];
    [config addCustomParsersObject:toTimeDateParser];

    return config;
}

@end