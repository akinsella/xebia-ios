//
//  WPMenuTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 19/08/12.
//
//

#import "XBMenuTableViewController.h"

#import "WPTabBarController.h"
#import "UIImage+XBAdditions.h"
#import "UISearchBar+XBAdditions.h"
#import "XBRevealController.h"
#import "UIColor+XBAdditions.h"
#import "RKTableSection.h"
#import "TTTweetTableViewController.h"
#import "XBHomeController.h"
#import "GHRepositoryTableViewController.h"
#import "UINavigationController+XBAdditions.h"
#import "UInavigationBar+XBAdditions.h"
#import "UIViewController+XBAdditions.h"

// Enum for row indices
enum {
    WPMenuHome = 0,
    WPMenuWordpress,
    WPMenuTwitter,
    WPMenuGithub
};

@interface XBMenuTableViewController ()

/**
 A RestKit table controller that serves as the delegate and data source
 for the receiver's table view.
 */
@property (nonatomic, strong) RKTableController *tableController;

@end

@implementation XBMenuTableViewController

NSMutableDictionary *viewControllers;
NSMutableDictionary *viewIdentifiers;
XBRevealController *revealController;
UINavigationController *rearNavigationController;

@synthesize tableController;

-(id)init {
    self = [super init];
    
    if (self) {
        rearNavigationController = [[UINavigationController alloc] initWithRootViewController:self navBarCustomized:YES];
        
        UIViewController *homeController = [self instantiateControllerWithIdentifier:@"home"];

        NSLog(@"homeController.navigationController: %@",  homeController.navigationController);
       
        revealController = [[XBRevealController alloc] initWithFrontViewController: homeController.navigationController
                                                              rearViewController:rearNavigationController];

        viewControllers = [[NSMutableDictionary alloc] init];
        viewIdentifiers = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                           @"home",  [[NSNumber numberWithInt: WPMenuHome] description],
                           @"tbBlog", [[NSNumber numberWithInt: WPMenuWordpress] description],
                           @"tweets", [[NSNumber numberWithInt: WPMenuTwitter] description],
                           @"tbGithub", [[NSNumber numberWithInt: WPMenuGithub] description],
                           nil];
        
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Xebia-Logo"]];
        
        [self.tableView setSeparatorStyle: UITableViewCellSeparatorStyleNone];
        
        [self customizeBackground];
        
        self.tableController = [RKTableController tableControllerForTableViewController:self];
        
        NSArray *tableItems = [[NSArray alloc] initWithObjects:
                               [RKTableItem tableItemWithText:@"Home"
                                                   detailText:@""
                                                        image:[UIImage imageNamed:@"home"]],
                               [RKTableItem tableItemWithText:@"Blog"
                                                   detailText:@""
                                                        image:[UIImage imageNamed:@"wordpress"]],
                               [RKTableItem tableItemWithText:@"Tweets"
                                                   detailText:@""
                                                        image:[UIImage imageNamed:@"twitter"]],
                               [RKTableItem tableItemWithText:@"Github"
                                                   detailText:@""
                                                        image:[UIImage imageNamed:@"github"]],
                               nil];
        
        RKTableViewCellMapping *tableCellMapping = [RKTableViewCellMapping defaultCellMapping];
        
        tableCellMapping.cellClassName = @"XBMenuCell";
        tableCellMapping.reuseIdentifier = @"XBMenu";
        
        [tableCellMapping mapKeyPath:@"text" toAttribute:@"titleLabel.text"];
        
        tableCellMapping.accessoryType = UITableViewCellAccessoryNone;
        
        tableCellMapping.onSelectCellForObjectAtIndexPath = ^(UITableViewCell *cell, id object, NSIndexPath* indexPath) {
            NSString *identifier = [viewIdentifiers valueForKey:[[NSNumber numberWithInt: indexPath.row] description]];
            [self revealViewControllerWithIdentifier: identifier];
        };
        
        [self.tableController loadTableItems:tableItems withMapping: tableCellMapping];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}


-(BOOL)currentViewIsViewControllerWithIdentifier:(NSString *)identifier revealController: (XBRevealController *)revealController {
    return
        [revealController.frontViewController isKindOfClass:[UINavigationController class]] &&
        ((UINavigationController *)revealController.frontViewController).topViewController == [viewControllers valueForKey:identifier];
}

-(XBRevealController *)revealController {
    return revealController;
}

-(void)revealViewControllerWithIdentifier:(NSString *)identifier {

    if ([self currentViewIsViewControllerWithIdentifier: identifier revealController:revealController]) {
        [revealController revealToggle:self];
    }
    else {
        UIViewController * viewController = [self instantiateControllerWithIdentifier: identifier];
        [revealController setFrontViewController:viewController.navigationController animated:NO];
    }

}

-(UIViewController *)instantiateControllerWithIdentifier: (NSString *)identifier {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:identifier];
    [[UINavigationController alloc] initWithRootViewController:vc navBarCustomized:YES];
    
    [viewControllers setValue:vc forKey:identifier];
    
    return vc;
}

-(void)customizeBackground {
    UIView* backgrounView = [[UIView alloc] initWithFrame: self.tableView.bounds];
    [backgrounView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"NSTexturedFullScreenBackgroundColor"]]];
    [self.tableView setBackgroundView:backgrounView];
}

@end
