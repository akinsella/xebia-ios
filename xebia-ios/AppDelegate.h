//
//  AppDelegate.h
//  Xebia Application
//
//  Created by Alexis Kinsella on 10/06/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "WPPost.h"
#import "MBProgressHUD.h"
#import "RestKit.h"

@class XBViewControllerManager;
@class XBMainViewController;


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(nonatomic, retain) XBViewControllerManager *viewControllerManager;
@property(nonatomic, retain) XBMainViewController *mainViewController;
@property(nonatomic, assign) Boolean registered;
@property(nonatomic, retain) NSString *deviceToken;

+ (NSString *)baseUrl;


@end
