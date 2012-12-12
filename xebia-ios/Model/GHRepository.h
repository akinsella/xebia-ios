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
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *full_name;
@property (nonatomic, strong) NSString *language;
@property (nonatomic, strong) NSString *html_url;
@property (nonatomic, strong) NSString *homepage;
@property (nonatomic, assign) bool has_issues;
@property (nonatomic, assign) bool has_wiki;
@property (nonatomic, assign) bool has_downloads;
@property (nonatomic, assign) bool fork;
@property (nonatomic, strong) NSNumber *watchers;
@property (nonatomic, strong) NSNumber *forks;
@property (nonatomic, strong) NSNumber *open_issues;
@property (nonatomic, strong) NSNumber *size;
@property (nonatomic, strong) NSDate *pushed_at;
@property (nonatomic, strong) NSDate *created_at;
@property (nonatomic, strong) NSDate *updated_at;

+ (RKObjectMapping *)mapping;

@end

