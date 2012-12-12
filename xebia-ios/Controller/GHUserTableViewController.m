//
//  GHUserTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
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
#import "UIColor+XBAdditions.h"
#import "UIScreen+XBAdditions.h"
#import "GHUserCell.h"

@interface GHUserTableViewController ()
@property (nonatomic, strong) RKTableController *tableController;
@property (nonatomic, strong) UIImage* defaultAvatarImage;
@end

@implementation GHUserTableViewController

- (id)init {
    self = [super init];

    if (self) {
        self.title = @"Users";
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableController loadTableFromResourcePath:@"/github/users"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
}

- (void)configure {
    self.defaultAvatarImage = [UIImage imageNamed:@"github-gravatar-placeholder"];

    [self configureTableController];
    [self configureRefreshTriggerView];
    [self configureTableView];
}

- (void)configureTableView {
    self.tableView.backgroundColor = [UIColor colorWithPatternImageName:@"bg_home_pattern"];
//    self.tableView.backgroundColor = [UIColor colorWithHex:@"#191919" alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.tableView registerNib:[UINib nibWithNibName:@"GHUserCell" bundle:nil] forCellReuseIdentifier:@"GHUser"];
}

- (RKTableViewCellMapping *)getCellMapping {
    RKTableViewCellMapping *cellMapping = [RKTableViewCellMapping cellMapping];
    cellMapping.cellClassName = @"GHUserCell";
    cellMapping.reuseIdentifier = @"GHUser";

    [cellMapping mapKeyPath:@"name" toAttribute:@"titleLabel.text"];
    [cellMapping mapKeyPath:@"description_" toAttribute:@"descriptionLabel.text"];
    [cellMapping mapKeyPath:@"identifier" toAttribute:@"identifier"];

    cellMapping.heightOfCellForObjectAtIndexPath = ^ CGFloat(GHUser *user, NSIndexPath* indexPath) {
        GHUserCell *userCell = (GHUserCell *)[[self tableController] tableView:self.tableView cellForRowAtIndexPath:indexPath];
        return [userCell heightForCell];
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

    self.tableController.delegate = self;

    self.tableController.autoRefreshFromNetwork = NO;
    self.tableController.pullToRefreshEnabled = YES;
    self.tableController.variableHeightRows = YES;

    self.tableController.imageForOffline = [UIImage imageNamed:@"offline.png"];
    self.tableController.imageForError = [UIImage imageNamed:@"error.png"];
    self.tableController.imageForEmpty = [UIImage imageNamed:@"empty.png"];

    [self.tableController mapObjectsWithClass:[GHUser class] toTableCellsWithMapping:[self getCellMapping]];
}

- (void)tableController:(RKAbstractTableController *)tableController
        willDisplayCell:(GHUserCell *)userCell
              forObject:(GHUser *)user
            atIndexPath:(NSIndexPath *)indexPath {
    [userCell.imageView setImageWithURL:[user avatarImageUrl] placeholderImage:self.defaultAvatarImage];
}

- (void)didReceiveMemoryWarning{
    NSLog(@"Did received a memory warning in controller: %@", [self class]);
    [super didReceiveMemoryWarning];
}

@end