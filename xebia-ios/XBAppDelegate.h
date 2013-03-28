//
//  AppDelegate.h
//  Xebia Application
//
//  Created by Alexis Kinsella on 10/06/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBConfigurationProvider.h"
#import "XBViewControllerManager.h"
#import "XBMainViewController.h"

@interface XBAppDelegate : UIResponder <UIApplicationDelegate>

@property(nonatomic, strong, readonly) XBViewControllerManager *viewControllerManager;
@property(nonatomic, strong, readonly) XBMainViewController *mainViewController;
@property(nonatomic, strong, readonly) NSString *deviceToken;
@property(nonatomic, strong, readonly) XBConfigurationProvider *configurationProvider;
@property(nonatomic, assign, readonly) Boolean registered;

@end
