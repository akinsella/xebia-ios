//
//  XBMainViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 19/08/12.
//
//

#import "XBMainViewController.h"

#import "XBRevealController.h"
#import "UINavigationController+XBAdditions.h"
#import "NSNumber+XBAdditions.h"
#import "RKTableItem+XKAdditions.h"
#import "UIImageView+XBAdditions.h"
#import "WPPostTableViewController.h"

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

@end

@implementation XBMainViewController {
    XBRevealController *_revealController;
    NSMutableDictionary *_viewIdentifiers;
    XBViewControllerManager *_viewControllerManager;
    UINavigationController *_rearNavigationController;
    RKTableViewCellMapping *_tableCellMapping;
    NSArray *_tableItems;
}

@synthesize tableController;
@synthesize revealController = _revealController;

- (id)initWithViewControllerManager:(XBViewControllerManager *)viewControllerManager {
    self = [super init];

    if (self) {
        _viewControllerManager = viewControllerManager;
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
    [self.tableController loadTableItems:_tableItems withMapping: _tableCellMapping];
    [_tableItems release];
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
    [backgrounView release];
}


//-----------------------------------------------------------------------
// Reveal Controller initialization
//-----------------------------------------------------------------------

- (void)initRevealController {
    _rearNavigationController = [[UINavigationController alloc] initWithRootViewController:self navBarCustomized:YES];
    UIViewController *homeController = [_viewControllerManager getOrCreateControllerWithIdentifier:@"home"];
    [[[UINavigationController alloc] initWithRootViewController:homeController navBarCustomized:YES] autorelease];

    _revealController = [[XBRevealController alloc] initWithFrontViewController: homeController.navigationController
                                                            rearViewController:_rearNavigationController];
}


- (void)revealViewController:(UIViewController *)viewController {
    UINavigationController *frontViewController = (UINavigationController *) _revealController.frontViewController;
    [frontViewController pushViewController:viewController animated:true];
}


-(void)revealViewControllerWithIdentifier:(NSString *)identifier {
    if ([self currentViewIsViewControllerWithIdentifier: identifier]) {
        [_revealController revealToggle:self];
    }
    else {
        UIViewController * viewController = [_viewControllerManager getOrCreateControllerWithIdentifier: identifier];
        [_revealController setFrontViewController:viewController.navigationController animated:NO];
    }
}

-(BOOL)currentViewIsViewControllerWithIdentifier:(NSString *)identifier {
    return ((UINavigationController *)_revealController.frontViewController).topViewController == [_viewControllerManager getOrCreateControllerWithIdentifier:identifier];
}

//-----------------------------------------------------------------------
// Table content initialization
//-----------------------------------------------------------------------

- (void)initViewIdentifiers {
    _viewIdentifiers = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
            @"home", [NSNumber asString:XBMenuHome],
            @"tbBlog", [NSNumber asString:XBMenuWordpress],
            @"tweets", [NSNumber asString:XBMenuTwitter],
            @"tbGithub", [NSNumber asString:XBMenuGithub],
            @"events", [NSNumber asString:XBMenuEvent],
            nil];
}

- (void)initTableItems {
    _tableItems = [[NSArray alloc] initWithObjects:
       [RKTableItem tableItemWithText:@"Home" imageNamed:@"home"],
       [RKTableItem tableItemWithText:@"Blog" imageNamed:@"wordpress"],
       [RKTableItem tableItemWithText:@"Tweets" imageNamed:@"twitter"],
       [RKTableItem tableItemWithText:@"Github"  imageNamed:@"github"],
       [RKTableItem tableItemWithText:@"Events"  imageNamed:@"eventbrite"],
       nil];
}

- (void)initCellMapping {
    _tableCellMapping = [RKTableViewCellMapping defaultCellMapping];

    _tableCellMapping.cellClassName = @"XBMenuCell";
    _tableCellMapping.reuseIdentifier = @"XBMenu";
    _tableCellMapping.accessoryType = UITableViewCellAccessoryNone;

    [_tableCellMapping mapKeyPath:@"text" toAttribute:@"titleLabel.text"];

    _tableCellMapping.onSelectCellForObjectAtIndexPath = ^(UITableViewCell *cell, id object, NSIndexPath* indexPath) {
        NSString *identifier = [_viewIdentifiers valueForKey:[NSNumber asString:indexPath.row]];
        [self revealViewControllerWithIdentifier: identifier];
    };
}

- (void)dealloc {
    [_revealController release];
    [_rearNavigationController release];
    [_viewIdentifiers release];
    [_tableItems release];
    [super dealloc];
}

@end
