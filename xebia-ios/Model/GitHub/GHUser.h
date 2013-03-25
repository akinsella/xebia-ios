//
//  GHUser.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "XBMappingProvider.h"

@interface GHUser : NSObject<XBMappingProvider>

@property (nonatomic, strong) NSNumber *identifier;

@property (nonatomic, strong) NSString *avatar_url;
@property (nonatomic, strong) NSString *bio;
@property (nonatomic, strong) NSString *blog;
@property (nonatomic, strong) NSString *company;
@property (nonatomic, strong) NSDate *created_at;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSNumber *followers;
@property (nonatomic, strong) NSNumber *following;
@property (nonatomic, strong) NSString *gravatar_id;
@property (nonatomic, assign) bool hireable;
@property (nonatomic, strong) NSString *html_url;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *login;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *public_gists;
@property (nonatomic, strong) NSNumber *public_repos;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong, readonly) NSURL *avatarImageUrl;
@property (nonatomic, strong, readonly) NSString *description_;

/*
+ (RKObjectMapping *)mapping;
*/

@end

