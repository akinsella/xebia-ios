//
//  Author.m
//  StoryboardUITableViewTutorial
//
//  Created by Alexis Kinsella on 14/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Author.h"

@implementation Author
@synthesize id, slug, name, firstname, lastname, nickname, url, description;

+(id)authorWithId:(int)id
             slug:(NSString *)slug
             name:(NSString *)name
        firstname:(NSString *)firstname
         lastname:(NSString *)lastname
         nickname:(NSString *)nickname
              url:(NSString *)url
      description:(NSString *)description {

    Author *author = [[self alloc] init];
    author.id = id;
    author.slug = slug;
    author.name = name;
    author.firstname = firstname;
    author.lastname = lastname;
    author.nickname = nickname;
    author.url = url;
    author.description = description;

    return author;
}

@end
