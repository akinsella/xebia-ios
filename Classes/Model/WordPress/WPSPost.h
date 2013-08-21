//
//  WPPost.h
//  xebia-blog-ios
//
//  Created by Alexis Kinsella on 21/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "WPSAuthor.h"
#import "XBMappingProvider.h"

@interface  WPSPost : NSObject<XBMappingProvider>

@property(nonatomic, strong) NSNumber *identifier;
@property(nonatomic, strong) NSString *slug;
@property(nonatomic, strong) NSString *url;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSDate *date;
@property(nonatomic, strong) NSDate *modified;
@property(nonatomic, strong) NSNumber *commentCount;

-(NSString *)description_;
-(NSString *)authorFormatted;
-(NSString *)tagsFormatted;
-(NSString *)categoriesFormatted;
-(NSURL *)imageUrl;

@property(nonatomic, retain) NSArray *authors;
@property(nonatomic, retain) NSArray *categories;
@property(nonatomic, retain) NSArray *tags;

@end
