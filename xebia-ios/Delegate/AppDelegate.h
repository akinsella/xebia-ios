//
//  AppDelegate.h
//  Xebia Application
//
//  Created by Alexis Kinsella on 10/06/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WPDataAccessor.h"

#import "Post.h"
#import "MBProgressHUD.h"
#import "RestKit.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, RKManagedObjectStoreDelegate>

@property(strong, nonatomic) WPDataAccessor *wpDataAccessor;

@property (readonly, strong, nonatomic) RKObjectManager *objectManager;
@property (readonly, strong, nonatomic) RKManagedObjectStore *objectStore;

@property(strong, nonatomic) NSMutableArray *posts;

- (void)updatePostsWithPostType:(POST_TYPE)postType Id:(int)identifier Count:(int)count;

@end
