//
//  RTTTUser.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RKGHUser : NSManagedObject

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSString *login;
@property (nonatomic, strong) NSString *gravatar_id;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *avatar_url;
@property (nonatomic, strong) NSDate *create_at;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *bio;
@property (nonatomic, strong) NSNumber *public_gists;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *html_url;
@property (nonatomic, strong) NSNumber *followers;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *company;
@property (nonatomic, assign) bool hireable;
@property (nonatomic, strong) NSNumber *following;
@property (nonatomic, strong) NSString *blog;
@property (nonatomic, strong) NSString *location;

@property (nonatomic, strong, readonly) NSString *description_;

@end

