//
//  GHRepository.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "GHRepository.h"
#import "GHOwner.h"

@implementation GHRepository

+ (RKObjectMapping *)mapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class] usingBlock:^(RKObjectMapping *mapping) {
        [mapping mapAttributes:
                        @"name", @"full_name", @"language", @"html_url", @"homepage",
                        @"has_wiki", @"has_issues", @"has_downloads", @"fork", @"watchers", @"forks",
                        @"open_issues", @"size", @"pushed_at", @"created_at", @"updated_at", nil];
        [mapping mapKeyPathsToAttributes:
                @"id", @"identifier",
                @"description", @"description_",
                nil];
    }];

    // Relationships
    [mapping hasMany:@"owner" withMapping:[GHOwner mapping]];

    return mapping;
}

@end

