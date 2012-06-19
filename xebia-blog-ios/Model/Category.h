//
//  Category.h
//  StoryboardUITableViewTutorial
//
//  Created by Alexis Kinsella on 14/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Category : NSObject

@property (nonatomic,assign) int id;

@property (nonatomic,copy) NSString *slug;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *description;

@property (nonatomic,assign) int postCount;

+ (id)categoryWithId:(int)id
                slug:(NSString *)slug
               title:(NSString *)title
         description:(NSString *)description
           postCount:(int)postCount;

@end
