//
//  TTTweet.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "TTTweet.h"
#import "Date.h"
#import "TTEntities.h"


@implementation TTTweet

@synthesize identifier;
@synthesize created_at;
@synthesize user;
@synthesize text;
@synthesize retweeted_status;
@synthesize entities;
@synthesize favorited;
@synthesize retweeted;
@synthesize retweet_count;

- (NSString *)dateFormatted {
    return [Date formattedDateRelativeToNow: self.created_at];
}

- (NSString *)ownerScreenName {
    return retweeted_status ? retweeted_status.user.screen_name : user.screen_name;
}

- (NSURL *)ownerImageUrl {
    NSURL *ownerImageUrl = retweeted_status ?
            [NSURL URLWithString:retweeted_status.user.profile_image_url] :
            [NSURL URLWithString:user.profile_image_url];

    return ownerImageUrl;
}

+ (RKObjectMapping *)mapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class] usingBlock:^(RKObjectMapping *mapping) {
        [mapping mapAttributes: @"text", @"created_at", nil];
        [mapping mapKeyPathsToAttributes:
                @"id", @"identifier",
                nil];

        // Relationships
        [mapping hasMany:@"user" withMapping:[TTUser mapping]];
        [mapping mapKeyPath:@"retweeted_status" toRelationship:@"retweeted_status" withMapping:[TTRetweetedStatus mapping]];
        [mapping mapKeyPath:@"entities" toRelationship:@"entities" withMapping:[TTEntities mapping]];
    }];

    return mapping;
}

@end

