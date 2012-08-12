    //
//  RKWPAuthor.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RKWPAuthor.h"
#import "SDWebImageManager.h"
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

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    [self initAvatarUrl];
}

- (void)awakeFromFetch
{
    [super awakeFromInsert];
    [self initAvatarUrl];
}

-(void)initAvatarUrl {
}


@end

