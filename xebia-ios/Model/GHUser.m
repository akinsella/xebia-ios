    //
//  TTUser.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GHUser.h"
#import "GravatarHelper.h"

@implementation GHUser

@dynamic identifier;
@dynamic login;
@dynamic gravatar_id;
@dynamic url;
@dynamic avatar_url;
@dynamic create_at;
@dynamic type;
@dynamic bio;
@dynamic public_gists;
@dynamic email;
@dynamic html_url;
@dynamic followers;
@dynamic name;
@dynamic company;
@dynamic hireable;
@dynamic following;
@dynamic blog;
@dynamic location;


- (NSURL *)avatarImageUrl {
    return self.gravatar_id != nil ?
        [GravatarHelper getGravatarURLWithGravatarId: self.gravatar_id] :
        [NSURL URLWithString: self.avatar_url];
}


- (NSURL *)description_ {
    if (self.location != nil) {
        return [NSString stringWithFormat:@"%@ - %@ follower%@", self.location, self.followers, self.followers.intValue > 1 ? @"s" : @""];
    }
    else {
        return [NSString stringWithFormat:@"%@ follower%@", self.followers, self.followers.intValue > 1 ? @"s" : @""];
    }
}

@end

