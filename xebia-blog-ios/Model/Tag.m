//
//  Tag.m
//  Xebia Application
//
//  Created by Alexis Kinsella on 14/06/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "Tag.h"

@implementation Tag

@synthesize identifier, slug, title, description, postCount;

+(id)tagWithId:(int)identifier
          slug:(NSString *)slug
         title:(NSString *)title
   description:(NSString *)description
     postCount:(int)postCount
{
    Tag *tag = [[self alloc] init];
    tag.identifier = identifier;
    tag.slug = slug;
    tag.title = title;
    tag.description = description;
    tag.postCount = postCount;

    return tag;
}

@end
