//
//  TTTweet.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "TTTweet.h"
#import "XBDate.h"
#import "DCParserConfiguration.h"
#import "DCKeyValueObjectMapping.h"
#import "DCParserConfiguration+XBAdditions.h"
#import "NSDate+XBAdditions.h"

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

    [config mergeConfig:[TTUser mappings]];
    [config mergeConfig:[TTEntities mappings]];
    [config mergeConfig:[TTRetweetedStatus mappings]];

    return config;
}

@end

