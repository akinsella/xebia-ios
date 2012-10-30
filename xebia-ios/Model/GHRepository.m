//
//  GHRepository.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "GHRepository.h"

@implementation GHRepository

+ (RKObjectMapping *)mapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class] usingBlock:^(RKObjectMapping *mapping) {
        [mapping mapAttributes: @"text", @"language", /* @"pushed_at", */ /*@"created_at",*/ @"forks", @"mirror_url", @"has_wiki", @"clone_url", @"watchers", @"ssh_url", /* @"updated_at" ,*/ @"open_issues", @"git_url", @"has_issues", @"html_url", /* @"watchers_count",*/ @"size", @"fork", @"full_name", @"forks_count", @"has_downloads", @"svn_url", @"name", @"url", @"open_issues_count", @"homepage", nil];
        [mapping mapKeyPathsToAttributes:
                @"id", @"identifier",
                @"description", @"description_",
                @"private", @"private_",
                nil];
    }];

    // Relationships
    [mapping hasMany:@"owner" withMapping:[GHUser mapping]];

    return mapping;
}

@end

