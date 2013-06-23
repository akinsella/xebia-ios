//
//  XBMainViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 19/08/12.
//
//

#import "XBMainViewController.h"

#import "XBWebViewController.h"
#import "JSONKit.h"
#import "XBMapper.h"
#import "NSDateFormatter+XBAdditions.h"


// Enum for row indices
enum {
    XBMenuHome = 0,
    XBMenuWordpress,
    XBMenuTwitter,
    XBMenuGithub,
    XBMenuEvent,
};

@interface XBMainViewController ()

@property (nonatomic, strong) XBViewControllerManager *viewControllerManager;

@end

@implementation XBMainViewController

+ (id)controllerWithCentralViewControllerIdentifier:(NSString *)centralViewControllerIdentifier
                       leftViewControllerIdentifier:(NSString *)leftViewControllerIdentifier
                              viewControllerManager:(XBViewControllerManager *)viewControllerManager
                            revealControllerOptions:(NSDictionary *)revealControllerOptions {
    return [[self alloc] initWithCentralViewControllerIdentifier:centralViewControllerIdentifier
                                    leftViewControllerIdentifier:leftViewControllerIdentifier
                                           viewControllerManager:viewControllerManager
                                         revealControllerOptions:revealControllerOptions];
}

- (id)initWithCentralViewControllerIdentifier:(NSString *)centralViewControllerIdentifier
                 leftViewControllerIdentifier:(NSString *)leftViewControllerIdentifier
                        viewControllerManager:(XBViewControllerManager *)viewControllerManager
                      revealControllerOptions:(NSDictionary *)revealControllerOptions {

    self.viewControllerManager = viewControllerManager;
    UIViewController *leftViewController = [self.viewControllerManager getOrCreateControllerWithIdentifier:leftViewControllerIdentifier];
    UIViewController *centralViewController = [self.viewControllerManager getOrCreateControllerWithIdentifier:centralViewControllerIdentifier];

    self = [super initWithFrontViewController:centralViewController
                           leftViewController:leftViewController
                                      options:revealControllerOptions];

    if (self) {
        [self setMinimumWidth:120.0f maximumWidth:200.0f forViewController:leftViewController];
    }

    return self;
}

- (void)revealViewController:(UIViewController *)viewController {
    UINavigationController *frontViewController = (UINavigationController *) self.frontViewController;
    if (frontViewController.visibleViewController != viewController) {
        [frontViewController pushViewController:viewController animated:true];
    }
}

-(void)openLocalURL:(NSString *)htmlFileRef withTitle:(NSString *)title object:(id)object shareInfo: (XBShareInfo *)shareInfo {

    NSDateFormatter *outputFormatter = [NSDateFormatter initWithDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZ"];

    NSDictionary *dict = [XBMapper dictionaryWithPropertiesOfObject:object];
    NSString* json = [dict JSONStringWithOptions:JKSerializeOptionNone serializeUnsupportedClassesUsingBlock:^id(id objectToSerialize) {
        if([objectToSerialize isKindOfClass:[NSDate class]]) {
            return([outputFormatter stringFromDate:object]);
        }
        return(nil);
    } error:nil];

    [self openLocalURL:htmlFileRef withTitle:title json:json shareInfo:shareInfo];
}

-(void)openLocalURL:(NSString *)htmlFileRef withTitle:(NSString *)title json:(NSString *)json shareInfo: (XBShareInfo *)shareInfo
 {
    XBWebViewController *webViewController = (XBWebViewController *)[self.viewControllerManager getOrCreateControllerWithIdentifier: @"webview"];

     webViewController.title = title;
     webViewController.shareInfo = shareInfo;
     webViewController.json = json;

     NSString *htmlFile = [[NSBundle mainBundle] pathForResource:htmlFileRef ofType:@"html" inDirectory:@"www"];
     NSURL *htmlDocumentUrl = [NSURL fileURLWithPath:htmlFile];
     [self revealViewController: webViewController];

     [webViewController.webView loadRequest:[NSURLRequest requestWithURL:htmlDocumentUrl]];
}

-(void)openURL:(NSURL *)url withTitle:(NSString *)title {
    XBWebViewController *webViewController = (XBWebViewController *)[self.viewControllerManager getOrCreateControllerWithIdentifier: @"webview"];
    UINavigationController *frontViewController = (UINavigationController *) self.revealController.frontViewController;
    [frontViewController pushViewController:webViewController animated:true];
    webViewController.title = title;
    
    [webViewController.webView loadRequest:[NSURLRequest requestWithURL: url]];
}

-(void)revealViewControllerWithIdentifier:(NSString *)identifier {
    if ([self currentViewIsViewControllerWithIdentifier: identifier]) {
        [self.revealController resignPresentationModeEntirely:YES animated:YES completion:^(BOOL finished) { }];
    }
    else {
        UIViewController * viewController = [self.viewControllerManager getOrCreateControllerWithIdentifier: identifier];

        [self.revealController showViewController:viewController];
    }
}

-(BOOL)currentViewIsViewControllerWithIdentifier:(NSString *)identifier {
    return ((UINavigationController *)self.revealController.frontViewController).topViewController == [self.viewControllerManager getOrCreateControllerWithIdentifier:identifier];
}

@end
