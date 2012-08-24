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

@synthesize tableController, searchBar;

- (void)viewDidLoad
{
    [super viewDidLoad];

//    [searchBar setSearchFieldBackgroundImage:[UIImage ] forState:<#(UIControlState)#>]
    
//    [scopeBar setSegmentedControlStyle:UISegmentedControlStyleBar];
//    [scopeBar setTintColor: UIColorFromRGB(0x990066)];
    
//    UITextField *searchField = [searchbar valueForKey:@"_searchField"];
//    field.textColor = [UIColor redColor]; //You can put any color here.
    
    [searchBar removeBackground];
//    [searchBar setBackgroundColor: [UIColor redColor]];

    self.tableController = [RKTableController tableControllerForTableViewController:self];
    
    CGSize scaledSize = CGSizeMake(24.0,24.0);
    
    NSArray *tableItems = [[NSArray alloc] initWithObjects:
                           [RKTableItem tableItemWithText:@"Authors"
                                               detailText:@""
                                                    image:[UIImage scale:[UIImage imageNamed:@"112-group.png"]
                                                                  toSize:scaledSize]],
                           [RKTableItem tableItemWithText:@"Tags"
                                               detailText:@""
                                                    image:[UIImage scale:[UIImage imageNamed:@"15-tags.png"]
                                                                  toSize:scaledSize]],
                           [RKTableItem tableItemWithText:@"Categories"
                                               detailText:@""
                                                    image:[UIImage scale:[UIImage imageNamed:@"44-shoebox.png"]
                                                                  toSize:scaledSize]],
                           nil];
    
    RKTableViewCellMapping *tableCellMapping = [RKTableViewCellMapping defaultCellMapping];

    tableCellMapping.cellClassName = @"RKWPMenuCell";
    tableCellMapping.reuseIdentifier = @"RKWPMenu";

    [tableCellMapping mapKeyPath:@"text" toAttribute:@"titleLabel.text"];
    
    tableCellMapping.accessoryType = UITableViewCellAccessoryNone;
    tableCellMapping.onSelectCellForObjectAtIndexPath = ^(UITableViewCell *cell, id object, NSIndexPath* indexPath) {
        
        // Grab a handle to the reveal controller, as if you'd do with a navigtion controller via self.navigationController.
        RevealController *revealController = [self.parentViewController isKindOfClass:[RevealController class]] ?
            (RevealController *)self.parentViewController : nil;
        
        switch (indexPath.row) {
            case RKWPMenuTableViewRowAuthors: {
                
                if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[RKWPAuthorTableViewController class]])
                {
                    RKWPAuthorTableViewController *authorTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"authors"];
                    UINavigationController *navigationController = ((UINavigationController *)revealController.frontViewController);
                    
                    [navigationController pushViewController:authorTableViewController animated:YES];
                    [revealController setFrontViewController:navigationController animated:NO];
                    
                }
                // Seems the user attempts to 'switch' to exactly the same controller he came from!
                else
                {
                    [revealController revealToggle:self];
                }
                
                break;
            }
                
            case RKWPMenuTableViewRowCategories: {
                
                if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[RKWPCategoryTableViewController class]])
                {
                    RKWPCategoryTableViewController *categoryTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"categories"];
                    UINavigationController *navigationController = ((UINavigationController *)revealController.frontViewController);
                    
                    [navigationController pushViewController:categoryTableViewController animated:YES];
                    [revealController setFrontViewController:navigationController animated:NO];
                    
                }
                // Seems the user attempts to 'switch' to exactly the same controller he came from!
                else
                {
                    [revealController revealToggle:self];
                }
                
                break;
            }
                
            case RKWPMenuTableViewRowTags: {

                if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[RKWPTagTableViewController class]])
                {
                    RKWPTagTableViewController *tagsTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"tags"];
                    UINavigationController *navigationController = ((UINavigationController *)revealController.frontViewController);
                    
                    [navigationController pushViewController:tagsTableViewController animated:YES];
                    [revealController setFrontViewController:navigationController animated:NO];
                    
                }
                // Seems the user attempts to 'switch' to exactly the same controller he came from!
                else
                {
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
