//
//  AppDelegate.m
//  Xebia Application
//
//  Created by Alexis Kinsella on 10/06/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "AppDelegate.h"
#import "XBMappingProvider.h"
#import "ZUUIRevealController.h"
#import "XBMainViewController.h"
#import "NSDateFormatter+XBAdditions.h"
#import "XBViewControllerManager.h"

@interface AppDelegate ()
@property (nonatomic, strong, readwrite) RKObjectManager *objectManager;
@property (nonatomic, strong, readwrite) RKManagedObjectStore *objectStore;
@end

@implementation AppDelegate {
    XBViewControllerManager *_viewControllerManager;
    XBMainViewController *_mainViewController;
}

@synthesize window = _window;

@synthesize objectManager;
@synthesize objectStore;

@synthesize posts = _posts;
@synthesize viewControllerManager = _viewControllerManager;
@synthesize mainViewController = _mainViewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initializeLoggers];
    [self initializeRestKit];

    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window = window;

    _viewControllerManager = [XBViewControllerManager sharedInstance];
    _mainViewController = [[XBMainViewController alloc] initWithViewControllerManager:_viewControllerManager];
    
	self.window.rootViewController = [_mainViewController revealController];
    [self.window makeKeyAndVisible];

    [_mainViewController release];
    [window release];
    [_viewControllerManager release];
    return YES;
}

- (void)initializeLoggers {
    RKLogConfigureByName("RestKit/*", RKLogLevelInfo);
//    RKLogConfigureByName("RestKit/UI", RKLogLevelError);
//    RKLogConfigureByName("RestKit/Network", RKLogLevelError);
//    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelError);
//    RKLogConfigureByName("RestKit/ObjectMapping/JSON", RKLogLevelError);

//    RKLogConfigureByName("RestKit/UI", RKLogLevelTrace);
//    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
//    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
//    RKLogConfigureByName("RestKit/ObjectMapping/JSON", RKLogLevelTrace);
}

- (void)initializeRestKit {
    
    // Twitter date format: Wed Aug 29 21:32:43 +0000 2012
    [RKObjectMapping addDefaultDateFormatter: [NSDateFormatter initWithDateFormat: @"eee MMM dd HH:mm:ss ZZZZ yyyy"]];

    // Github date format: 2012-07-05T09:43:24Z
    // Already available in Restkit default formatters
    [RKObjectMapping addDefaultDateFormatter: [NSDateFormatter initWithDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"]];
    
    self.objectManager = [RKObjectManager managerWithBaseURLString:@"http://127.0.0.1:9000/v1.0/"];
//    self.objectManager = [RKObjectManager managerWithBaseURLString:@"http://xebia-mobile.cloudfoundry.com/v1.0/"];
    self.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:@"xebia.sqlite"];
    self.objectManager.objectStore = self.objectStore;
    self.objectManager.objectStore.cacheStrategy = [[RKFetchRequestManagedObjectCache new] autorelease];
    self.objectManager.mappingProvider = [XBMappingProvider mappingProviderWithObjectStore:self.objectStore];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Saves changes in the application's managed object context before the application terminates.
    NSError *error = nil;
    if (! [self.objectStore save:&error]) {
        RKLogError(@"Failed to save RestKit managed object store: %@", error);
    }
}

- (void)dealloc {
    [_viewControllerManager release];
    [_mainViewController release];
    [super dealloc];
}

@end
