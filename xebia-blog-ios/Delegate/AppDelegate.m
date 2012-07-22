//
//  AppDelegate.m
//  Xebia Application
//
//  Created by Alexis Kinsella on 10/06/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "AppDelegate.h"
#import "RKWPMappingProvider.h"
#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>

@interface AppDelegate ()
@property (nonatomic, strong, readwrite) RKObjectManager *objectManager;
@property (nonatomic, strong, readwrite) RKManagedObjectStore *objectStore;
@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize wpDataAccessor = _wpDataAccessor;

@synthesize objectManager;
@synthesize objectStore;

@synthesize tags = _tags;
@synthesize authors = _authors;
@synthesize categories = _categories;
@synthesize posts = _posts;

- (void)initializeRestKit
{
    self.objectManager = [RKObjectManager managerWithBaseURLString:@"http://blog.xebia.fr/wp-json-api"];
    self.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:@"RKWordpress.sqlite"];
    self.objectManager.objectStore = self.objectStore;
    self.objectManager.mappingProvider = [RKWPMappingProvider mappingProviderWithObjectStore:self.objectStore];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initializeRestKit];
    self.wpDataAccessor = [WPDataAccessor initWithBaseApiUrl:@"http://blog.xebia.fr/wp-json-api"];

    RKClient *client = [RKClient clientWithBaseURLString:@"http://restkit.org"];
    RKLogConfigureByName("RestKit/Network", RKLogLevelDebug);
    RKLogInfo(@"Configured RestKit client: %@", client);
    
    // Override point for customization after application launch.
    return YES;
}

- (void)updatePostsWithPostType:(POST_TYPE)postType Id:(int)identifier Count:(int)count {
    self.posts = [self.wpDataAccessor fetchPostsWithPostType:postType Id:identifier Count:count];
}

- (void)updateAuthors {
    self.authors = [self.wpDataAccessor fetchAuthors];
    NSSortDescriptor *authorSort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    [self.authors sortUsingDescriptors:[NSArray arrayWithObject:authorSort]];
}

- (void)updateCategories {
    NSSortDescriptor *categorySort = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    self.categories = [self.wpDataAccessor fetchCategories];
    [self.categories sortUsingDescriptors:[NSArray arrayWithObject:categorySort]];
}

- (void)updateTags {
    self.tags = [self.wpDataAccessor fetchTags];
    NSSortDescriptor *tagSort = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    [self.tags sortUsingDescriptors:[NSArray arrayWithObject:tagSort]];

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

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    NSError *error = nil;
    if (! [self.objectStore save:&error]) {
        RKLogError(@"Failed to save RestKit managed object store: %@", error);
    }
}

@end
