//
//  GHUser.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "GHUser.h"
#import "GravatarHelper.h"

@implementation GHUser

- (NSURL *)avatarImageUrl {
    return self.gravatar_id != nil ?
        [GravatarHelper getGravatarURLWithGravatarId: self.gravatar_id] :
        [NSURL URLWithString: self.avatar_url];
}

- (NSString *)description_ {
    if (self.location) {
        return [NSString stringWithFormat:@"%@ - %@ follower%@", self.location, self.followers, self.followers.intValue > 1 ? @"s" : @""];
    }
    else {
        return [NSString stringWithFormat:@"%@ follower%@", self.followers, self.followers.intValue > 1 ? @"s" : @""];
    }
}

@end

