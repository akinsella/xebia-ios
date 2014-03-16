//
//  AppDelegate.m
//  Xebia Application
//
//  Created by Alexis Kinsella on 10/06/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "UIColor+XBAdditions.h"
#import "XBAppDelegate.h"
#import "XBSharekitSupport.h"
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
#import "AFNetworkActivityLogger.h"
#import "XBConferenceRatingManager.h"
#import <NewRelicAgent/NewRelicAgent.h>
#import <Crashlytics/Crashlytics.h>
#import <sys/utsname.h>
#import <sys/sysctl.h>

static NSString *const kTrackingId = @"UA-1889791-23";

//TODO: Need to change AppID
static NSString *const kAppId = @"1234567890";

static NSString *const DeviceTokenKey = @"DeviceToken";

static NSString *const TestFlightAppToken = @"856b817d-b51c-44a3-9a24-ddcabfda8a0c";

static NSString *const NewRelicApiKey = @"AA2a83288c6a4104ccf6cb9d48101ae3aba20325cc";

static NSString *const CrashlyticsApiKey = @"48e99a586053e4194936d79b6126ad23e9de4cc7";

static NSInteger const kApiVersion = 1;

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

    [self initReachability];
    
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

    [self initConferenceRatings];

#if DEBUG
    [self.mainViewController revealViewControllerWithIdentifier:@"timeline"];
//    [[[WPURLHandler alloc] init] handleURL:[NSURL URLWithString:@"xebia://blog/posts/3035"]];
//    [self.mainViewController revealViewControllerWithIdentifier:@"events"];
//    [self.mainViewController revealViewControllerWithIdentifier:@"tbBlog"];
//    [self.mainViewController revealViewControllerWithIdentifier:@"tweets"];
//    [self.mainViewController revealViewControllerWithIdentifier:@"videos"];
#endif

    [self.window makeKeyAndVisible];

    [self checkMinApiVersion];

    return YES;
}

- (void)initReachability
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        // Post notification after delay to avoid connection issues
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [[NSNotificationCenter defaultCenter]
             postNotificationName:XBNetworkStatusChanged
             object:self];
            XBLog(@"Reachability status changed");
        });
    }];
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
    GAI.sharedInstance.logger.logLevel = kGAILogLevelInfo;
#else
    GAI.sharedInstance.dispatchInterval = 120;
    GAI.sharedInstance.logger.logLevel = kGAILogLevelWarning;
#endif
    
    GAI.sharedInstance.trackUncaughtExceptions = NO;
    id<GAITracker> tracker = [GAI.sharedInstance trackerWithTrackingId:kTrackingId];
    [GAI.sharedInstance setDefaultTracker:tracker];
}

- (void)trackView:(NSString *)viewPath {
    XBLog("[Tracker] view path tracked: '%@'", viewPath);
    [GAI.sharedInstance.defaultTracker set:kGAIScreenName value:viewPath];
    [GAI.sharedInstance.defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)initMainViewController {

    self.mainViewController = [XBMainViewController controllerWithCentralViewControllerIdentifier:@"centralNavigationController"
                                                                     leftViewControllerIdentifier:@"leftMenuNavigationController"
                                                                    rightViewControllerIdentifier:@"rightMenuNavigationController"
                                                                            viewControllerManager:self.viewControllerManager
                                                                          revealControllerOptions:nil];
    self.mainViewController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
    self.mainViewController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;

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
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:[@"TabBar" suffixIfIPad]]];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:[@"TabBarItemSelectedImage" suffixIfIPad]]];


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
    [[AFNetworkActivityLogger sharedLogger] startLogging];

#if TARGET_IPHONE_SIMULATOR || defined(DEBUG)
    [[AFNetworkActivityLogger sharedLogger] setLevel:AFLoggerLevelWarn];
#else
    [[AFNetworkActivityLogger sharedLogger] setLevel:AFLoggerLevelError];
#endif
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

-(NSString *)deviceModel {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);

    return platform;
}

-(NSString *)systemVersion {
    return UIDevice.currentDevice.systemVersion;
}

- (void)checkMinApiVersion {

    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable) {
        XBLog("Network is not available, cannot check min api version!");
    }
    else {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestOperation *operation = [manager GET:@"http://backend.mobile.xebia.io/api/info" parameters:nil
                                                  success:^(AFHTTPRequestOperation *operation, id JSON) {
                                                      if (operation.response.statusCode > 299) {
                                                          NSString *reasonPhrase = (__bridge_transfer NSString *)CFHTTPMessageCopyResponseStatusLine((__bridge CFHTTPMessageRef)operation.response);
                                                          NSLog(@"We got an error ! Status code: %i - Message: %@", operation.response.statusCode, reasonPhrase);
                                                      }
                                                      else {
                                                          NSString *minApiVersionStr = JSON[@"minApiVersion"];
                                                          if (!minApiVersionStr) {
                                                              NSLog(@"Could not check minApi version");
                                                          }
                                                          else {
                                                              NSNumberFormatter * nf = [[NSNumberFormatter alloc] init];
                                                              [nf setNumberStyle:NSNumberFormatterDecimalStyle];
                                                              NSNumber * minApiVersion = [nf numberFromString:minApiVersionStr];

                                                              if (minApiVersion.integerValue > kApiVersion) {
                                                                  XBLog("Application API version is not supported anymore by sever");
                                                                  UIViewController *viewController = [self.viewControllerManager getOrCreateControllerWithIdentifier:@"appUpgrade"];
                                                                  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
                                                                  [self.window.rootViewController presentViewController:navigationController animated:true completion:^{ }];
                                                              }
                                                              else {
                                                                  XBLog("Application API version is currently supported by server");
                                                              }
                                                          }
                                                      }
                                                  }
                                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                      NSLog(@"Error: %@", error);
                                                  }
        ];
        [operation start];
    }
}

- (void)sendProviderDeviceToken:(NSString *)deviceToken {
    NSDictionary *jsonPayload = @{ @"udid": self.udid, @"token": deviceToken, @"deviceModel": self.deviceModel, @"systemVersion": self.systemVersion};

#if TARGET_IPHONE_SIMULATOR
    XBLog("Running device is Simulator, cannot send Device Token to server: %@", jsonPayload);
#else
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable) {
        XBLog("Network is not available, cannot send Device Token to server: %@", jsonPayload);
    }
    else {
        XBHttpClient *httpClient = [self configurationProvider].httpClient;
        [httpClient executePostJsonRequestWithPath:[@"/devices/register" stripLeadingSlash] parameters:jsonPayload
                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, id jsonFetched) {
                                               if (response.statusCode > 299) {
                                                   NSString *reasonPhrase = (__bridge_transfer NSString *)CFHTTPMessageCopyResponseStatusLine((__bridge CFHTTPMessageRef)response);
                                                   NSLog(@"Could not register device.  Status code: %i - Message: %@", response.statusCode, reasonPhrase);
                                               }
                                               else {
                                                   NSLog(@"Device got registered by server as expected. JSON: %@", jsonFetched);
                                               }
                                           }
                                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id jsonFetched) {
                                               NSString *reasonPhrase = (__bridge_transfer NSString *)CFHTTPMessageCopyResponseStatusLine((__bridge CFHTTPMessageRef)response);
                                               NSLog(@"Could not register device. We got an error ! Status code: %i - Message: %@", response.statusCode, reasonPhrase);
                                           }
        ];
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

- (void)initTestFlight {
    [TestFlight takeOff: TestFlightAppToken];
}

-(void)initCrashlytics {
    [Crashlytics startWithAPIKey: CrashlyticsApiKey];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    [self.mainViewController revealViewControllerWithURL:url];

    return YES;
}

- (void)initConferenceRatings {
    [XBConferenceRatingManager sharedManager];
}

@end
