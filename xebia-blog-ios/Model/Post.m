//
//  Post.m
//  Xebia Application
//
//  Created by Alexis Kinsella on 14/06/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "Post.h"

@implementation Post

@synthesize identifier, title, excerpt, date, modified, slug, type;

+(id)postWithId:(int)identifier
          title:(NSString *)title
        excerpt:(NSString *)excerpt
           date:(NSString *)date
       modified:(NSString *)modified
           slug:(NSString *)slug
           type:(NSString *)type
{
    Post *post = [[self alloc] init];

    post.identifier = identifier;
    post.title = title;
    post.excerpt = excerpt;
    post.date = date;
    post.modified = modified;
    post.slug = slug;
    post.type = type;

    return post;
}

@end
