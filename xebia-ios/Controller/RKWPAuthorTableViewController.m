//
//  RKWPAuthorTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <RestKit/UI.h>
#import "RKWPAuthor.h"
#import "RKWPAuthorTableViewController.h"
#import "RKXBLoadingView.h"
#import "RKWPAuthorCell.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"

@interface RKWPAuthorTableViewController ()
@property (nonatomic, strong) RKFetchedResultsTableController *tableController;
@end

@implementation RKWPAuthorTableViewController

UIImage* defaultAvatarImage;

@synthesize tableController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Authors";

    defaultAvatarImage = [UIImage imageNamed:@"avatar_placeholder"];
    
    /**
     Configure the RestKit table controller to drive our view
     */
    self.tableController = [[RKObjectManager sharedManager] fetchedResultsTableControllerForTableViewController:self];
    self.tableController.delegate = self;
    self.tableController.sectionNameKeyPath = @"uppercaseFirstLetterOfName";

    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    self.tableController.fetchRequest.sortDescriptors = [NSArray arrayWithObject:descriptor];
  
    self.tableController.showsSectionIndexTitles = FALSE;
    self.tableController.autoRefreshFromNetwork = YES;
    self.tableController.pullToRefreshEnabled = YES;
    self.tableController.resourcePath = @"/wordpress/get_author_index/";
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
    RKXBLoadingView *loadingView = [[RKXBLoadingView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    loadingView.center = self.tableView.center;
    self.tableController.loadingView = loadingView;
    
    /**
     Setup some images for various table states
     */
    self.tableController.imageForOffline = [UIImage imageNamed:@"offline.png"];
    self.tableController.imageForError = [UIImage imageNamed:@"error.png"];
    self.tableController.imageForEmpty = [UIImage imageNamed:@"empty.png"];

    RKTableViewCellMapping *cellMapping = [RKTableViewCellMapping cellMapping];
    cellMapping.cellClassName = @"RKWPAuthorCell";
    cellMapping.reuseIdentifier = @"RKWPAuthor";
//    cellMapping.rowHeight = 100.0;
    [cellMapping mapKeyPath:@"name" toAttribute:@"titleLabel.text"];
    [cellMapping mapKeyPath:@"identifier" toAttribute:@"identifier"];
     
    [tableController mapObjectsWithClass:[RKWPAuthor class] toTableCellsWithMapping:cellMapping];
    
    /**
     Use a custom Nib to draw our table cells for RKGHIssue objects
     */
    [self.tableView registerNib:[UINib nibWithNibName:@"RKWPAuthorCell" bundle:nil] forCellReuseIdentifier:@"RKWPAuthor"];
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
    RKWPAuthor *author = object;
    RKWPAuthorCell *authorCell = (RKWPAuthorCell *)cell;
    [authorCell.imageView setImageWithURL:[author avatarImageUrl] placeholderImage:defaultAvatarImage];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if ([segue.identifier isEqualToString:@"showDetail"]) {        
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        RKWPAuthor *author = [self.tableController objectForRowAtIndexPath:indexPath];
//        [[segue destinationViewController] setAuthor:author];
//    }
}

@end