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
#import "TTEntities.h"

@interface TTTweet : NSObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *identifier_str;
@property (nonatomic, strong) NSDate *created_at;
@property (nonatomic, strong) TTUser *user;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong, readonly) NSString *dateFormatted;
@property (nonatomic, strong, readonly) NSString *ownerScreenName;
@property (nonatomic, strong, readonly) NSURL *ownerImageUrl;
@property (nonatomic, strong) TTEntities *entities;
@property (nonatomic, strong) TTRetweetedStatus *retweeted_status;
@property (nonatomic, assign) bool favorited;
@property (nonatomic, assign) bool retweeted;
@property (nonatomic, strong) NSNumber *retweet_count;

@property (nonatomic, strong) NSString *contentAsHtml;

+ (RKObjectMapping *)mapping;

@end

