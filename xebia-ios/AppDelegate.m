//
//  AppDelegate.m
//  Xebia Application
//
//  Created by Alexis Kinsella on 10/06/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "AppDelegate.h"
#import "XBSharekitSupport.h"
#import "ZUUIRevealController.h"
#import "XBMainViewController.h"
//#import <PonyDebugger/PDDebugger.h>
#import "SDUrlCache.h"
#import "AFHTTPRequestOperationLogger.h"
#import "AFNetworking.h"
//#import "MagicalRecord+Setup.h"

static NSString* const DeviceTokenKey = @"DeviceToken";

@implementation AppDelegate {
    XBViewControllerManager *_viewControllerManager;
    XBMainViewController *_mainViewController;
}

@synthesize window = _window;

@synthesize viewControllerManager = _viewControllerManager;
@synthesize mainViewController = _mainViewController;

+(NSString *)baseUrl {
//    return @"http://dev.xebia.fr:9000";
    return @"http://xebia-mobile-backend.cloudfoundry.com";
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

/*
    NSString *storeFileName = [MagicalRecord defaultStoreName];
    NSURL *url = [NSPersistentStore MR_urlForStoreName:storeFileName];
    [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
    MRLog(@"Removed store for debug purpose: %@", [url lastPathComponent]);
*/

    [[AFHTTPRequestOperationLogger sharedLogger] startLogging];

//    [MagicalRecord setupCoreDataStack];


    SDURLCache *URLCache = [[SDURLCache alloc] initWithMemoryCapacity:1024*1024*2
                                                         diskCapacity:1024*1024*20
                                                             diskPath:[SDURLCache defaultCachePath]];
    [NSURLCache setSharedURLCache:URLCache];


//#if DEBUG
//    PDDebugger *debugger = [PDDebugger defaultInstance];
//    [debugger connectToURL:[NSURL URLWithString:@"ws://localhost:9000/device"]];
//    [debugger enableNetworkTrafficDebugging];
//#endif

//#if (TARGET_IPHONE_SIMULATOR)
//        [NSClassFromString(@"WebView") performSelector:@selector(_enableRemoteInspector)];
//#endif

    if (launchOptions != nil)
	{
		NSDictionary* dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
		if (dictionary != nil)
		{
			NSLog(@"Launched from push notification: %@", dictionary);
			[self processRemoteNotification:dictionary];
		}
	}
    
    [[NSUserDefaults standardUserDefaults] registerDefaults: @{ @"0" : DeviceTokenKey }];
    
    [XBSharekitSupport configure];

    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    _viewControllerManager = [XBViewControllerManager sharedInstance];
    _mainViewController = [[XBMainViewController alloc] initWithViewControllerManager:_viewControllerManager];
    
	self.window.rootViewController = [_mainViewController revealController];
    [self.window makeKeyAndVisible];

    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert)];

    
    return YES;
}

- (NSString*)udid {
	UIDevice* device = [UIDevice currentDevice];
	return [device.uniqueIdentifier stringByReplacingOccurrencesOfString:@"-" withString:@""];
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

    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:[AppDelegate baseUrl]]];
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

@end
