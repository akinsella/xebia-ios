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

static NSString *const reuseIdentifier = @"WPTag";

@interface WPTagTableViewController ()
@property (nonatomic, strong) RKTableController *tableController;
@end

@implementation WPTagTableViewController

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

    [self.tableController loadTableFromResourcePath:@"/wordpress/get_tag_index/"];
}

- (void)configure {
    [self configureTableController];
    [self configureRefreshTriggerView];
    [self configureTableView];
}

- (void)configureTableController {
    self.tableController = [[RKObjectManager sharedManager] tableControllerForTableViewController:self];

    self.tableController.delegate = self;

    self.tableController.autoRefreshFromNetwork = NO;
    self.tableController.pullToRefreshEnabled = YES;
    self.tableController.variableHeightRows = NO;

    self.tableController.imageForOffline = [UIImage imageNamed:@"offline.png"];
    self.tableController.imageForError = [UIImage imageNamed:@"error.png"];
    self.tableController.imageForEmpty = [UIImage imageNamed:@"empty.png"];

    [self.tableController mapObjectsWithClass:[WPTag class] toTableCellsWithMapping:[self getCellMapping]];
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
    cellMapping.reuseIdentifier = reuseIdentifier;
    
    [cellMapping mapKeyPath:@"capitalizedTitle" toAttribute:@"titleLabel.text"];
    [cellMapping mapKeyPath:@"postCount" toAttribute:@"itemCount"];
    cellMapping.onSelectCellForObjectAtIndexPath = ^(UITableViewCell *cell, id object, NSIndexPath* indexPath) {
        WPTag *tag = [self.tableController objectForRowAtIndexPath:indexPath];
        NSLog(@"Tag selected: %@", tag);
        
        WPPostTableViewController *postTableViewController = [[WPPostTableViewController alloc] initWithPostType:TAG identifier:tag.identifier];
        [self.appDelegate.mainViewController revealViewController:postTableViewController];
    };

    return cellMapping;
}

- (void)configureTableView {
    self.tableView.backgroundColor = [UIColor colorWithPatternImageName:@"bg_home_pattern"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.tableView registerNib:[UINib nibWithNibName:@"WPTagCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    NSLog(@"Did received a memory warning in controller: %@", [self class]);
}

@end