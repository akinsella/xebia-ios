//
//  AppDelegate.h
//  Xebia Application
//
//  Created by Alexis Kinsella on 10/06/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
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
#import "MBProgressHUD.h"
#import <RestKit/RestKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(strong, nonatomic) WPDataAccessor *wpDataAccessor;

@property (readonly, strong, nonatomic) RKObjectManager *objectManager;
@property (readonly, strong, nonatomic) RKManagedObjectStore *objectStore;

@property(strong, nonatomic) NSMutableArray *tags;
@property(strong, nonatomic) NSMutableArray *categories;
@property(strong, nonatomic) NSMutableArray *authors;
@property(strong, nonatomic) NSMutableArray *posts;

- (void)updateAuthors;

- (void)updateCategories;

- (void)updateTags;

- (void)updatePostsWithPostType:(POST_TYPE)postType Id:(int)identifier Count:(int)count;

@end
