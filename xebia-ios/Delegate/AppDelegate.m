//
//  AppDelegate.m
//  Xebia Application
//
//  Created by Alexis Kinsella on 10/06/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "AppDelegate.h"
#import "RKXBMappingProvider.h"
#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>
#import "WPDataAccessor.h"
#import "ZUUIRevealController.h"
#import "RKXBMenuTableViewController.h"
#import "RKWPAuthorTableViewController.h"
#import "RevealController.h"
#import "UIColor+RKWPAdditions.h"
#import "UINavigationBar+RKWPAdditions.h"
#import "HomeController.h"

@interface AppDelegate ()
@property (nonatomic, strong, readwrite) RKObjectManager *objectManager;
@property (nonatomic, strong, readwrite) RKManagedObjectStore *objectStore;
@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize wpDataAccessor = _wpDataAccessor;

@synthesize objectManager;
@synthesize objectStore;

@synthesize posts = _posts;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initializeRestKit];
    
    RKLogConfigureByName("RestKit/UI", RKLogLevelInfo);
    RKLogConfigureByName("RestKit/Network", RKLogLevelInfo);

    self.wpDataAccessor = [WPDataAccessor initWithBaseApiUrl:@"http://192.168.1.10:9000/"];

    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window = window;

    RKXBMenuTableViewController *menuTableViewController = [[RKXBMenuTableViewController alloc] init];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    HomeController *homeController = [storyboard instantiateViewControllerWithIdentifier:@"home"];
    
    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:homeController];
    frontNavigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    frontNavigationController.navigationBar.tintColor = (UIColor *)[UIColor colorWithHex: @"#561D3F" alpha:1.0];
    frontNavigationController.delegate = self;
    [frontNavigationController.navigationBar setBackgroundImage: [UIImage imageNamed:@"navigationBarBackgroundRetro"]];

    
    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:menuTableViewController];
    rearNavigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    rearNavigationController.navigationBar.tintColor = (UIColor *)[UIColor colorWithHex: @"#561D3F" alpha:1.0];
    rearNavigationController.delegate = self;
    [rearNavigationController.navigationBar setBackgroundImage: [UIImage imageNamed:@"navigationBarBackgroundRetro"]];

	RevealController *revealController = [[RevealController alloc] initWithFrontViewController:frontNavigationController rearViewController:rearNavigationController];
    [revealController setFrontViewController:frontNavigationController animated:NO];
	
	self.window.rootViewController = revealController;
    [self.window makeKeyAndVisible];
    
    
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        [revealController hideFrontView];    
//    }
    
    return YES;
}

- (void)navigationController:(UINavigationController *)navController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController respondsToSelector:@selector(willAppearIn:)]) {
        [viewController performSelector:@selector(willAppearIn:) withObject:navController];
    }
}

- (void)initializeRestKit {
    self.objectManager = [RKObjectManager managerWithBaseURLString:@"http://192.168.1.10:9000"];
    self.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:@"RKWordpress.sqlite"];
    self.objectManager.objectStore = self.objectStore;
    self.objectManager.mappingProvider = [RKXBMappingProvider mappingProviderWithObjectStore:self.objectStore];
}

- (void)updatePostsWithPostType:(POST_TYPE)postType Id:(int)identifier Count:(int)count {
    self.posts = [self.wpDataAccessor fetchPostsWithPostType:postType Id:identifier Count:count];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Saves changes in the application's managed object context before the application terminates.
    NSError *error = nil;
    if (! [self.objectStore save:&error]) {
        RKLogError(@"Failed to save RestKit managed object store: %@", error);
    }
}

@end
