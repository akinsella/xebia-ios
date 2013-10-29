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
#import "XBLeftMenuViewController.h"
#import "GAITracker.h"
#import "GAI.h"
#import "XBUDID.h"
#import "XBConstants.h"
#import "DCIntrospect.h"
#import "Appirater.h"
#import <NewRelicAgent/NewRelicAgent.h>


static NSString *const kTrackingId = @"UA-40651647-1";

//TODO: Need to change AppID
static NSString *const kAppId = @"1234567890";

static NSString *const DeviceTokenKey = @"DeviceToken";

static NSString *const TestFlightAppToken = @"856b817d-b51c-44a3-9a24-ddcabfda8a0c";

static NSString *const NewRelicApiKey = @"AA2a83288c6a4104ccf6cb9d48101ae3aba20325cc";

@interface XBAppDelegate()

@property(nonatomic, strong) XBViewControllerManager *viewControllerManager;
@property(nonatomic, strong) XBMainViewController *mainViewController;
@property(nonatomic, strong) NSString *deviceToken;
@property(nonatomic, strong) XBConfigurationProvider *configurationProvider;
@property(nonatomic, assign) Boolean registered;

@end

@implementation XBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    if (NSClassFromString(@"SenTestCase") != nil) {
        return YES;
    }

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackTranslucent;
    }

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *initViewController = [storyboard instantiateViewControllerWithIdentifier:@"centralNavigationController"];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController: initViewController];


    self.configurationProvider = [XBPListConfigurationProvider provider];

    [self initLogging];

    [self initAnalytics];
    [self initTestFlight];
    [self initNewRelic];
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

    [self initApplicationRating];

#if DEBUG
    XBLeftMenuViewController *leftMenuViewController = (XBLeftMenuViewController *) [(UINavigationController *)self.mainViewController.leftViewController topViewController];
    [leftMenuViewController revealViewControllerWithIdentifier:@"home"];
//    [leftMenuViewController revealViewControllerWithIdentifier:@"events"];
//    [leftMenuViewController revealViewControllerWithIdentifier:@"tbBlog"];
//    [leftMenuViewController revealViewControllerWithIdentifier:@"videos"];
#endif

    [self.window makeKeyAndVisible];

//    self.window.backgroundColor = [UIColor redColor];
    return YES;
}

- (void)initNewRelic {
    [NewRelicAgent startWithApplicationToken: NewRelicApiKey];
}

-(id<GAITracker>)tracker {
    return GAI.sharedInstance.defaultTracker;
}

- (void)initApplicationRating {
    [Appirater setAppId:kAppId];
    [Appirater setDaysUntilPrompt:1];
    [Appirater setUsesUntilPrompt:10];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    
#if TARGET_IPHONE_SIMULATOR || defined(DEBUG)
    [Appirater setDebug:YES];
#else
    [Appirater setDebug:NO];
#endif

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
            PKRevealControllerRecognizesPanningOnFrontViewKey : @YES
    };

    self.mainViewController = [XBMainViewController controllerWithCentralViewControllerIdentifier:@"centralNavigationController"
                                                                     leftViewControllerIdentifier:@"leftMenuNavigationController"
                                                                    rightViewControllerIdentifier:@"rightMenuNavigationController"
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


    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar-portrait-2.png"] forBarMetrics:UIBarMetricsDefault];
        if (IS_IPHONE_5) {
            [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar-landscape-iphone5-2.png"] forBarMetrics:UIBarMetricsLandscapePhone];
        }
        else {
            [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar-landscape-2.png"] forBarMetrics:UIBarMetricsLandscapePhone];
        }
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithHex: @"#BCBFB5"]];
    }
    else {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar-portrait.png"] forBarMetrics:UIBarMetricsDefault];
        if (IS_IPHONE_5) {
            [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar-landscape-iphone5.png"] forBarMetrics:UIBarMetricsLandscapePhone];
        }
        else {
            [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar-landscape.png"] forBarMetrics:UIBarMetricsLandscapePhone];
        }
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithHex: @"#BCBFB5"]];
    }

//    [[UINavigationBar appearance] setBackgroundColor:[UIColor purpleColor]];
//    [[UINavigationBar appearance] setTintColor:[UIColor purpleColor]];
    [[UINavigationBar appearance] setTitleTextAttributes: @{
            UITextAttributeTextColor: [UIColor colorWithHex:@"#FFFFFF"],
            UITextAttributeTextShadowColor: [UIColor colorWithHex:@"#661C04"],
            UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)],
            UITextAttributeFont: [UIFont fontWithName:@"Lobster" size:20.0f]
    }];
    
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"TabBar.png"]];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"TabBarItemSelectedImage.png"]];

    [[UITabBar appearance] setSelectedImageTintColor:[UIColor colorWithHex:@"#5c0f4f"]];

    [[UITabBarItem appearance] setTitleTextAttributes: @{
            UITextAttributeTextColor: [UIColor colorWithHex:@"#888888"],
            UITextAttributeTextShadowColor: [UIColor blackColor]
    } forState:UIControlStateNormal];

    [[UITabBarItem appearance] setTitleTextAttributes:@{
            UITextAttributeTextColor: [UIColor colorWithHex:@"#b96905"],
            UITextAttributeTextShadowColor: [UIColor blackColor]
    } forState:UIControlStateSelected];

    // Change the appearance of back button
    UIImage *backButtonImage = [[UIImage imageNamed:@"left-arrow.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 16, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:backButtonImage];
        [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:backButtonImage];
    }

    // Change the appearance of other navigation button
    UIImage *barButtonImage = [[UIImage imageNamed:@"button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
    [[UIBarButtonItem appearance] setBackgroundImage: barButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

    [[UIBarButtonItem appearance] setTitleTextAttributes: @{
            UITextAttributeTextColor: [UIColor whiteColor],
            UITextAttributeFont: [UIFont boldSystemFontOfSize:16.0f],
            UITextAttributeTextShadowColor: [UIColor darkGrayColor],
            UITextAttributeTextShadowOffset: [NSValue valueWithCGSize:CGSizeMake(0.0, -1.0)]
    } forState:UIControlStateNormal];



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
//    [[UITableView appearance] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"paper_fibers.png"]]];
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
    [TestFlight takeOff: TestFlightAppToken];

}

@end
