//
//  RKWPMenuTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 19/08/12.
//
//

#import "RKXBMenuTableViewController.h"

#import "BlogController.h"
#import "UIImage+RKWPAdditions.h"
#import "UISearchBar+RKWPAdditions.h"
#import "RevealController.h"
#import "UIColor+RKWPAdditions.h"
#import "RKTableSection.h"


// Enum for row indices
enum {
    RKWPMenuHome = 0,
    RKWPMenuWordpress,
    RKWPMenuTwitter,
    RKWPMenuGithub
};

@interface RKXBMenuTableViewController ()

/**
 A RestKit table controller that serves as the delegate and data source
 for the receiver's table view.
 */
@property (nonatomic, strong) RKTableController *tableController;

@end

@implementation RKXBMenuTableViewController

@synthesize tableController;

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImage* titleImage = [UIImage imageNamed:@"Xebia-Logo"];
    UIImageView* titleImageView = [[UIImageView alloc] initWithImage:titleImage];
    
    self.navigationItem.titleView = titleImageView;

    //disable tableview separator
    [self.tableView setSeparatorStyle: UITableViewCellSeparatorStyleNone];
    
    // set background of tableview
    UIView* backgrounView = [[UIView alloc] initWithFrame: self.tableView.bounds];
    [backgrounView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"NSTexturedFullScreenBackgroundColor"]]];
    [self.tableView setBackgroundView:backgrounView];

    self.tableController = [RKTableController tableControllerForTableViewController:self];
    
//    CGSize scaledSize = CGSizeMake(24.0,20.0);
    
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

    tableCellMapping.cellClassName = @"RKWPMenuCell";
    tableCellMapping.reuseIdentifier = @"RKWPMenu";

    [tableCellMapping mapKeyPath:@"text" toAttribute:@"titleLabel.text"];
    
    tableCellMapping.accessoryType = UITableViewCellAccessoryNone;
    
    tableCellMapping.onSelectCellForObjectAtIndexPath = ^(UITableViewCell *cell, id object, NSIndexPath* indexPath) {

        RevealController *revealController = nil;
        
        if ([self.parentViewController isKindOfClass:[RevealController class]]) {
            revealController = (RevealController *)self.parentViewController;
        }
        else if ([self.parentViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navigationController = (UINavigationController *)self.parentViewController;
            revealController = (RevealController *)navigationController.parentViewController;
        }
        
        switch (indexPath.row) {
            case RKWPMenuHome: {
                if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[RKWPAuthorTableViewController class]])
                {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                    UIViewController *blogViewController = [storyboard instantiateViewControllerWithIdentifier:@"home"];
                    
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:blogViewController];
                    
                    navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
                    navigationController.navigationBar.tintColor = (UIColor *)[UIColor colorWithHex: @"#561D3F" alpha:1.0];
                    
                    [navigationController.navigationBar setBackgroundImage: [UIImage imageNamed:@"navigationBarBackgroundRetro"]];
                    
                    [revealController setFrontViewController:navigationController animated:NO];
                }
                else {
                    [revealController revealToggle:self];
                }
                
                break;
            }
            case RKWPMenuWordpress: {
                if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[BlogController class]])
                {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                    UIViewController *blogViewController = [storyboard instantiateViewControllerWithIdentifier:@"tbBlog"];

                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:blogViewController];
                    
                    navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
                    navigationController.navigationBar.tintColor = (UIColor *)[UIColor colorWithHex: @"#561D3F" alpha:1.0];

                    [navigationController.navigationBar setBackgroundImage: [UIImage imageNamed:@"navigationBarBackgroundRetro"]];

                    [revealController setFrontViewController:navigationController animated:NO];
                }
                else {
                    [revealController revealToggle:self];
                }
                
                break;
            }
                
            case RKWPMenuTwitter: {
                
                break;
            }
                
            case RKWPMenuGithub: {
                
                break;
            }
                 
            default: {
                [NSException raise:NSInternalInconsistencyException format:@"Unknown row index selected: %d", indexPath.row];
                break;
            }
        }
    };

    [self.tableController loadTableItems:tableItems withMapping: tableCellMapping];
}

@end
