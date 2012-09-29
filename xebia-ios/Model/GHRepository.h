//
//  GHRepository.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GHUser.h"

@interface GHRepository : NSObject

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSString *language;
@property (nonatomic, strong) NSDate *pushed_at;
@property (nonatomic, strong) NSDate *created_at;
@property (nonatomic, strong) NSNumber *forks;
@property (nonatomic, strong) NSString *mirror_url;
@property (nonatomic, assign) bool has_wiki;
@property (nonatomic, strong) NSString *description_;
@property (nonatomic, strong) NSString *clone_url;
@property (nonatomic, strong) GHUser *owner;
@property (nonatomic, strong) NSNumber *watchers;
@property (nonatomic, strong) NSString *ssh_url;
@property (nonatomic, strong) NSDate *updated_at;
@property (nonatomic, strong) NSNumber *open_issues;
@property (nonatomic, strong) NSString *git_url;
@property (nonatomic, assign) bool has_issues;
@property (nonatomic, strong) NSString *html_url;
@property (nonatomic, strong) NSNumber *watchers_count;
@property (nonatomic, strong) NSNumber *size;
@property (nonatomic, assign) bool fork;
@property (nonatomic, strong) NSString *full_name;
@property (nonatomic, strong) NSNumber *forks_count;
@property (nonatomic, assign) bool has_downloads;
@property (nonatomic, strong) NSString *svn_url;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSNumber *open_issues_count;
@property (nonatomic, strong) NSString *homepage;
@property (nonatomic, assign) bool private_;

+ (RKObjectMapping *)mapping;

@end

