//
//  WPPost.h
//  xebia-blog-ios
//
//  Created by Alexis Kinsella on 21/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface WPPost : NSManagedObject

@property(nonatomic, strong) NSNumber *identifier;
@property(nonatomic, strong) NSString *type;
@property(nonatomic, strong) NSString *slug;
@property(nonatomic, strong) NSString *url;
@property(nonatomic, strong) NSString *status;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *title_plain;
@property(nonatomic, strong) NSString *content;
@property(nonatomic, strong) NSString *excerpt;
@property(nonatomic, strong) NSString *date;
@property(nonatomic, strong) NSString *modified;
@property(nonatomic, strong) NSNumber *comment_count;
@property(nonatomic, strong) NSString *comment_status;

@end
