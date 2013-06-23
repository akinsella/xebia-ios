//
//  AppDelegate.m
//  Xebia Application
//
//  Created by Alexis Kinsella on 10/06/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "UIColor+XBAdditions.h"
#import "XBAppDelegate.h"
#import "XBSharekitSupport.h"
#import "AFHTTPRequestOperationLogger.h"
#import "AFNetworking.h"
#import "SDURLCache.h"
#import "XBPListConfigurationProvider.h"
#import "XBMenuViewController.h"
#import "GAITracker.h"
#import "GAI.h"
#import "SecureUDID.h"
#import "XBUDID.h"
#import "XBLogging.h"
#import "XBConstants.h"
#import "DCIntrospect.h"

static NSString *const kTrackingId = @"UA-40651647-1";

static NSString* const DeviceTokenKey = @"DeviceToken";

@interface XBAppDelegate()

@property(nonatomic, strong) XBViewControllerManager *viewControllerManager;
@property(nonatomic, strong) XBMainViewController *mainViewController;
@property(nonatomic, strong) NSString *deviceToken;
@property(nonatomic, strong) XBConfigurationProvider *configurationProvider;
@property(nonatomic, assign) Boolean registered;

@end

@implementation XBAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.configurationProvider = [XBPListConfigurationProvider provider];

    [self initLogging];

    [self initAnalytics];
    [self initTestFlight];
    [self initURLCache];
    [self initAppearance];
    [self initRemoteDebugger];
    [self processRemoteNotificationIfAny:launchOptions];
    [self registerDeviceTokenKey];

    [self initShareKit];

    [self initViewControllerManager];

    [self initMainViewController];

    [self initIntrospect];

    [self registerForRemoteNotification];

    return YES;
}

-(id<GAITracker>)tracker {
    return GAI.sharedInstance.defaultTracker;
}

- (void)initIntrospect {
// always call after makeKeyAndDisplay.
#if TARGET_IPHONE_SIMULATOR
    [[DCIntrospect sharedIntrospector] start];
#endif
}

-(void)initAnalytics {

    // Initialize Google Analytics with a 120-second dispatch interval. There is a
    // tradeoff between battery usage and timely dispatch.

#if TARGET_IPHONE_SIMULATOR || defined(DEBUG)
    [GAI sharedInstance].debug = YES;
    [GAI sharedInstance].dispatchInterval = 60;
#else
    [GAI sharedInstance].debug = NO;
    [GAI sharedInstance].dispatchInterval = 120;
#endif
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    id<GAITracker> tracker = [GAI.sharedInstance trackerWithTrackingId:kTrackingId];
    [GAI.sharedInstance setDefaultTracker:tracker];
}

- (void)initMainViewController {
    NSDictionary *revealControllerOptions = @{
            PKRevealControllerAllowsOverdrawKey : @YES,
            PKRevealControllerDisablesFrontViewInteractionKey : @YES,
            PKRevealControllerRecognizesPanningOnFrontViewKey : @NO
    };

    self.mainViewController = [XBMainViewController controllerWithCentralViewControllerIdentifier:@"centralNavigationController"
                                                                     leftViewControllerIdentifier:@"leftNavigationController"
                                                                            viewControllerManager:self.viewControllerManager
                                                                          revealControllerOptions:revealControllerOptions];

    self.window.rootViewController = self.mainViewController;
}

- (void)initViewControllerManager {
    self.viewControllerManager = [XBViewControllerManager manager];
}

- (void)registerForRemoteNotification {
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert)];
}

- (void)initShareKit {
    [XBSharekitSupport configure];
}

-(void)initAppearance {

    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar-portrait.png"] forBarMetrics:UIBarMetricsDefault];
    if (IS_IPHONE_5) {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar-landscape.png"] forBarMetrics:UIBarMetricsLandscapePhone];
    }
    else {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar-landscape-iphone5.png"] forBarMetrics:UIBarMetricsLandscapePhone];
    }

    [[UINavigationBar appearance] setTintColor:[UIColor colorWithHex: @"#BCBFB5"]];
    [[UINavigationBar appearance] setTitleTextAttributes: @{
            UITextAttributeTextColor: [UIColor colorWithHex:@"#FFFFFF"],
            UITextAttributeTextShadowColor: [UIColor colorWithHex:@"#661C04"],
            UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)],
            UITextAttributeFont: [UIFont fontWithName:@"Lobster" size:20.0f]
    }];
    
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"TabBar.png"]];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"TabBarItemSelectedImage.png"]];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor colorWithWhite:0.5 alpha:1], UITextAttributeTextColor,
                                                       [UIColor blackColor], UITextAttributeTextShadowColor, nil]
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor colorWithWhite:0.85 alpha:1], UITextAttributeTextColor,
                                                       [UIColor blackColor], UITextAttributeTextShadowColor, nil]
                                             forState:UIControlStateSelected];
    
/*    [[UIBarButtonItem appearance] setTitleTextAttributes:@{
            UITextAttributeTextColor: [UIColor colorWithHex:@"#5E6059"],
//            UITextAttributeTextShadowColor: [UIColor colorWithHex:@"#661C04"],
            UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 0.0f)],
//            UITextAttributeFont: [UIFont fontWithName:@"Lobster" size:15.0f]
    } forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{
            UITextAttributeTextColor: [UIColor colorWithHex:@"#FFFFFF"],
//            UITextAttributeTextShadowColor: [UIColor colorWithHex:@"#661C04"],
            UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 0.0f)],
//            UITextAttributeFont: [UIFont fontWithName:@"Lobster" size:15.0f]
    } forState:UIControlStateHighlighted];*/

//    [[UITableView appearance] setBackgroundColor:[UIColor colorWithHex:@"#F2F5E3"]];
    [[UITableView appearance] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"paper_fibers.png"]]];
    [[UIToolbar appearance] setTintColor:[UIColor colorWithHex:@"#BCBFB5"]];
}

- (void)registerDeviceTokenKey {
    [[NSUserDefaults standardUserDefaults] registerDefaults: @{ @"0" : DeviceTokenKey }];
}

- (void)processRemoteNotificationIfAny:(NSDictionary *)launchOptions {
    if (launchOptions != nil) {
		NSDictionary* dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
		if (dictionary != nil) {
			NSLog(@"Launched from push notification: %@", dictionary);
			[self processRemoteNotification:dictionary];
		}
	}
}

- (void)initLogging {
    [[AFHTTPRequestOperationLogger sharedLogger] startLogging];
}

- (void)initTestFlight {
    [self setupTestFlight];
}

- (void)initURLCache {
    SDURLCache *URLCache = [[SDURLCache alloc] initWithMemoryCapacity:1024*1024*2
                                                         diskCapacity:1024*1024*20
                                                             diskPath:[SDURLCache defaultCachePath]];
    [NSURLCache setSharedURLCache:URLCache];
}

- (void)initRemoteDebugger {
//#if DEBUG
//    PDDebugger *debugger = [PDDebugger defaultInstance];
//    [debugger connectToURL:[NSURL URLWithString:@"ws://localhost:9000/device"]];
//    [debugger enableNetworkTrafficDebugging];
//#endif

//#if (TARGET_IPHONE_SIMULATOR)
//        [NSClassFromString(@"WebView") performSelector:@selector(_enableRemoteInspector)];
//#endif
}

- (NSString*)udid {
    NSString *uniqueIdentifier = [XBUDID uniqueIdentifier];
    NSLog(@"Unique identifier: %@", uniqueIdentifier);
    return [uniqueIdentifier stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

- (NSString*)deviceToken {
	return [[NSUserDefaults standardUserDefaults] stringForKey:DeviceTokenKey];
}

- (void)setDeviceToken:(NSString*)token {
	[[NSUserDefaults standardUserDefaults] setObject:token forKey:DeviceTokenKey];
}

// Delegation methods

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"My token is: %@", deviceToken);

    NSString* newToken = [deviceToken description];
	newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
	NSLog(@"My token is: %@", newToken);
    
    if (self.deviceToken != newToken || !self.registered) {
        [self sendProviderDeviceToken: newToken];
        self.deviceToken = newToken;
        self.registered = YES;
    }
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
	NSLog(@"Failed to get token, error: %@", error);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"Received notification: %@", userInfo);
	[self processRemoteNotification:userInfo];
}

- (void)sendProviderDeviceToken:(NSString *)deviceToken {
    NSDictionary *jsonPayload = @{ @"udid": [self udid], @"token": deviceToken};

    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:[self.configurationProvider baseUrl]]];
    NSURLRequest *urlRequest = [client requestWithMethod:@"POST" path:@"/api/notification/register" parameters:jsonPayload];

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            if (response.statusCode > 299) {
                NSString *reasonPhrase = (__bridge_transfer NSString *)CFHTTPMessageCopyResponseStatusLine((__bridge CFHTTPMessageRef)response);
                NSLog(@"We got an error ! Status code: %i - Message: %@", response.statusCode, reasonPhrase);
            } else {
                NSLog(@"Device was registered by server as expected");
            }
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"Device was registered by server as expected. Error: %@, JSON: %@", error, JSON);
        }
    ];

    [operation start];

}

- (void)processRemoteNotification:(NSDictionary*)userInfo {
	NSString* alertValue = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
    
	NSLog(@"Alert received: %@", alertValue);
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    NSLog(@"Application received a memory warning !");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"Application will terminate !!");
//    [MagicalRecord cleanUp];
}

/*
   My Apps Custom uncaught exception catcher, we do special stuff here, and TestFlight takes care of the rest
  */
void HandleExceptions(NSException *exception) {
    NSLog(@"This is where we save the application data during a exception");
    // Save application data on crash
}
/*
 My Apps Custom signal catcher, we do special stuff here, and TestFlight takes care of the rest
*/
void SignalHandler(int sig) {
    NSLog(@"This is where we save the application data during a signal");
    // Save application data on crash
}

- (void)setupTestFlight {
    // installs HandleExceptions as the Uncaught Exception Handler
    NSSetUncaughtExceptionHandler(&HandleExceptions);
    // create the signal action structure
    struct sigaction newSignalAction;
    // initialize the signal action structure
    memset(&newSignalAction, 0, sizeof(newSignalAction));
    // set SignalHandler as the handler in the signal action structure
    newSignalAction.sa_handler = &SignalHandler;
    // set SignalHandler as the handlers for SIGABRT, SIGILL and SIGBUS
    sigaction(SIGABRT, &newSignalAction, NULL);
    sigaction(SIGILL, &newSignalAction, NULL);
    sigaction(SIGBUS, &newSignalAction, NULL);
    // Call takeOff after install your own unhandled exception and signal handlers

//#ifdef DEBUG
//    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
//#endif
    [TestFlight takeOff:@"5cb5c652-2faa-4ae1-9441-db0444a83612"];

}

@end
