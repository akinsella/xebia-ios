//
//  GHUserTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <RestKit/UI.h>
#import "GHUser.h"
#import "GHUserTableViewController.h"
#import "XBLoadingView.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "GHUserCell.h"
#import "UIImage+XBAdditions.h"
#import "UIImageView+WebCache.h"

#define FONT_SIZE 13.0f
#define CELL_CONTENT_WIDTH 252.0f
#define CELL_MIN_HEIGHT 44.0f
#define CELL_BASE_HEIGHT 28.0f
#define CELL_MAX_HEIGHT 1000.0f

@interface GHUserTableViewController ()
@property (nonatomic, strong) RKFetchedResultsTableController *tableController;
@end

@implementation GHUserTableViewController

UIImage* defaultAvatarImage;

@synthesize tableController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Users";
    
    defaultAvatarImage = [UIImage imageNamed:@"github-gravatar-placeholder"];
    
    /**
     Configure the RestKit table controller to drive our view
     */
    self.tableController = [[RKObjectManager sharedManager] fetchedResultsTableControllerForTableViewController:self];
    self.tableController.cacheName = @"Users";
    self.tableController.delegate = self;

    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"login" ascending:YES];
    self.tableController.fetchRequest.sortDescriptors = [NSArray arrayWithObject:descriptor];
  
    self.tableController.showsSectionIndexTitles = FALSE;
    self.tableController.autoRefreshFromNetwork = YES;
    self.tableController.pullToRefreshEnabled = YES;
    self.tableController.resourcePath = @"/github/orgs/xebia-france/public_members";
    self.tableController.variableHeightRows = YES;
    
    
    /**
     Configure the Pull to Refresh View
     */
    NSBundle *restKitResources = [NSBundle restKitResourcesBundle];
    UIImage *arrowImage = [restKitResources imageWithContentsOfResource:@"blueArrow" withExtension:@"png"];
    [[RKRefreshTriggerView appearance] setTitleFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13]];
    [[RKRefreshTriggerView appearance] setLastUpdatedFont:[UIFont fontWithName:@"HelveticaNeue" size:11]];
    [[RKRefreshTriggerView appearance] setArrowImage:arrowImage];
    
    /**
     Configure a basic loading view
     */
    XBLoadingView *loadingView = [[XBLoadingView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    loadingView.center = self.tableView.center;
    self.tableController.loadingView = loadingView;
    
    /**
     Setup some images for various table states
     */
    self.tableController.imageForOffline = [UIImage imageNamed:@"offline.png"];
    self.tableController.imageForError = [UIImage imageNamed:@"error.png"];
    self.tableController.imageForEmpty = [UIImage imageNamed:@"empty.png"];

    RKTableViewCellMapping *cellMapping = [RKTableViewCellMapping cellMapping];
    cellMapping.cellClassName = @"GHUserCell";
    cellMapping.reuseIdentifier = @"GHUser";
//    cellMapping.rowHeight = 100.0;
    [cellMapping mapKeyPath:@"name" toAttribute:@"titleLabel.text"];
    [cellMapping mapKeyPath:@"description_" toAttribute:@"descriptionLabel.text"];
    [cellMapping mapKeyPath:@"identifier" toAttribute:@"identifier"];
     
    cellMapping.heightOfCellForObjectAtIndexPath = ^ CGFloat(id object, NSIndexPath* indexPath) {
    
        GHUser *user = object;
        
        //        NSLog(@"----------------------------------------------------------------------");
        //        NSLog(@"User name: %@", user.name);
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH, CELL_MAX_HEIGHT);
        //        NSLog(@"Constraint[width: %f, height: %f]", constraint.width, constraint.height);
        
        CGSize size = [user.description_ sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE]
                                          constrainedToSize:constraint
                                              lineBreakMode:UILineBreakModeWordWrap];
        
        //        NSLog(@"Size[width: %f, height: %f]", size.width, size.height);
        
        CGFloat height = MAX(CELL_BASE_HEIGHT + size.height, CELL_MIN_HEIGHT);
        //        NSLog(@"Height: %f", height);
        
        return height;
    };
    
    [tableController mapObjectsWithClass:[GHUser class] toTableCellsWithMapping:cellMapping];
    
    /**
     Use a custom Nib to draw our table cells for WPe objects
     */
    [self.tableView registerNib:[UINib nibWithNibName:@"GHUserCell" bundle:nil] forCellReuseIdentifier:@"GHUser"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /**
     Load the table view!
     */
    [tableController loadTable];
}

- (void)tableController:(RKAbstractTableController *)tableController willDisplayCell:(UITableViewCell *)cell forObject:(id)object atIndexPath:(NSIndexPath *)indexPath;
{
    GHUser *user = object;
    GHUserCell *userCell = (GHUserCell *)cell;
    [userCell.imageView setImageWithURL:[user avatarImageUrl] placeholderImage:defaultAvatarImage];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if ([segue.identifier isEqualToString:@"showDetail"]) {        
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        WPAuthor *author = [self.tableController objectForRowAtIndexPath:indexPath];
//        [[segue destinationViewController] setAuthor:author];
//    }
}

@end