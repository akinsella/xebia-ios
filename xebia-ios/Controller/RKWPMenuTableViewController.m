//
//  RKWPMenuTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 19/08/12.
//
//

#import "RKWPMenuTableViewController.h"

#import "RKWPAuthorTableViewController.h"
#import "RKWPCategoryTableViewController.h"
#import "RKWPTagTableViewController.h"
#import "RKWPTagTableViewController.h"
#import "UIImage+RKWPAdditions.h"
#import "UISearchBar+RKWPAdditions.h"
#import "RevealController.h"
#import "UIColor+RKWPAdditions.h"


// Enum for row indices
enum {
    RKWPMenuTableViewRowAuthors = 0,
    RKWPMenuTableViewRowTags,
    RKWPMenuTableViewRowCategories,
};

@interface RKWPMenuTableViewController ()

/**
 A RestKit table controller that serves as the delegate and data source
 for the receiver's table view.
 */
@property (nonatomic, strong) RKTableController *tableController;

@end

@implementation RKWPMenuTableViewController

@synthesize tableController;

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImage* titleImage = [UIImage imageNamed:@"Xebia-Logo"];
    UIImageView* titleImageView = [[UIImageView alloc] initWithImage:titleImage];
    
    self.navigationItem.titleView = titleImageView;

    NSLog(@"%f, %f, %f, %f", self.navigationItem.titleView.bounds.origin.x, self.navigationItem.titleView.bounds.origin.y, self.navigationItem.titleView.bounds.size.width, self.navigationItem.titleView.bounds.size.height);
    
    
    //disable tableview separator
    [self.tableView setSeparatorStyle: UITableViewCellSeparatorStyleNone];
    
    // set background of tableview
    UIView* backgrounView = [[UIView alloc] initWithFrame: self.tableView.bounds];
    [backgrounView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"NSTexturedFullScreenBackgroundColor"]]];
    [self.tableView setBackgroundView:backgrounView];

    self.tableController = [RKTableController tableControllerForTableViewController:self];
    
    CGSize scaledSize = CGSizeMake(24.0,20.0);
    
    NSArray *tableItems = [[NSArray alloc] initWithObjects:
                           [RKTableItem tableItemWithText:@"Authors"
                                               detailText:@""
                                                    image:[UIImage scale:[UIImage imageNamed:@"112-group"]
                                                                  toSize:scaledSize]],
                           [RKTableItem tableItemWithText:@"Tags"
                                               detailText:@""
                                                    image:[UIImage scale:[UIImage imageNamed:@"15-tags"]
                                                                  toSize:scaledSize]],
                           [RKTableItem tableItemWithText:@"Categories"
                                               detailText:@""
                                                    image:[UIImage scale:[UIImage imageNamed:@"44-shoebox"]
                                                                  toSize:scaledSize]],
                           nil];
    
    RKTableViewCellMapping *tableCellMapping = [RKTableViewCellMapping defaultCellMapping];

    tableCellMapping.cellClassName = @"RKWPMenuCell";
    tableCellMapping.reuseIdentifier = @"RKWPMenu";

    [tableCellMapping mapKeyPath:@"text" toAttribute:@"titleLabel.text"];
    
    tableCellMapping.accessoryType = UITableViewCellAccessoryNone;
    
    tableCellMapping.onSelectCellForObjectAtIndexPath = ^(UITableViewCell *cell, id object, NSIndexPath* indexPath) {
        
        // Grab a handle to the reveal controller, as if you'd do with a navigtion controller via self.navigationController.
        
        
        RevealController *revealController = nil;
        
        if ([self.parentViewController isKindOfClass:[RevealController class]]) {
            revealController = (RevealController *)self.parentViewController;
        }
        else if ([self.parentViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navigationController = (UINavigationController *)self.parentViewController;
            revealController = (RevealController *)navigationController.parentViewController;
        }
        
        switch (indexPath.row) {
            case RKWPMenuTableViewRowAuthors: {
//                NSLog(@"%@", ((UINavigationController *)revealController.frontViewController).topViewController);
                if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[RKWPAuthorTableViewController class]])
                {
                    RKWPAuthorTableViewController *authorTableViewController = [[RKWPAuthorTableViewController alloc] init];
//                    RKWPAuthorTableViewController *authorTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"authors"];

                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:authorTableViewController];
                    
                    navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
                    navigationController.navigationBar.tintColor = (UIColor *)[UIColor colorWithHex: @"#1D0214" alpha:1.0];
    
                    
                    [revealController setFrontViewController:navigationController animated:NO];
                }
                else {
                    [revealController revealToggle:self];
                }
                
                break;
            }
                
            case RKWPMenuTableViewRowCategories: {
                
                if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[RKWPCategoryTableViewController class]])
                {
                    RKWPCategoryTableViewController *categoryTableViewController = [[RKWPCategoryTableViewController alloc] init];
//                    RKWPCategoryTableViewController *categoryTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"categories"];
                    
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:categoryTableViewController];

                    navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
                    navigationController.navigationBar.tintColor = (UIColor *)[UIColor colorWithHex: @"#1D0214" alpha:1.0];

                    [revealController setFrontViewController:navigationController animated:NO];
                }
                else {
                    [revealController revealToggle:self];
                }
                
                break;
            }
                
            case RKWPMenuTableViewRowTags: {

                if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[RKWPTagTableViewController class]])
                {
                    RKWPTagTableViewController *tagsTableViewController = [[RKWPTagTableViewController alloc] init];
//                    RKWPTagTableViewController *tagsTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"tags"];
                    
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tagsTableViewController];

                    navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
                    navigationController.navigationBar.tintColor = (UIColor *)[UIColor colorWithHex: @"#1D0214" alpha:1.0];

                    
                    [revealController setFrontViewController:navigationController animated:NO];
                }
                else {
                    [revealController revealToggle:self];
                }

                break;
            }
                
            default: {
                [NSException raise:NSInternalInconsistencyException format:@"Unknown row index selected: %d", indexPath.row];
                break;
            }
        }
    };

    [self.tableController loadTableItems:tableItems withMapping:tableCellMapping];
}

@end
