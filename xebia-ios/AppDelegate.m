//
//  AppDelegate.m
//  Xebia Application
//
//  Created by Alexis Kinsella on 10/06/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "AppDelegate.h"
#import "XBSharekitSupport.h"
#import "XBRestkitSupport.h"
#import "ZUUIRevealController.h"
#import "XBMainViewController.h"
#import <RestKit/RestKit.h>
#import <RestKit/RKRequestSerialization.h>

static NSString* const DeviceTokenKey = @"DeviceToken";

@implementation AppDelegate {
    XBViewControllerManager *_viewControllerManager;
    XBMainViewController *_mainViewController;
}

@synthesize window = _window;

@synthesize viewControllerManager = _viewControllerManager;
@synthesize mainViewController = _mainViewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    #if (TARGET_IPHONE_SIMULATOR)
        [NSClassFromString(@"WebView") performSelector:@selector(_enableRemoteInspector)];
    #endif

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
    
    [XBRestkitSupport configure];

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
    NSString* jsonBody = [NSString stringWithFormat: @"{\"udid\":\"%@\",\"token\":\"%@\"}", [self udid], deviceToken];
    [[RKClient clientWithBaseURLString:@"http://xebia-mobile-backend.cloudfoundry.com/"]
//    [[RKClient clientWithBaseURLString:@"http://dev.xebia.fr:9000/"]
            post:@"/api/ios/notification/register" usingBlock:^(RKRequest *request) {
        request.params = [RKRequestSerialization serializationWithData:[jsonBody dataUsingEncoding:NSUTF8StringEncoding] MIMEType:RKMIMETypeJSON];
        request.onDidLoadResponse = ^(RKResponse *response){
            if (response.statusCode > 299) {
                NSLog(@"We got an error ! Status code: %i - Message: %@", response.statusCode, response.localizedStatusCodeString);
            } else {
                NSLog(@"Device was registered by server as expected");
            }
        };
        
        request.onDidFailLoadWithError = ^(NSError *error) {
            NSLog(@"Device was registered by server as expected: %@", error);
        };
    }];
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


@end
