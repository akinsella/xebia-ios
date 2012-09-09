//
//  AppDelegate.m
//  Xebia Application
//
//  Created by Alexis Kinsella on 10/06/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "AppDelegate.h"
#import "XBMappingProvider.h"
#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>
#import "WPDataAccessor.h"
#import "ZUUIRevealController.h"
#import "XBMenuTableViewController.h"
#import "WPAuthorTableViewController.h"
#import "XBRevealController.h"
#import "UIColor+XBAdditions.h"
#import "UINavigationBar+XBAdditions.h"
#import "XBHomeController.h"
#import "UIViewController+XBAdditions.h"
#import "UINavigationController+XBAdditions.h"

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
    [self initializeLoggers];
    [self initializeRestKit];

//    self.wpDataAccessor = [WPDataAccessor initWithBaseApiUrl:@"http://127.0.0.1:9000/v1.0/"];
    self.wpDataAccessor = [WPDataAccessor initWithBaseApiUrl:@"http://xebia-mobile.cloudfoundry.com/v1.0/"];

    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window = window;

    XBMenuTableViewController *mc = [[XBMenuTableViewController alloc] init];
    
	self.window.rootViewController = [mc revealController];
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)initializeLoggers {
    RKLogConfigureByName("RestKit/UI", RKLogLevelError);
    RKLogConfigureByName("RestKit/Network", RKLogLevelError);
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelError);
    RKLogConfigureByName("RestKit/ObjectMapping/JSON", RKLogLevelError);
    
    //    RKLogConfigureByName("RestKit/UI", RKLogLevelTrace);
    //    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    //    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
    //    RKLogConfigureByName("RestKit/ObjectMapping/JSON", RKLogLevelTrace);
}

- (void)initializeRestKit {
    
    // Twitter date format
    // Wed Aug 29 21:32:43 +0000 2012
    NSDateFormatter *twitterDateFormatter = [[NSDateFormatter alloc] init];
    [twitterDateFormatter setDateFormat: @"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    [RKObjectMapping addDefaultDateFormatter:(NSFormatter *)twitterDateFormatter];

    // Github date format
    // 2012-07-05T09:43:24Z
    // Available in Restkit default formatters
    NSDateFormatter *githubDateFormatter = [[NSDateFormatter alloc] init];
    [githubDateFormatter setDateFormat: @"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    [RKObjectMapping addDefaultDateFormatter:(NSFormatter *)githubDateFormatter];
    
    self.objectManager = [RKObjectManager managerWithBaseURLString:@"http://127.0.0.1:9000/v1.0/"];
//    self.objectManager = [RKObjectManager managerWithBaseURLString:@"http://xebia-mobile.cloudfoundry.com/v1.0/"];
    self.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:@"xebia.sqlite"];
    self.objectManager.objectStore = self.objectStore;
    self.objectManager.mappingProvider = [XBMappingProvider mappingProviderWithObjectStore:self.objectStore];
}

- (void)updatePostsWithPostType:(POST_TYPE)postType Id:(int)identifier Count:(int)count {
    self.posts = [self.wpDataAccessor fetchPostsWithPostType:postType Id:identifier Count:count];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Saves changes in the application's managed object context before the application terminates.
    NSError *error = nil;
    if (! [self.objectStore save:&error]) {
        RKLogError(@"Failed to save RestKit managed object store: %@", error);
    }
}

@end
