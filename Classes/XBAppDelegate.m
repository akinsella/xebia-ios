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
#import "GAITracker.h"
#import "GAI.h"
#import "XBUDID.h"
#import "XBConstants.h"
#import "DCIntrospect.h"
#import "Appirater.h"
#import "NSString+XBAdditions.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "WPURLHandler.h"
#import <NewRelicAgent/NewRelicAgent.h>
#import <Crashlytics/Crashlytics.h>

static NSString *const kTrackingId = @"UA-1889791-23";

//TODO: Need to change AppID
static NSString *const kAppId = @"1234567890";

static NSString *const DeviceTokenKey = @"DeviceToken";

static NSString *const TestFlightAppToken = @"856b817d-b51c-44a3-9a24-ddcabfda8a0c";

static NSString *const NewRelicApiKey = @"AA2a83288c6a4104ccf6cb9d48101ae3aba20325cc";

static NSString *const CrashlyticsApiKey = @"48e99a586053e4194936d79b6126ad23e9de4cc7";

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
    [self initCrashlytics];

    [self initMainBundle];

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
    [self.mainViewController revealViewControllerWithIdentifier:@"timeline"];
//    [[[WPURLHandler alloc] init] handleURL:[NSURL URLWithString:@"xebia://blog/posts/3035"]];
//    [self.mainViewController revealViewControllerWithIdentifier:@"events"];
//    [self.mainViewController revealViewControllerWithIdentifier:@"tbBlog"];
//    [self.mainViewController revealViewControllerWithIdentifier:@"tweets"];
//    [self.mainViewController revealViewControllerWithIdentifier:@"videos"];
#endif

    [self.window makeKeyAndVisible];

//    self.window.backgroundColor = [UIColor redColor];
    return YES;
}

- (void)initNewRelic {
    [NewRelicAgent startWithApplicationToken: NewRelicApiKey];
}

-(void)initMainBundle {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // transfer the current version number into the defaults so that this correct value will be displayed when the user visit settings page later
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    [defaults setObject:version forKey:@"version"];
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
    
#if TARGET_IPHONE_SIMULATOR || defined(DEBUG)
    GAI.sharedInstance.dispatchInterval = 20;
    GAI.sharedInstance.logger.logLevel = kGAILogLevelVerbose;
#else
    GAI.sharedInstance.dispatchInterval = 120;
    GAI.sharedInstance.logger.logLevel = kGAILogLevelInfo;
#endif
    
    GAI.sharedInstance.trackUncaughtExceptions = NO;
    id<GAITracker> tracker = [GAI.sharedInstance trackerWithTrackingId:kTrackingId];
    [GAI.sharedInstance setDefaultTracker:tracker];
}

- (void)trackView:(NSString *)viewPath {
    [GAI.sharedInstance.defaultTracker set:kGAIScreenName value:viewPath];
    [GAI.sharedInstance.defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
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
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:[@"navbar-portrait" suffixIfIOS7]] forBarMetrics:UIBarMetricsDefault];
    if (IS_IPHONE_5) {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:[@"navbar-landscape-iphone5" suffixIfIOS7]] forBarMetrics:UIBarMetricsLandscapePhone];
    }
    else {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:[@"navbar-landscape" suffixIfIOS7]] forBarMetrics:UIBarMetricsLandscapePhone];
    }

    [[UINavigationBar appearance] setBackgroundColor:[UIColor whiteColor]];

    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes: @{
            UITextAttributeTextColor: [UIColor colorWithHex:@"#FFFFFF"],
            UITextAttributeFont: [UIFont fontWithName:@"Lobster" size:20.0f]
    }];


    /* TabBar customization */
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"TabBar"]];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"TabBarItemSelectedImage"]];


    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [[UITabBar appearance] setTintColor:[UIColor colorWithHex:@"#5d2655"]];
    }
    else {
        [[UITabBar appearance] setSelectedImageTintColor:[UIColor colorWithHex:@"#5d2655"]];
    }

    [[UITabBarItem appearance] setTitleTextAttributes: @{
            UITextAttributeFont: [UIFont systemFontOfSize:11],
            UITextAttributeTextColor: [UIColor colorWithHex:@"#888888"],
            UITextAttributeTextShadowColor: [UIColor clearColor],
            UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 0.0f)]
    } forState:UIControlStateNormal];

    [[UITabBarItem appearance] setTitleTextAttributes:@{
            UITextAttributeFont: [UIFont systemFontOfSize:11],
            UITextAttributeTextColor: [UIColor colorWithHex:@"#5d2655"],
            UITextAttributeTextShadowColor: [UIColor clearColor],
            UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 0.0f)]
    } forState:UIControlStateSelected];

    /* Back button appearance */

    if (!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {

        UIImage *backButtonImage = [[UIImage imageNamed:@"left-arrow"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 16, 0, 0)];
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

        // Change the appearance of other navigation button
        UIImage *barButtonImage = [[UIImage imageNamed:@"button"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
        [[UIBarButtonItem appearance] setBackgroundImage: barButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }


    [[UIBarButtonItem appearance] setTitleTextAttributes: @{
            UITextAttributeTextColor: [UIColor whiteColor],
            UITextAttributeFont: [UIFont boldSystemFontOfSize:16.0f],
            UITextAttributeTextShadowColor: [UIColor darkGrayColor],
            UITextAttributeTextShadowOffset: [NSValue valueWithCGSize:CGSizeMake(0.0, -1.0)]
    } forState:UIControlStateNormal];
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
    NSDictionary *jsonPayload = @{ @"udid": self.udid, @"token": deviceToken};

#if TARGET_IPHONE_SIMULATOR
    XBLog("Running device is Simulator, cannot send Device Token to server: %@", jsonPayload);
#else
    if (!self.configurationProvider.reachability.isReachable) {
        XBLog("Network is not available, cannot send Device Token to server: %@", jsonPayload);
    }
    else {
        AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:[self.configurationProvider baseUrl]]];
        NSURLRequest *urlRequest = [client requestWithMethod:@"POST" path:[@"/devices/register" stripLeadingSlash] parameters:jsonPayload];

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
#endif
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
}

//void HandleExceptions(NSException *exception) {
//    NSLog(@"This is where we save the application data during a exception");
//    // Save application data on crash
//}

//void SignalHandler(int sig) {
//    NSLog(@"This is where we save the application data during a signal");
//    // Save application data on crash
//}

- (void)initTestFlight {
//    // installs HandleExceptions as the Uncaught Exception Handler
//    NSSetUncaughtExceptionHandler(&HandleExceptions);
//    // create the signal action structure
//    struct sigaction newSignalAction;
//    // initialize the signal action structure
//    memset(&newSignalAction, 0, sizeof(newSignalAction));
//    // set SignalHandler as the handler in the signal action structure
//    newSignalAction.sa_handler = &SignalHandler;
//    // set SignalHandler as the handlers for SIGABRT, SIGILL and SIGBUS
//    sigaction(SIGABRT, &newSignalAction, NULL);
//    sigaction(SIGILL, &newSignalAction, NULL);
//    sigaction(SIGBUS, &newSignalAction, NULL);
//    // Call takeOff after install your own unhandled exception and signal handlers

//#ifdef DEBUG
//    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
//#endifXBNavigableViewController
    [TestFlight takeOff: TestFlightAppToken];
}

-(void)initCrashlytics {
    [Crashlytics startWithAPIKey: CrashlyticsApiKey];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    [self.mainViewController revealViewControllerWithURL:url];

    return YES;
}

@end
