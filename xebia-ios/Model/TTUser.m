//
//  TTUser.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "TTUser.h"

@implementation TTUser

@synthesize identifier;
@synthesize screen_name;
@synthesize name;
@synthesize profile_image_url;

- (NSURL *)avatarImageUrl {
    return [NSURL URLWithString:[self profile_image_url]];
}

+ (RKObjectMapping *)mapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class] usingBlock:^(RKObjectMapping *mapping) {
        [mapping mapAttributes: @"screen_name", @"name", @"profile_image_url", nil];
        [mapping mapKeyPathsToAttributes:
                @"id", @"identifier",
                nil];
    }];

    return mapping;
}


@end

