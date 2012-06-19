//
//  Tag.m
//  StoryboardUITableViewTutorial
//
//  Created by Alexis Kinsella on 14/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Tag.h"

@implementation Tag

@synthesize id, slug, title, description, postCount;

+(id)tagWithId:(int)id
          slug:(NSString *)slug
         title:(NSString *)title
   description:(NSString *)description
     postCount:(int)postCount
{
    Tag *tag = [[self alloc] init];
    tag.id = id;
    tag.slug = slug;
    tag.title = title;
    tag.description = description;
    tag.postCount = postCount;

    return tag;
}

@end
