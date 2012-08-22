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
        switch (indexPath.row) {
            case RKWPMenuTableViewRowAuthors: {
                RKWPAuthorTableViewController *authorTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"authors"];
                [self.navigationController pushViewController:authorTableViewController animated:YES];
                break;
            }
                
            case RKWPMenuTableViewRowCategories: {
                RKWPCategoryTableViewController *categoryTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"categories"];
                [self.navigationController pushViewController:categoryTableViewController animated:YES];
                break;
            }
                
            case RKWPMenuTableViewRowTags: {
                RKWPTagTableViewController *tagsTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"tags"];
                [self.navigationController pushViewController:tagsTableViewController animated:YES];
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
