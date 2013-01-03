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
#import "UIImageView+XBAdditions.h"
#import "XBWebViewController.h"
#import "WPPost.h"
#import "JSONKit.h"
#import "XBShareInfo.h"
#import "XBMapper.h"
#import "NSDateFormatter+XBAdditions.h"
#import "XBMenuCell.h"


// Enum for row indices
enum {
    XBMenuHome = 0,
    XBMenuWordpress,
    XBMenuTwitter,
    XBMenuGithub,
    XBMenuEvent,
};

@interface XBMainViewController ()
@property (nonatomic, strong) XBRevealController *revealController;
@property (nonatomic, strong) NSMutableDictionary *viewIdentifiers;
@property (nonatomic, strong) XBViewControllerManager *viewControllerManager;
@property (nonatomic, strong) UINavigationController *rearNavigationController;
@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation XBMainViewController

- (id)initWithViewControllerManager:(XBViewControllerManager *)viewControllerManager {
    self = [super init];

    if (self) {
        self.viewControllerManager = viewControllerManager;

        [self initTableItems];
        [self initNavigationBar];
        [self initRevealController];
        [self initViewIdentifiers];

        [self configureTableView];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    self.dataSource = @[
            @{ @"title": @"Home", @"imageName" :@"home"},
            @{ @"title": @"Blog", @"imageName" :@"wordpress"},
            @{ @"title": @"Tweets", @"imageName" :@"twitter"},
            @{ @"title": @"GitHub", @"imageName" :@"github"},
            @{ @"title": @"Events", @"imageName" :@"eventbrite-menu"},
    ];
}

- (void)configureTableView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    XBMenuCell *menuCell = [self.tableView dequeueReusableCellWithIdentifier:@"XBMenu"];

    if (!menuCell) {
        // fix for rdar://11549999 (registerNib… fails on iOS 5 if VoiceOver is enabled)
        menuCell = [[[NSBundle mainBundle] loadNibNamed:@"XBMenuCell" owner:self options:nil] objectAtIndex:0];
    }
    menuCell.accessoryType = UITableViewCellAccessoryNone;
    NSDictionary *tableItem = [self.dataSource objectAtIndex:(NSUInteger) indexPath.row];
    menuCell.titleLabel.text = [tableItem objectForKey:@"title"];
    menuCell.imageView.image = [UIImage imageNamed:[tableItem objectForKey:@"imageName"]];

    return menuCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.tableView.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *identifier = [self.viewIdentifiers valueForKey:[NSNumber asString:indexPath.row]];
    [self revealViewControllerWithIdentifier: identifier];
}

@end
