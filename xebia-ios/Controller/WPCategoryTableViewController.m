//
//  WPCategoryTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <RestKit/UI.h>
#import "WPCategory.h"
#import "WPCategoryTableViewController.h"
#import "XBLoadingView.h"
#import "UIColor+XBAdditions.h"
#import "WPPost.h"
#import "WPPostTableViewController.h"
#import "UIViewController+XBAdditions.h"
#import "XBMainViewController.h"

static NSString *const reuseIdentifier = @"WPCategory";

@interface WPCategoryTableViewController ()
@property (nonatomic, strong) RKTableController *tableController;
@end

@implementation WPCategoryTableViewController

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"Categories";
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableController loadTableFromResourcePath:@"/wordpress/categories"];
}

- (void)configure {
    [self configureTableView];
    [self configureTableController];
    [self configureRefreshTriggerView];
}

- (RKTableViewCellMapping *)getCellMapping {
    RKTableViewCellMapping *cellMapping = [RKTableViewCellMapping cellMapping];


    cellMapping.cellClassName = @"WPCategoryCell";
    cellMapping.reuseIdentifier = reuseIdentifier;
    [cellMapping mapKeyPath:@"title" toAttribute:@"titleLabel.text"];
    [cellMapping mapKeyPath:@"postCount" toAttribute:@"itemCount"];
    cellMapping.onSelectCellForObjectAtIndexPath = ^(UITableViewCell *cell, id object, NSIndexPath* indexPath) {
        WPCategory *category = [self.tableController objectForRowAtIndexPath:indexPath];
        NSLog(@"Category selected: %@", category);
        
        WPPostTableViewController *postTableViewController = [[WPPostTableViewController alloc] initWithPostType:CATEGORY identifier:category.identifier];
        [self.appDelegate.mainViewController revealViewController:postTableViewController];
    };

    return cellMapping;
}

- (void)configureTableView {
    self.tableView.backgroundColor = [UIColor colorWithPatternImageName:@"bg_home_pattern"];
//    self.tableView.backgroundColor = [UIColor colorWithHex:@"#191919" alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.tableView registerNib:[UINib nibWithNibName:@"WPCategoryCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
}

- (void)configureRefreshTriggerView {
    NSBundle *restKitResources = [NSBundle restKitResourcesBundle];
    UIImage *arrowImage = [restKitResources imageWithContentsOfResource:@"blueArrow" withExtension:@"png"];
    [[RKRefreshTriggerView appearance] setTitleFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13]];
    [[RKRefreshTriggerView appearance] setLastUpdatedFont:[UIFont fontWithName:@"HelveticaNeue" size:11]];
    [[RKRefreshTriggerView appearance] setArrowImage:arrowImage];
}

- (void)configureTableController {
    self.tableController = [[RKObjectManager sharedManager] tableControllerForTableViewController:self];

    self.tableController.delegate = self;

    self.tableController.autoRefreshFromNetwork = NO;
    self.tableController.pullToRefreshEnabled = YES;
    self.tableController.variableHeightRows = YES;

    self.tableController.imageForOffline = [UIImage imageNamed:@"offline.png"];
    self.tableController.imageForError = [UIImage imageNamed:@"error.png"];
    self.tableController.imageForEmpty = [UIImage imageNamed:@"empty.png"];

    [self.tableController mapObjectsWithClass:[WPCategory class] toTableCellsWithMapping:[self getCellMapping]];
}

- (void)didReceiveMemoryWarning{
    NSLog(@"Did received a memory warning in controller: %@", [self class]);
    [super didReceiveMemoryWarning];
}

@end