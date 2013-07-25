//
//  TTTweet.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "TTUser.h"
#import "TTRetweetedStatus.h"
#import "TTEntities.h"

@interface TTTweet : NSObject<XBMappingProvider>

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSString *identifier_str;
@property (nonatomic, strong) NSDate *created_at;
@property (nonatomic, strong) TTUser *user;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) TTRetweetedStatus *retweeted_status;
@property (nonatomic, strong) TTEntities *entities;
@property (nonatomic, assign) bool favorited;
@property (nonatomic, assign) bool retweeted;
@property (nonatomic, strong) NSNumber *retweet_count;

- (NSString *)ownerScreenName;

- (NSURL *)ownerImageUrl;

@end

