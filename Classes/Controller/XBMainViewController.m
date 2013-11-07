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
#import "XBRightMenuViewController.h"
#import "UIViewController+XBAdditions.h"
#import "XBLeftMenuViewController.h"

@interface XBMainViewController ()

@property (nonatomic, strong) XBViewControllerManager *viewControllerManager;

@property (nonatomic, strong) XBLeftMenuViewController *leftMenuViewController;
@property (nonatomic, strong) XBRightMenuViewController *rightMenuViewController;

@end

@implementation XBMainViewController

+ (id)controllerWithCentralViewControllerIdentifier:(NSString *)centralViewControllerIdentifier
                       leftViewControllerIdentifier:(NSString *)leftViewControllerIdentifier
                      rightViewControllerIdentifier:(NSString *)rightViewControllerIdentfier
                              viewControllerManager:(XBViewControllerManager *)viewControllerManager
                            revealControllerOptions:(NSDictionary *)revealControllerOptions {
    return [[self alloc] initWithCentralViewControllerIdentifier:centralViewControllerIdentifier
                                    leftViewControllerIdentifier:leftViewControllerIdentifier
                                   rightViewControllerIdentifier: rightViewControllerIdentfier
                                           viewControllerManager:viewControllerManager
                                         revealControllerOptions:revealControllerOptions];
}

- (id)initWithCentralViewControllerIdentifier:(NSString *)centralViewControllerIdentifier
                 leftViewControllerIdentifier:(NSString *)leftViewControllerIdentifier
                rightViewControllerIdentifier:(NSString *)rightViewControllerIdentifier
                        viewControllerManager:(XBViewControllerManager *)viewControllerManager
                      revealControllerOptions:(NSDictionary *)revealControllerOptions {

    self.viewControllerManager = viewControllerManager;

    UINavigationController *leftViewNavigationController = (UINavigationController *)[self.viewControllerManager getOrCreateControllerWithIdentifier:leftViewControllerIdentifier];
    self.leftMenuViewController = (XBLeftMenuViewController *)[leftViewNavigationController topViewController];

    UIViewController *centralViewController = [self.viewControllerManager getOrCreateControllerWithIdentifier:centralViewControllerIdentifier];

    UINavigationController *rightViewNavigationController = (UINavigationController *)[self.viewControllerManager getOrCreateControllerWithIdentifier:rightViewControllerIdentifier];
    self.rightMenuViewController = (XBRightMenuViewController *)[rightViewNavigationController topViewController];


    self = [super initWithFrontViewController:centralViewController
                           leftViewController:leftViewNavigationController
                          rightViewController:rightViewNavigationController
                                      options:revealControllerOptions];

    if (self) {
        [self setMinimumWidth:290.0f maximumWidth:290.0f forViewController:leftViewNavigationController];
        [self setMinimumWidth:290.0f maximumWidth:290.0f forViewController:rightViewNavigationController];
    }

    return self;
}

- (void)revealViewController:(UIViewController *)viewController {
    UINavigationController *frontViewController = (UINavigationController *) self.frontViewController;
    if (frontViewController.visibleViewController != viewController) {
        [frontViewController pushViewController:viewController animated:YES];
    }
}

-(void)revealViewControllerWithIdentifier:(NSString *)identifier {

    [self.leftMenuViewController revealViewControllerWithIdentifier: identifier];
}

- (void)revealViewControllerWithIdentifier:(NSString *)identifier withPath:(NSString *)path {

    [self.leftMenuViewController revealViewControllerWithIdentifier: identifier withPath:path];

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

     NSString *htmlFile = [[NSBundle bundleForClass:self.class] pathForResource:htmlFileRef ofType:@"html" inDirectory:@"www"];
     NSURL *htmlDocumentUrl = [NSURL fileURLWithPath:htmlFile];
     [self revealViewController: webViewController];

     [webViewController loadRequest:htmlDocumentUrl];
}

-(void)openURL:(NSURL *)url withTitle:(NSString *)title {
    XBWebViewController *webViewController = (XBWebViewController *)[self.viewControllerManager getOrCreateControllerWithIdentifier: @"webview"];
    UINavigationController *frontViewController = (UINavigationController *) self.appDelegate.mainViewController.frontViewController;
    [frontViewController pushViewController:webViewController animated:true];
    webViewController.title = title;
    
    [webViewController loadRequest:url];
}

@end
