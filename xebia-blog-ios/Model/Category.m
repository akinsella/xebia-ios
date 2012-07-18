//
//  Category.m
//  Xebia Application
//
//  Created by Alexis Kinsella on 14/06/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "Category.h"

@implementation Category
@synthesize identifier, slug, title, description, postCount;

+(id)categoryWithId:(int)identifier
               slug:(NSString *)slug
              title:(NSString *)title
        description:(NSString *)description
          postCount:(int)postCount
{
Category *category = [[self alloc] init];
category.identifier = identifier;
category.slug = slug;
category.title = title;
category.description = description;
category.postCount = postCount;

return category;
}

@end
