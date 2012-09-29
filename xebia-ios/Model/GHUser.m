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

@synthesize identifier;
@synthesize login;
@synthesize gravatar_id;
@synthesize url;
@synthesize avatar_url;
@synthesize created_at;
@synthesize type;
@synthesize bio;
@synthesize public_gists;
@synthesize public_repos;
@synthesize email;
@synthesize html_url;
@synthesize followers;
@synthesize name;
@synthesize company;
@synthesize hireable;
@synthesize following;
@synthesize blog;
@synthesize location;


- (NSURL *)avatarImageUrl {
    NSLog(@"User: %@", self );
    return self.gravatar_id != nil ?
        [GravatarHelper getGravatarURLWithGravatarId: self.gravatar_id] :
        [NSURL URLWithString: self.avatar_url];
}

- (NSString *)description_ {
    if (self.location != nil) {
        return [NSString stringWithFormat:@"%@ - %@ follower%@", self.location, self.followers, self.followers.intValue > 1 ? @"s" : @""];
    }
    else {
        return [NSString stringWithFormat:@"%@ follower%@", self.followers, self.followers.intValue > 1 ? @"s" : @""];
    }
}

+ (RKObjectMapping *)mapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class] usingBlock:^(RKObjectMapping *mapping) {
        [mapping mapAttributes: @"created_at", @"type", @"bio", @"login", @"public_gists", @"email", @"gravatar_id", @"public_repos", @"html_url", @"followers", @"avatar_url", @"name", @"url", @"name", @"url", @"company", @"hireable", @"following", @"blog", @"location", nil];
        [mapping mapKeyPathsToAttributes:
                @"id", @"identifier",
                nil];
    }];

    return mapping;

}


@end

