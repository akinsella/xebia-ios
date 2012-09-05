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
#import "RKWPCategoryTableViewController.h"
#import "RKXBLoadingView.h"


@interface RKWPCategoryTableViewController ()
@property (nonatomic, strong) RKFetchedResultsTableController *tableController;
@end

@implementation RKWPCategoryTableViewController

@synthesize tableController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Categories";
 
    if ([self.navigationController.parentViewController respondsToSelector:@selector(revealGesture:)] && [self.navigationController.parentViewController respondsToSelector:@selector(revealToggle:)])
	{
		UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
		[self.navigationController.navigationBar addGestureRecognizer:navigationBarPanGestureRecognizer];

		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self.navigationController.parentViewController action:@selector(revealToggle:)];
	}
   
    self.tableController = [[RKObjectManager sharedManager] fetchedResultsTableControllerForTableViewController:self];
    self.tableController.autoRefreshFromNetwork = YES;
    self.tableController.pullToRefreshEnabled = YES;
    self.tableController.resourcePath = @"/wordpress/get_category_index/";
    self.tableController.variableHeightRows = YES;
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    self.tableController.sortDescriptors = [NSArray arrayWithObject:descriptor];
 
    NSBundle *restKitResources = [NSBundle restKitResourcesBundle];
    UIImage *arrowImage = [restKitResources imageWithContentsOfResource:@"blueArrow" withExtension:@"png"];
    [[RKRefreshTriggerView appearance] setTitleFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13]];
    [[RKRefreshTriggerView appearance] setLastUpdatedFont:[UIFont fontWithName:@"HelveticaNeue" size:11]];
    [[RKRefreshTriggerView appearance] setArrowImage:arrowImage];
    
    RKXBLoadingView *loadingView = [[RKXBLoadingView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    loadingView.center = self.tableView.center;
    self.tableController.loadingView = loadingView;
    
    self.tableController.imageForOffline = [UIImage imageNamed:@"offline.png"];
    self.tableController.imageForError = [UIImage imageNamed:@"error.png"];
    self.tableController.imageForEmpty = [UIImage imageNamed:@"empty.png"];

    RKTableViewCellMapping *cellMapping = [RKTableViewCellMapping cellMapping];
    cellMapping.cellClassName = @"RKWPCategoryCell";
    cellMapping.reuseIdentifier = @"RKWPCategory";
    [cellMapping mapKeyPath:@"title" toAttribute:@"titleLabel.text"];
    [cellMapping mapKeyPath:@"postCount" toAttribute:@"itemCount"];
    
    [tableController mapObjectsWithClass:[RKWPCategory class] toTableCellsWithMapping:cellMapping];

    [self.tableView registerNib:[UINib nibWithNibName:@"RKWPCategoryCell" bundle:nil] forCellReuseIdentifier:@"RKWPCategory"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [tableController loadTable];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDetail"]) {        
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        RKWPCategory *category = [self.tableController objectForRowAtIndexPath:indexPath];
//        [[segue destinationViewController] setCategory:category];
    }
}

@end