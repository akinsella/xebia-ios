//
//  AppDelegate.m
//  Xebia Application
//
//  Created by Alexis Kinsella on 10/06/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "AppDelegate.h"
#import "XBRestkitSupport.h"
#import "ZUUIRevealController.h"
#import "XBMainViewController.h"

@implementation AppDelegate {
    XBViewControllerManager *_viewControllerManager;
    XBMainViewController *_mainViewController;
}

@synthesize window = _window;

@synthesize viewControllerManager = _viewControllerManager;
@synthesize mainViewController = _mainViewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [XBRestkitSupport configure];

    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    _viewControllerManager = [XBViewControllerManager sharedInstance];
    _mainViewController = [[XBMainViewController alloc] initWithViewControllerManager:_viewControllerManager];
    
	self.window.rootViewController = [_mainViewController revealController];
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    NSLog(@"Application received a memory warning !");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"Application will terminate !!");
}

- (void)dealloc {
    [_viewControllerManager release];
    [_mainViewController release];
    [_window release];
    [super dealloc];
}

@end
