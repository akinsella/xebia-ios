//
//  TTTweet.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "TTTweet.h"
#import "Date.h"
#import "DCParserConfiguration.h"
#import "DCKeyValueObjectMapping.h"

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

+ (DCParserConfiguration *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    return config;
}

@end

