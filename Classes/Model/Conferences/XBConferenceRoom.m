//
//  XBConferenceRoom.m
//  Xebia
//
//  Created by Simone Civetta on 29/01/14.
//  Copyright (c) 2014 Xebia. All rights reserved.
//

#import <DCKeyValueObjectMapping/DCObjectMapping.h>
#import "XBConferenceRoom.h"

@implementation XBConferenceRoom

+ (DCParserConfiguration *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    
    [config addObjectMapping: [DCObjectMapping mapKeyPath:@"id" toAttribute:@"identifier" onClass:[self class]]];
    
    return config;
}

@end
