//
//  WPAuthorTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <RestKit/UI.h>
#import "WPAuthor.h"
#import "WPAuthorTableViewController.h"
#import "XBLoadingView.h"
#import "WPAuthorCell.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "WPPost.h"
#import "WPPostTableViewController.h"
#import "UINavigationController+XBAdditions.h"
#import "UIViewController+XBAdditions.h"
#import "XBMainViewController.h"
#import "UIColor+XBAdditions.h"

@interface WPAuthorTableViewController ()
@property (nonatomic, strong) RKTableController *tableController;
@end

@implementation WPAuthorTableViewController {
    UIImage* _defaultAvatarImage;
}

@synthesize tableController;

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"Authors";
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [tableController loadTableFromResourcePath:@"/wordpress/get_author_index/"];
}

- (void)configure {
    _defaultAvatarImage = [[UIImage imageNamed:@"avatar_placeholder"] retain];

    [self configureTableView];
    [self configureTableController];
    [self configureRefreshTriggerView];
}

- (RKTableViewCellMapping *)getCellMapping {
    RKTableViewCellMapping *cellMapping = [RKTableViewCellMapping cellMapping];
    cellMapping.cellClassName = @"WPAuthorCell";
    cellMapping.reuseIdentifier = @"WPAuthor";
    cellMapping.rowHeight = 64.0;
    [cellMapping mapKeyPath:@"name" toAttribute:@"titleLabel.text"];
    [cellMapping mapKeyPath:@"identifier" toAttribute:@"identifier"];
    cellMapping.onSelectCellForObjectAtIndexPath = ^(UITableViewCell *cell, id object, NSIndexPath* indexPath) {
        WPAuthor *author = [self.tableController objectForRowAtIndexPath:indexPath];
        NSLog(@"Author selected: %@", author);

        WPPostTableViewController *postTableViewController = [[WPPostTableViewController alloc] initWithPostType:AUTHOR identifier:author.identifier];
        [self.appDelegate.mainViewController revealViewController:postTableViewController];
        [postTableViewController release];
    };
    return cellMapping;
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

//    self.tableController.sectionNameKeyPath = @"uppercaseFirstLetterOfName";

    self.tableController.delegate = self;

    self.tableController.autoRefreshFromNetwork = YES;
    self.tableController.pullToRefreshEnabled = YES;
    self.tableController.variableHeightRows = YES;

    self.tableController.imageForOffline = [UIImage imageNamed:@"offline.png"];
    self.tableController.imageForError = [UIImage imageNamed:@"error.png"];
    self.tableController.imageForEmpty = [UIImage imageNamed:@"empty.png"];

    [tableController mapObjectsWithClass:[WPAuthor class] toTableCellsWithMapping:[self getCellMapping]];
}

- (void)configureTableView {
    self.tableView.backgroundColor = [UIColor colorWithPatternImageName:@"bg_home_pattern"];
//    self.tableView.backgroundColor = [UIColor colorWithHex:@"#191919" alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.tableView registerNib:[UINib nibWithNibName:@"WPAuthorCell" bundle:nil] forCellReuseIdentifier:@"WPAuthor"];
}

- (void)tableController:(RKAbstractTableController *)tableController willDisplayCell:(UITableViewCell *)cell forObject:(id)object atIndexPath:(NSIndexPath *)indexPath; {
    WPAuthor *author = object;
    WPAuthorCell *authorCell = (WPAuthorCell *)cell;
    [authorCell.imageView setImageWithURL:[author avatarImageUrl] placeholderImage:_defaultAvatarImage];
}

- (void)didReceiveMemoryWarning{
    NSLog(@"Did received a memory warning in controller: %@", [self class]);
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [_defaultAvatarImage release];
    [super dealloc];
}

@end