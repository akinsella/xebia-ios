//
//  XBViewControllerManager.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 19/08/12.
//
//

#import "XBViewControllerManager.h"
#import "UINavigationController+XBAdditions.h"
#import "XBWebViewController.h"

@implementation XBViewControllerManager

NSMutableDictionary *viewControllers;

static XBViewControllerManager *sharedInstance = nil;

// Get the shared instance and create it if necessary.
+ (XBViewControllerManager *)sharedInstance
{
    if (!sharedInstance) {
        sharedInstance = (XBViewControllerManager *) [[super allocWithZone:NULL] init];
    }

    // returns the same object each time
    return sharedInstance;
}


-(id)init {
    self = [super init];

    if (self) {
        viewControllers = [[NSMutableDictionary alloc] init];
    }

    return self;
}

-(BOOL)openURL:(NSURL *)url {
    NSLog(@"Url click handled: %@", url);
    
    XBWebViewController *webViewController = (XBWebViewController *)[self getOrCreateControllerWithIdentifier: @"webview"];
    
    [webViewController.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    return YES;
}

- (UIViewController *)getOrCreateControllerWithIdentifier:(NSString *)identifier {
    UIViewController *vc = [viewControllers objectForKey:identifier];
    if (!vc) {
        vc = [self instantiateViewControllerWithIdentifier:identifier];
    }
    // Workaround to fix some weird autorelease of navigationController associated to the view
    if (!vc.navigationController) {
        [[[UINavigationController alloc] initWithRootViewController:vc navBarCustomized:YES] autorelease];
    }

    return vc;
}


-(UIViewController *)instantiateViewControllerWithIdentifier: (NSString *)identifier {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:identifier];

    [viewControllers setValue:vc forKey:identifier];

    return vc;
}

// http://www.johnwordsworth.com/2010/04/iphone-code-snippet-the-singleton-pattern/

// Your dealloc method will never be called, as the singleton survives for the duration of your app.
// However, I like to include it so I know what memory I'm using (and incase, one day, I convert away from Singleton).
-(void)dealloc
{
    // I'm never called!
    [super dealloc];
}


// We don't want to allocate a new instance, so return the current one.
+ (id)allocWithZone:(NSZone*)zone {
    return [[self sharedInstance] retain];
}

// Equally, we don't want to generate multiple copies of the singleton.
- (id)copyWithZone:(NSZone *)zone {
    return self;
}

// Once again - do nothing, as we don't have a retain counter for this object.
- (id)retain {
    return self;
}

// Replace the retain counter so we can never release this object.
- (NSUInteger)retainCount {
    return NSUIntegerMax;
}

// This function is empty, as we don't want to let the user release this object.
- (oneway void)release {

}

//Do nothing, other than return the shared instance - as this is expected from autorelease.
- (id)autorelease {
    return self;
}

@end