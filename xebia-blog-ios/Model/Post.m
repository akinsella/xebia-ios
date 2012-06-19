//
//  Post.m
//  StoryboardUITableViewTutorial
//
//  Created by Alexis Kinsella on 14/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Post.h"

@implementation Post

@synthesize id, title, description;

+(id)postWithId:(int)id
          title:(NSString *)title
    description:(NSString *)description
{
    Post *post = [[self alloc] init];

    post.id = id;
    post.title = title;
    post.description = description;

    return post;
}

@end
