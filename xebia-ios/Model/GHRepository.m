//
//  GHRepository.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "GHRepository.h"

@implementation GHRepository

@synthesize identifier;
@synthesize language;
@synthesize pushed_at;
@synthesize created_at;
@synthesize forks;
@synthesize mirror_url;
@synthesize has_wiki;
@synthesize description_;
@synthesize clone_url;
@synthesize owner;
@synthesize watchers;
@synthesize ssh_url;
@synthesize updated_at;
@synthesize open_issues;
@synthesize git_url;
@synthesize has_issues;
@synthesize html_url;
@synthesize watchers_count;
@synthesize size;
@synthesize fork;
@synthesize full_name;
@synthesize forks_count;
@synthesize has_downloads;
@synthesize svn_url;
@synthesize name;
@synthesize url;
@synthesize open_issues_count;
@synthesize homepage;
@synthesize private_;

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

