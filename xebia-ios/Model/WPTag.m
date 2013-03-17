//
//  WPTag.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "WPTag.h"
#import "DCParserConfiguration.h"
#import "DCKeyValueObjectMapping.h"
#import "DCObjectMapping.h"

@implementation WPTag

- (NSString *)capitalizedTitle {
    return [self.title stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                               withString:[[self.title substringToIndex:1] capitalizedString]];
}

/*
- (NSInteger)postCount {
    return [self.postCount integerValue];
}
*/

+(DCParserConfiguration *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];

    [config addObjectMapping: [DCObjectMapping mapKeyPath:@"id" toAttribute:@"identifier" onClass:[self class]]];
    [config addObjectMapping: [DCObjectMapping mapKeyPath:@"description" toAttribute:@"description_" onClass:[self class]]];

    return config;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"WPTag[id='%@', title='%@']", self.identifier, self.title];
}

@end
