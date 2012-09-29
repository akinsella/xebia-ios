//
//  TTTweet.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "TTTweet.h"
#import "Date.h"

@implementation TTTweet

@synthesize identifier;
@synthesize created_at;
@synthesize user;
@synthesize text;

- (NSString *)dateFormatted {
    return [Date formattedDateRelativeToNow: self.created_at];
}

+ (RKObjectMapping *)mapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class] usingBlock:^(RKObjectMapping *mapping) {
        [mapping mapAttributes: @"text", @"created_at", nil];
        [mapping mapKeyPathsToAttributes:
                @"id", @"identifier",
                nil];

        // Relationships
        [mapping mapKeyPath:@"user" toRelationship:@"user" withMapping:[TTUser mapping]];
    }];

    return mapping;
}


@end

