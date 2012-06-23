//
//  AppDelegate.h
//  StoryboardUITableViewTutorial
//
//  Created by Alexis Kinsella on 10/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WPDataAccessor.h"

#import "AuthorTableViewController.h"
#import "TagTableViewController.h"
#import "CategoryTableViewController.h"

#import "Tag.h"
#import "Category.h"
#import "Author.h"
#import "Post.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) WPDataAccessor *wpDataAccessor;

@property (strong, nonatomic) UITabBarController *tabBarController;

@property (strong, nonatomic) UINavigationController *tagNavigationController;
@property (strong, nonatomic) UINavigationController *authorNavigationController;
@property (strong, nonatomic) UINavigationController *categoryNavigationController;

@property (strong, nonatomic) AuthorTableViewController *authorTableViewController;
@property (strong, nonatomic) TagTableViewController *tagTableViewController;
@property (strong, nonatomic) CategoryTableViewController *categoryTableViewController;

@property (strong, nonatomic) NSMutableArray *tags;
@property (strong, nonatomic) NSMutableArray *categories;
@property (strong, nonatomic) NSMutableArray *authors;
@property (strong, nonatomic) NSMutableArray *posts;

- (void) updatePostsWithPostType:(POST_TYPE)postType andId:(int)identifier;

@end
