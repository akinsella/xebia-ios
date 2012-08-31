    //
//  RKWPAuthor.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RKWPAuthor.h"
#import "GravatarHelper.h"

@implementation RKWPAuthor

@dynamic identifier;
@dynamic slug;
@dynamic name;
@dynamic first_name;
@dynamic last_name;
@dynamic nickname;
@dynamic url;
@dynamic description_;


- (NSURL *)avatarImageUrl {
    return [GravatarHelper getGravatarURL: [NSString stringWithFormat:@"%@@xebia.fr", [self nickname]]];
}

- (NSString *)uppercaseFirstLetterOfName {
    [self willAccessValueForKey:@"uppercaseFirstLetterOfName"];
    NSString *aString = [[self valueForKey:@"name"] uppercaseString];
    
    // support UTF-16:
    NSString *stringToReturn = [aString substringWithRange:[aString rangeOfComposedCharacterSequenceAtIndex:0]];
    
    // OR no UTF-16 support:
    //NSString *stringToReturn = [aString substringToIndex:1];
    
    [self didAccessValueForKey:@"uppercaseFirstLetterOfName"];
    return stringToReturn;
}

@end

