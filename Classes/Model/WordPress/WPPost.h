//
//  WPPost.h
//  xebia-blog-ios
//
//  Created by Alexis Kinsella on 21/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "WPAuthor.h"

@interface WPPost : NSObject<XBMappingProvider>

@property(nonatomic, strong) NSNumber *identifier;
@property(nonatomic, strong) NSString *type;
@property(nonatomic, strong) NSString *slug;
@property(nonatomic, strong) NSString *url;
@property(nonatomic, strong) NSString *status;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *titlePlain;
@property(nonatomic, strong) NSString *content;
@property(nonatomic, strong) NSString *excerpt;
@property(nonatomic, strong) NSDate *date;
@property(nonatomic, strong) NSDate *modified;
@property(nonatomic, strong) NSNumber *commentCount;
@property(nonatomic, strong) NSString *commentStatus;

-(NSString *)description_;
-(NSString *)authorFormatted;
-(NSString *)tagsFormatted;
-(NSString *)categoriesFormatted;
-(NSURL *)imageUrl;

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

@end
