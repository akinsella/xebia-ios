//
//  TTTweet.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTUser.h"
#import <RestKit/RestKit.h>
#import "TTRetweetedStatus.h"

@interface TTTweet : NSManagedObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *identifier_str;
@property (nonatomic, strong) NSDate *created_at;
@property (nonatomic, strong) TTUser *user;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) TTRetweetedStatus *retweeted_status;
@property(nonatomic, strong) NSArray *hashtags;
@property(nonatomic, strong) NSArray *urls;
@property(nonatomic, strong) NSArray *user_mentions;
@property (nonatomic, assign) bool favorited;
@property (nonatomic, assign) bool retweeted;
@property (nonatomic, strong) NSNumber *retweet_count;

- (NSString *)dateFormatted;

- (NSString *)ownerScreenName;

- (NSURL *)ownerImageUrl;

@end

