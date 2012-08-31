    //
//  RKTTUser.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RKTTUser.h"

@implementation RKTTUser

@dynamic identifier;
@dynamic screen_name;
@dynamic name;
@dynamic profile_image_url;

- (NSURL *)avatarImageUrl {
    return [NSURL URLWithString:[self profile_image_url]];
}

@end

