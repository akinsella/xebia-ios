//
//  Category.m
//  StoryboardUITableViewTutorial
//
//  Created by Alexis Kinsella on 14/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Category.h"

@implementation Category
@synthesize id, slug, title, description, postCount;

+(id)categoryWithId:(int)id
               slug:(NSString *)slug
              title:(NSString *)title
        description:(NSString *)description
          postCount:(int)postCount
{
Category *category = [[self alloc] init];
category.id = id;
category.slug = slug;
category.title = title;
category.description = description;
category.postCount = postCount;

return category;
}

@end
