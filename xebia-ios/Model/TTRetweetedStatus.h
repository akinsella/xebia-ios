//
// Created by akinsella on 04/10/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "TTUser.h"
#import <RestKit/RestKit.h>
#import "TTEntities.h"

@interface TTRetweetedStatus : NSObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *identifier_str;
@property (nonatomic, strong) NSDate *created_at;
@property (nonatomic, strong) TTUser *user;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong, readonly) NSString *dateFormatted;
@property (nonatomic, strong) TTEntities *entities;
@property (nonatomic, assign) bool favorited;
@property (nonatomic, assign) bool retweeted;
@property (nonatomic, strong) NSNumber *retweet_count;

+ (RKObjectMapping *)mapping;

@end