//
//  XBMainViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 19/08/12.
//
//

#import "XBMainViewController.h"

#import "XBWebViewController.h"
#import "XBMapper.h"
#import "NSDateFormatter+XBAdditions.h"
#import "UIViewController+XBAdditions.h"
#import "XBLeftMenuViewController.h"
#import "NSDictionary+XBAdditions.h"

@interface XBMainViewController ()

@property (nonatomic, strong) XBViewControllerManager *viewControllerManager;

@property (nonatomic, strong) XBLeftMenuViewController *leftMenuViewController;

@end

@implementation XBMainViewController

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

+ (id)controllerWithCentralViewControllerIdentifier:(NSString *)centralViewControllerIdentifier
                       leftViewControllerIdentifier:(NSString *)leftViewControllerIdentifier
                              viewControllerManager:(XBViewControllerManager *)viewControllerManager {
    return [[self alloc] initWithCentralViewControllerIdentifier:centralViewControllerIdentifier
                                    leftViewControllerIdentifier:leftViewControllerIdentifier
                                           viewControllerManager:viewControllerManager];
}

- (id)initWithCentralViewControllerIdentifier:(NSString *)centralViewControllerIdentifier
                 leftViewControllerIdentifier:(NSString *)leftViewControllerIdentifier
                        viewControllerManager:(XBViewControllerManager *)viewControllerManager {

    self.viewControllerManager = viewControllerManager;

    UINavigationController *leftViewNavigationController = (UINavigationController *)[self.viewControllerManager getOrCreateControllerWithIdentifier:leftViewControllerIdentifier];
    self.leftMenuViewController = (XBLeftMenuViewController *)[leftViewNavigationController topViewController];

    UIViewController *centralViewController = [self.viewControllerManager getOrCreateControllerWithIdentifier:centralViewControllerIdentifier];

    self = [super initWithCenterViewController:centralViewController leftDrawerViewController:leftViewNavigationController];

    if (self) {
        self.maximumLeftDrawerWidth = 290.0;
    }

    return self;
}

- (void)revealViewController:(UIViewController *)viewController {
    UINavigationController *frontViewController = (UINavigationController *) self.centerViewController;
    if (frontViewController.visibleViewController != viewController) {
        [frontViewController pushViewController:viewController animated:YES];
    }
}

-(void)revealViewControllerWithIdentifier:(NSString *)identifier {
    [self.leftMenuViewController revealViewControllerWithIdentifier: identifier];
}

- (void)revealViewControllerWithURL:(NSURL *)url {
    [self.leftMenuViewController revealViewControllerWithURL: url];
}

-(void)openLocalURL:(NSString *)htmlFileRef withTitle:(NSString *)title object:(id)object shareInfo: (XBShareInfo *)shareInfo {

    NSDateFormatter *outputFormatter = [NSDateFormatter initWithDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZ"];

    NSDictionary *dict = [XBMapper dictionaryWithPropertiesOfObject:object];

    NSError *error;
    NSString *json = [dict JSONStringWithError:&error dateFormatter:outputFormatter];

    [self openLocalURL:htmlFileRef withTitle:title json:json shareInfo:shareInfo];
}

-(void)openLocalURL:(NSString *)htmlFileRef withTitle:(NSString *)title json:(NSString *)json shareInfo: (XBShareInfo *)shareInfo
{
     UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
     XBWebViewController *webViewController = (XBWebViewController *)[sb instantiateViewControllerWithIdentifier: @"webview"];

     webViewController.title = title;
     webViewController.shareInfo = shareInfo;
     webViewController.json = json;

     NSString *htmlFile = [[NSBundle bundleForClass:self.class] pathForResource:htmlFileRef ofType:@"html" inDirectory:@"www"];
     NSURL *htmlDocumentUrl = [NSURL fileURLWithPath:htmlFile];

     [self revealViewController: webViewController];

     [webViewController loadRequest:htmlDocumentUrl];
}

-(void)openURL:(NSURL *)url withTitle:(NSString *)title {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    XBWebViewController *webViewController = (XBWebViewController *)[sb instantiateViewControllerWithIdentifier: @"webview"];
    UINavigationController *frontViewController = (UINavigationController *) self.appDelegate.mainViewController.centerViewController;

    [webViewController loadRequest:url];

    [frontViewController pushViewController:webViewController animated:true];
    webViewController.title = title;
}

@end
