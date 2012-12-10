//
//  WPPost.h
//  xebia-blog-ios
//
//  Created by Alexis Kinsella on 21/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "WPAuthor.h"
#import <RestKit/RestKit.h>

@interface WPPost : NSObject

@property(nonatomic, strong) NSNumber *identifier;
@property(nonatomic, strong) NSString *type;
@property(nonatomic, strong) NSString *slug;
@property(nonatomic, strong) NSString *url;
@property(nonatomic, strong) NSString *status;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *title_plain;
@property(nonatomic, strong) NSString *content;
@property(nonatomic, strong) NSString *excerpt;
@property(nonatomic, strong) NSDate *date;
@property(nonatomic, strong) NSDate *modified;
@property(nonatomic, strong) NSNumber *comment_count;
@property(nonatomic, strong) NSString *comment_status;

@property (nonatomic, strong, readonly) NSString *excerptTrim;
@property (nonatomic, strong, readonly) NSString *dateFormatted;
@property (nonatomic, strong, readonly) NSString *authorFormatted;
@property (nonatomic, strong, readonly) NSString *tagsFormatted;
@property (nonatomic, strong, readonly) NSString *categoriesFormatted;
@property (nonatomic, strong, readonly) NSURL *imageUrl;

@property(nonatomic, retain) WPAuthor *author;
@property(nonatomic, retain) NSArray *categories;
@property(nonatomic, retain) NSArray *tags;
@property(nonatomic, retain) NSArray *comments;

typedef enum {
    RECENT = 1,
    TAG = 2,
    CATEGORY = 3,
    AUTHOR = 4
} POST_TYPE;

+ (RKObjectMapping *)mapping;
+ (RKObjectMapping *)mappingForOne;

@end
