//
//  WPAuthor.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "WPAuthor.h"
#import "GravatarHelper.h"
#import "DCParserConfiguration.h"
#import "DCKeyValueObjectMapping.h"
#import "DCObjectMapping.h"

@implementation WPAuthor

- (NSURL *)avatarImageUrl {
    return [GravatarHelper getGravatarURL: [NSString stringWithFormat:@"%@@xebia.fr", [self nickname]]];
}

- (NSString *)uppercaseFirstLetterOfName {
    NSString *aString = [[self valueForKey:@"name"] uppercaseString];

    // support UTF-16:
    NSString *stringToReturn = [aString substringWithRange:[aString rangeOfComposedCharacterSequenceAtIndex:0]];

    // OR no UTF-16 support:
    //NSString *stringToReturn = [aString substringToIndex:1];

    return stringToReturn;
}

+(DCParserConfiguration *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];

    [config addObjectMapping: [DCObjectMapping mapKeyPath:@"id" toAttribute:@"identifier" onClass:[self class]]];
    [config addObjectMapping: [DCObjectMapping mapKeyPath:@"description" toAttribute:@"description_" onClass:[self class]]];

    return config;
}

@end

