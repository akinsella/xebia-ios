//
//  Post.h
//  StoryboardUITableViewTutorial
//
//  Created by Alexis Kinsella on 14/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject

@property (nonatomic,assign) int id;

@property (nonatomic,copy) IBOutlet NSString *title;
@property (nonatomic,copy) IBOutlet NSString *description;

+ (id)postWithId:(int)id
           title:(NSString *)title
     description:(NSString *)description;

@end
