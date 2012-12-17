//
//  WPAuthor.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "WPAuthor.h"
#import "GravatarHelper.h"

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

+ (RKObjectMapping *)mapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class] usingBlock:^(RKObjectMapping *mapping) {
//        mapping.rootKeyPath = @"authors";
        [mapping mapAttributes:@"slug", @"name", @"first_name", @"last_name", @"nickname", @"url", nil];
        [mapping mapKeyPathsToAttributes:
                @"id", @"identifier",
                @"description", @"description_",
                nil];

    }];

    return mapping;
}

@end

