//
//  AppDelegate.h
//  Xebia Application
//
//  Created by Alexis Kinsella on 10/06/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WPDataAccessor.h"

#import "WPPost.h"
#import "MBProgressHUD.h"
#import "RestKit.h"

@class XBViewControllerManager;
@class XBMainViewController;


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong, nonatomic) RKObjectManager *objectManager;
@property (readonly, strong, nonatomic) RKManagedObjectStore *objectStore;

@property(strong, nonatomic) NSMutableArray *posts;
@property(nonatomic, retain) XBViewControllerManager *viewControllerManager;
@property(nonatomic, retain) XBMainViewController *mainViewController;


@end
