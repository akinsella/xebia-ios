//
//  XBMainViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 19/08/12.
//
//

#import "XBMainViewController.h"

#import "UINavigationController+XBAdditions.h"
#import "NSNumber+XBAdditions.h"
#import "RKTableItem+XKAdditions.h"
#import "UIImageView+XBAdditions.h"
#import "XBWebViewController.h"
#import <RestKit/RestKit.h>
#import "RKMIMETypes.h"
#import "RKObjectSerializer.h"
#import "RKMimeTypes.h"
#import "WPPost.h"
#import "JSONKit.h"
#import "NSDictionary+RKRequestSerialization.h"
#import "RKRequestSerialization.h"
#import "XBShareInfo.h"


// Enum for row indices
enum {
    XBMenuHome = 0,
    XBMenuWordpress,
    XBMenuTwitter,
    XBMenuGithub,
    XBMenuEvent,
};

@interface XBMainViewController ()
@property (nonatomic, strong) RKTableController *tableController;
@property (nonatomic, strong) XBRevealController *revealController;
@property (nonatomic, strong) NSMutableDictionary *viewIdentifiers;
@property (nonatomic, strong) XBViewControllerManager *viewControllerManager;
@property (nonatomic, strong) UINavigationController *rearNavigationController;
@property (nonatomic, strong) RKTableViewCellMapping *tableCellMapping;
@property (nonatomic, strong) NSArray *tableItems;
@end

@implementation XBMainViewController

- (id)initWithViewControllerManager:(XBViewControllerManager *)viewControllerManager {
    self = [super init];

    if (self) {
        self.viewControllerManager = viewControllerManager;

        [self initNavigationBar];
        [self initRevealController];
        [self initViewIdentifiers];
        [self initTable];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)initTable {
    [self.tableView setSeparatorStyle: UITableViewCellSeparatorStyleNone];
    self.tableController = [RKTableController tableControllerForTableViewController:self];

    [self initTableItems];

    [self initCellMapping];
    [self.tableController loadTableItems:self.tableItems withMapping: self.tableCellMapping];
}


//-----------------------------------------------------------------------
// Navigation Bar initialization
//-----------------------------------------------------------------------

- (void)initNavigationBar {
    self.navigationItem.titleView = [UIImageView initWithImageNamed:@"Xebia-Logo"];
    [self customizeMenuBackground];
}

-(void)customizeMenuBackground {
    UIView* backgrounView = [[UIView alloc] initWithFrame: self.tableView.bounds];
    [backgrounView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"NSTexturedFullScreenBackgroundColor"]]];
    [self.tableView setBackgroundView:backgrounView];
}

//-----------------------------------------------------------------------
// Reveal Controller initialization
//-----------------------------------------------------------------------

- (void)initRevealController {
    self.rearNavigationController = [[UINavigationController alloc] initWithRootViewController:self navBarCustomized:YES];
    UIViewController *homeController = [self.viewControllerManager getOrCreateControllerWithIdentifier:@"home"];

    self.revealController = [[XBRevealController alloc] initWithFrontViewController: homeController.navigationController
                                                            rearViewController:self.rearNavigationController];
}


- (void)revealViewController:(UIViewController *)viewController {
    UINavigationController *frontViewController = (UINavigationController *) self.revealController.frontViewController;
    [frontViewController pushViewController:viewController animated:true];
}

-(void)openLocalURL:(NSString *)htmlFileRef withTitle:(NSString *)title object:(id)object shareInfo: (XBShareInfo *)shareInfo {
    RKObjectMapping *serializationMapping = [[[RKObjectManager sharedManager] mappingProvider] serializationMappingForClass:[object class]];
    RKObjectSerializer* serializer = [RKObjectSerializer serializerWithObject:object mapping:serializationMapping];
    NSError* error = nil;
    NSString *json = [serializer serializedObjectForMIMEType:RKMIMETypeJSON error:&error];

    if (error) {
        RKLogError(@"Serializing failed for source object %@ to MIME Type %@: %@", object, RKMIMETypeJSON, [error localizedDescription]);
    } else {
        [self openLocalURL:htmlFileRef withTitle:title json:json shareInfo:shareInfo];
    }
}

-(void)openLocalURL:(NSString *)htmlFileRef withTitle:(NSString *)title json:(NSString *)json shareInfo: (XBShareInfo *)shareInfo
 {
    XBWebViewController *webViewController = (XBWebViewController *)[self.viewControllerManager getOrCreateControllerWithIdentifier: @"webview"];
    UINavigationController *frontViewController = (UINavigationController *) self.revealController.frontViewController;

     webViewController.title = title;
     webViewController.shareInfo = shareInfo;
     webViewController.json = json;
    [frontViewController pushViewController:webViewController animated:true];

     NSString *htmlFile = [[NSBundle mainBundle] pathForResource:htmlFileRef ofType:@"html" inDirectory:@"www"];
     NSURL *htmlDocumentUrl = [NSURL fileURLWithPath:htmlFile];
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
        [self.revealController revealToggle:self];
    }
    else {
        UIViewController * viewController = [self.viewControllerManager getOrCreateControllerWithIdentifier: identifier];
        [self.revealController setFrontViewController:viewController.navigationController animated:NO];
    }
}

-(BOOL)currentViewIsViewControllerWithIdentifier:(NSString *)identifier {
    return ((UINavigationController *)self.revealController.frontViewController).topViewController == [self.viewControllerManager getOrCreateControllerWithIdentifier:identifier];
}

//-----------------------------------------------------------------------
// Table content initialization
//-----------------------------------------------------------------------

- (void)initViewIdentifiers {
    self.viewIdentifiers = [@{
        [NSNumber asString:XBMenuHome]: @"home",
        [NSNumber asString:XBMenuWordpress]: @"tbBlog",
        [NSNumber asString:XBMenuTwitter]: @"tweets",
        [NSNumber asString:XBMenuGithub]: @"tbGithub",
        [NSNumber asString:XBMenuEvent]: @"events"
    } mutableCopy];
}

- (void)initTableItems {
    self.tableItems = @[
       [RKTableItem tableItemWithText:@"Home" imageNamed:@"home"],
       [RKTableItem tableItemWithText:@"Blog" imageNamed:@"wordpress"],
       [RKTableItem tableItemWithText:@"Tweets" imageNamed:@"twitter"],
       [RKTableItem tableItemWithText:@"Github"  imageNamed:@"github"],
       [RKTableItem tableItemWithText:@"Events"  imageNamed:@"eventbrite-menu"]
    ];
}

- (void)initCellMapping {
    self.tableCellMapping = [RKTableViewCellMapping defaultCellMapping];

    self.tableCellMapping.cellClassName = @"XBMenuCell";
    self.tableCellMapping.reuseIdentifier = @"XBMenu";
    self.tableCellMapping.accessoryType = UITableViewCellAccessoryNone;

    [self.tableCellMapping mapKeyPath:@"text" toAttribute:@"titleLabel.text"];

    // Avoid leak on self in block
    __weak XBMainViewController *mvc = self;
    self.tableCellMapping.onSelectCellForObjectAtIndexPath = ^(UITableViewCell *cell, id object, NSIndexPath* indexPath) {
        NSString *identifier = [self.viewIdentifiers valueForKey:[NSNumber asString:indexPath.row]];
        [mvc revealViewControllerWithIdentifier: identifier];
    };
}

@end
