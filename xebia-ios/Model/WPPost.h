//
//  WPPost.h
//  xebia-blog-ios
//
//  Created by Alexis Kinsella on 21/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "WPAuthor.h"

@interface  WPPost : NSObject

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

-(NSString *)excerptTrim;
-(NSString *)description_;
-(NSString *)dateFormatted;
-(NSString *)authorFormatted;
-(NSString *)tagsFormatted;
-(NSString *)categoriesFormatted;
-(NSURL *)imageUrl;

@property(nonatomic, retain) WPAuthor *author;
@property(nonatomic, retain) NSSet *categories;
@property(nonatomic, retain) NSSet *tags;
@property(nonatomic, retain) NSSet *comments;

typedef enum {
    RECENT = 1,
    TAG = 2,
    CATEGORY = 3,
    AUTHOR = 4
} POST_TYPE;

@end
