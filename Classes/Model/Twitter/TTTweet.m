//
//  TTTweet.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <DCKeyValueObjectMapping/DCObjectMapping.h>
#import "TTTweet.h"
#import "DCParserConfiguration+XBAdditions.h"

@implementation TTTweet

- (NSString *)ownerScreenName {
    return self.retweeted_status ? self.retweeted_status.user.screen_name : self.user.screen_name;
}

- (NSURL *)ownerImageUrl {
    NSURL *ownerImageUrl = self.retweeted_status ?
            [NSURL URLWithString:self.retweeted_status.user.profile_image_url] :
            [NSURL URLWithString:self.user.profile_image_url];

    return ownerImageUrl;
}

+ (DCParserConfiguration *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    config.datePattern = @"yyyy-MM-dd HH:mm:ss";

    [config addObjectMapping: [DCObjectMapping mapKeyPath:@"id" toAttribute:@"identifier" onClass:[self class]]];
    [config addObjectMapping: [DCObjectMapping mapKeyPath:@"id_str" toAttribute:@"identifier_str" onClass:[self class]]];

    [config mergeConfig:[TTUser mappings]];
    [config mergeConfig:[TTEntities mappings]];
    [config mergeConfig:[TTRetweetedStatus mappings]];

    return config;
}

@end

