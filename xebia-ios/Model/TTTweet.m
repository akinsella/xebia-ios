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

- (NSString *)dateFormatted {
    return [Date formattedDateRelativeToNow: self.created_at];
}

- (NSString *)ownerScreenName {
    return self.retweeted_status ? self.retweeted_status.user.screen_name : self.user.screen_name;
}

- (NSURL *)ownerImageUrl {
    NSURL *ownerImageUrl = self.retweeted_status ?
            [NSURL URLWithString:self.retweeted_status.user.profile_image_url] :
            [NSURL URLWithString:self.user.profile_image_url];

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

