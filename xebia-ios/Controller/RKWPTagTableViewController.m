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

    self.tableController = [[RKObjectManager sharedManager] fetchedResultsTableControllerForTableViewController:self];
    self.tableController.autoRefreshFromNetwork = YES;
    self.tableController.pullToRefreshEnabled = YES;
    self.tableController.resourcePath = @"/get_tag_index/";
    self.tableController.variableHeightRows = YES;
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    self.tableController.sortDescriptors = [NSArray arrayWithObject:descriptor];
    
    NSBundle *restKitResources = [NSBundle restKitResourcesBundle];
    UIImage *arrowImage = [restKitResources imageWithContentsOfResource:@"blueArrow" withExtension:@"png"];
    [[RKRefreshTriggerView appearance] setTitleFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13]];
    [[RKRefreshTriggerView appearance] setLastUpdatedFont:[UIFont fontWithName:@"HelveticaNeue" size:11]];
    [[RKRefreshTriggerView appearance] setArrowImage:arrowImage];
    
    RKWPLoadingView *loadingView = [[RKWPLoadingView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    loadingView.center = self.tableView.center;
    self.tableController.loadingView = loadingView;
    
    self.tableController.imageForOffline = [UIImage imageNamed:@"offline.png"];
    self.tableController.imageForError = [UIImage imageNamed:@"error.png"];
    self.tableController.imageForEmpty = [UIImage imageNamed:@"empty.png"];

    RKTableViewCellMapping *cellMapping = [RKTableViewCellMapping cellMapping];
    cellMapping.cellClassName = @"RKWPTagCell";
    cellMapping.reuseIdentifier = @"RKWPTag";
//    cellMapping.rowHeight = 50.0;
    [cellMapping mapKeyPath:@"capitalizedTitle" toAttribute:@"titleLabel.text"];
    [cellMapping mapKeyPath:@"description_" toAttribute:@"descriptionLabel.text"];
    [cellMapping mapKeyPath:@"postCount" toAttribute:@"itemCount"];
    
    [tableController mapObjectsWithClass:[RKWPTag class] toTableCellsWithMapping:cellMapping];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RKWPTagCell" bundle:nil] forCellReuseIdentifier:@"RKWPTag"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [tableController loadTable];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDetail"]) {        
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        RKWPTag *tag = [self.tableController objectForRowAtIndexPath:indexPath];
//        [[segue destinationViewController] setTag:tag];
    }
}

@end