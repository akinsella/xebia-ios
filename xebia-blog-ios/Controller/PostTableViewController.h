//
//  PostTableViewController.h
//  StoryboardUITableViewTutorial
//
//  Created by Alexis Kinsella on 14/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@interface PostTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *posts;

@property (nonatomic, assign) POST_TYPE postType;

@property (nonatomic, assign) int identifier;

@end
