//
//  WPTagTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <RestKit/UI.h>
#import "WPCategory.h"
#import "WPTag.h"
#import "WPTagTableViewController.h"
#import "WPCategoryTableViewController.h"
#import "XBLoadingView.h"
#import "UIColor+XBAdditions.h"
#import "WPPostTableViewController.h"
#import "WPPost.h"
#import "UIViewController+XBAdditions.h"
#import "XBMainViewController.h"


@interface WPTagTableViewController ()
@property (nonatomic, strong) RKTableController *tableController;
@end

@implementation WPTagTableViewController

@synthesize tableController;

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"Tags";
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [tableController loadTableFromResourcePath:@"/wordpress/get_tag_index/"];
}

- (void)configure {
    [self configureTableController];
    [self configureRefreshTriggerView];
    [self configureTableView];
}

- (void)configureTableController {
    self.tableController = [[RKObjectManager sharedManager] tableControllerForTableViewController:self];

    self.tableController.delegate = self;

    self.tableController.autoRefreshFromNetwork = YES;
    self.tableController.pullToRefreshEnabled = YES;
    self.tableController.variableHeightRows = YES;

    self.tableController.imageForOffline = [UIImage imageNamed:@"offline.png"];
    self.tableController.imageForError = [UIImage imageNamed:@"error.png"];
    self.tableController.imageForEmpty = [UIImage imageNamed:@"empty.png"];

    [tableController mapObjectsWithClass:[WPTag class] toTableCellsWithMapping:[self getCellMapping]];
}

- (void)configureRefreshTriggerView {
    NSBundle *restKitResources = [NSBundle restKitResourcesBundle];
    UIImage *arrowImage = [restKitResources imageWithContentsOfResource:@"blueArrow" withExtension:@"png"];
    [[RKRefreshTriggerView appearance] setTitleFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13]];
    [[RKRefreshTriggerView appearance] setLastUpdatedFont:[UIFont fontWithName:@"HelveticaNeue" size:11]];
    [[RKRefreshTriggerView appearance] setArrowImage:arrowImage];
}

- (RKTableViewCellMapping *)getCellMapping {
    RKTableViewCellMapping *cellMapping = [RKTableViewCellMapping cellMapping];

    cellMapping.cellClassName = @"WPTagCell";
    cellMapping.reuseIdentifier = @"WPTag";

    [cellMapping mapKeyPath:@"capitalizedTitle" toAttribute:@"titleLabel.text"];
    [cellMapping mapKeyPath:@"postCount" toAttribute:@"itemCount"];
    cellMapping.onSelectCellForObjectAtIndexPath = ^(UITableViewCell *cell, id object, NSIndexPath* indexPath) {
        WPTag *tag = [self.tableController objectForRowAtIndexPath:indexPath];
        NSLog(@"Tag selected: %@", tag);
        
        WPPostTableViewController *postTableViewController = [[WPPostTableViewController alloc] initWithPostType:TAG identifier:tag.identifier];
        [self.appDelegate.mainViewController revealViewController:postTableViewController];
        [postTableViewController release];
    };

    return cellMapping;
}

//- (void)tableController:(RKTableController *)tableController didLoadObjects:(NSArray *)objects inSection:(RKTableSection *)section {
//    NSLog(@"Loaded %d elements in section %@", [objects count], section);
//}
//
//- (void)tableController:(RKAbstractTableController *)tableController willLoadTableWithObjectLoader:(RKObjectLoader *)objectLoader {
//    NSLog(@"%@ will load table with object loader %@", tableController, objectLoader);
//}
//
//- (void)tableController:(RKAbstractTableController *)tableController didLoadTableWithObjectLoader:(RKObjectLoader *)objectLoader {
//    NSLog(@"%@ did load table with object loader %@", tableController, objectLoader);
//}
//
//- (void)tableControllerDidFinalizeLoad:(RKAbstractTableController *)tableController {
//    NSLog(@"%@ did finalize load", tableController);
//}

// Cells
//- (void)tableController:(RKAbstractTableController *)tableController willDisplayCell:(UITableViewCell *)cell forObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"%@ will display cell %@ for object: %@ at index path: %@", tableController, cell, object, indexPath);
//}
//
//- (void)tableController:(RKAbstractTableController *)tableController didSelectCell:(UITableViewCell *)cell forObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"%@ did select cell %@ for object: %@ at index path: %@", tableController, cell, object, indexPath);
//}


/**
 Sent when the table view has transitioned out of the loading state regardless of outcome
 */
//- (void)tableControllerDidFinishLoad:(RKAbstractTableController *)tableController {
//    NSLog(@"%@ did finish load", tableController);
//}
//
//- (void)tableController:(RKAbstractTableController *)tableController didFailLoadWithError:(NSError *)error {
//    NSLog(@"%@ did fail load with error: %@", tableController, error);
//}
//
//- (void)tableControllerDidCancelLoad:(RKAbstractTableController *)tableController {
//    NSLog(@"%@ did cancel load", tableController);
//}


- (void)configureTableView {
    self.tableView.backgroundColor = [UIColor colorWithPatternImageName:@"bg_home_pattern"];
//    self.tableView.backgroundColor = [UIColor colorWithHex:@"#191919" alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.tableView registerNib:[UINib nibWithNibName:@"WPTagCell" bundle:nil] forCellReuseIdentifier:@"WPTag"];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    NSLog(@"Did received a memory warning in controller: %@", [self class]);
}

@end