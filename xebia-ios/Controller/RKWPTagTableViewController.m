//
//  RKWPCategoryTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <RestKit/UI.h>
#import "RKWPCategory.h"
#import "RKWPTag.h"
#import "RKWPTagTableViewController.h"
#import "RKWPCategoryTableViewController.h"
#import "RKWPLoadingView.h"


@interface RKWPTagTableViewController ()
@property (nonatomic, strong) RKFetchedResultsTableController *tableController;
@end

@implementation RKWPTagTableViewController

@synthesize tableController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /**
     Configure the RestKit table controller to drive our view
     */
    self.tableController = [[RKObjectManager sharedManager] fetchedResultsTableControllerForTableViewController:self];
    self.tableController.autoRefreshFromNetwork = YES;
    self.tableController.pullToRefreshEnabled = YES;
    self.tableController.resourcePath = @"/get_tag_index/";
    self.tableController.variableHeightRows = YES;
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    self.tableController.sortDescriptors = [NSArray arrayWithObject:descriptor];
    
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
    RKWPLoadingView *loadingView = [[RKWPLoadingView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    loadingView.center = self.tableView.center;
    self.tableController.loadingView = loadingView;
    
    /**
     Setup some images for various table states
     */
    self.tableController.imageForOffline = [UIImage imageNamed:@"offline.png"];
    self.tableController.imageForError = [UIImage imageNamed:@"error.png"];
    self.tableController.imageForEmpty = [UIImage imageNamed:@"empty.png"];
    
    /**
     Configure our RKGHIssue -> UITableViewCell mappings. When RestKit loads the
     remote resource collection, the JSON payload will be object mapped into local
     RKGHIssue instances on a background thread. Once the payload has been processed,
     the table controller will object map the RKGHIssue instances into table cells and 
     render the tableView.
     */
    RKTableViewCellMapping *cellMapping = [RKTableViewCellMapping cellMapping];
    cellMapping.cellClassName = @"RKWPTagCell";
    cellMapping.reuseIdentifier = @"RKWPTag";
//    cellMapping.rowHeight = 50.0;
    [cellMapping mapKeyPath:@"capitalizedTitle" toAttribute:@"titleLabel.text"];
    [cellMapping mapKeyPath:@"description_" toAttribute:@"descriptionLabel.text"];
    [cellMapping mapKeyPath:@"postCount" toAttribute:@"itemCount"];
    
    [tableController mapObjectsWithClass:[RKWPTag class] toTableCellsWithMapping:cellMapping];
    
    /**
     Use a custom Nib to draw our table cells for RKGHIssue objects
     */
    [self.tableView registerNib:[UINib nibWithNibName:@"RKWPTagCell" bundle:nil] forCellReuseIdentifier:@"RKWPTag"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /**
     Load the table view!
     */
    [tableController loadTable];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDetail"]) {        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        RKWPTag *tag = [self.tableController objectForRowAtIndexPath:indexPath];
        [[segue destinationViewController] setTag:tag];
    }
}

@end