//
//  AppDelegate.m
//  StoryboardUITableViewTutorial
//
//  Created by Alexis Kinsella on 10/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "TagTableViewController.h"
#import "CategoryTableViewController.h"
#import "AuthorTableViewController.h"
#import "WPDataAccessor.h"
#import "Tag.h"
#import "Category.h"
#import "Author.h"

@implementation AppDelegate {
    WPDataAccessor *wpDataAccessor;
}

@synthesize window = _window;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    wpDataAccessor = [WPDataAccessor initWithBaseApiUrl:@"http://blog.xebia.fr/wp-json-api"];
    
    NSMutableArray *categories = wpDataAccessor.fetchCategories;
    NSMutableArray *tags = wpDataAccessor.fetchTags;
    NSMutableArray *authors = wpDataAccessor.fetchAuthors;

    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;

    NSLog(@"tabBarController size: %i", [tabBarController viewControllers].count);

    UINavigationController *tagNavigationController = [[tabBarController viewControllers] objectAtIndex:0];
    NSLog(@"tagNavigationController size: %i", [[tagNavigationController viewControllers] count]);
    TagTableViewController *tagTableViewController = [[tagNavigationController viewControllers] objectAtIndex:0];
    tagTableViewController.tags = tags;
    [tags sortUsingComparator:^(id first, id second) {
        return [((Tag *)first).title compare:((Tag *)second).title options:NSNumericSearch];
    }];

    UINavigationController *categoryNavigationController = [[tabBarController viewControllers] objectAtIndex:1];
    NSLog(@"categoryNavigationController size: %i", [[categoryNavigationController viewControllers] count]);
    CategoryTableViewController *categoryTableViewController = [[categoryNavigationController viewControllers] objectAtIndex:0];
    categoryTableViewController.categories = categories;
    [categories sortUsingComparator:^(id first, id second) {
        return [((Category *)first).title compare:((Category *)second).title options:NSNumericSearch];
    }];

    UINavigationController *authorNavigationController = [[tabBarController viewControllers] objectAtIndex:2];
    NSLog(@"authorNavigationController size: %i", [[authorNavigationController viewControllers] count]);
    AuthorTableViewController *authorTableViewController = [[authorNavigationController viewControllers] objectAtIndex:0];
    authorTableViewController.authors = authors;
    [authors sortUsingComparator:^(id first, id second) {
        return [((Author *)first).name compare:((Author *)second).name options:NSNumericSearch];
    }];


    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
