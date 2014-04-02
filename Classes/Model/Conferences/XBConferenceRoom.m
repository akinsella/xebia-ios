//
//  XBConferenceRoom.m
//  Xebia
//
//  Created by Simone Civetta on 29/01/14.
//  Copyright (c) 2014 Xebia. All rights reserved.
//

#import <DCKeyValueObjectMapping/DCObjectMapping.h>
#import <DCKeyValueObjectMapping/DCCustomParser.h>
#import "XBConferenceRoom.h"
#import "DCCustomParser+XBConferenceAdditions.h"

@implementation XBConferenceRoom

+ (DCParserConfiguration *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    [config addCustomParsersObject:[[DCCustomParser alloc] initWithBlockParser:[DCCustomParser stringParser]
                                                              forAttributeName:@"_identifier"
                                                            onDestinationClass:[self class]]];
    [config addObjectMapping: [DCObjectMapping mapKeyPath:@"id" toAttribute:@"identifier" onClass:[self class]]];
    
    return config;
}

@end
