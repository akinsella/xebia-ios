//
//  GHRepositoryTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <RestKit/UI.h>
#import "GHRepository.h"
#import "GHRepositoryTableViewController.h"
#import "XBLoadingView.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "GHRepositoryCell.h"
#import "UIImage+XBAdditions.h"
#import "UIImageView+WebCache.h"
#import "UIColor+XBAdditions.h"
#import "UIScreen+XBAdditions.h"

@interface GHRepositoryTableViewController ()
@property (nonatomic, strong) RKTableController *tableController;
@property (nonatomic, strong) UIImage* defaultAvatarImage;
@property (nonatomic, strong) UIImage* xebiaAvatarImage;
@end

@implementation GHRepositoryTableViewController

- (id)init {
    self = [super init];

    if (self) {
        self.title = @"Repositories";
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableController loadTableFromResourcePath:@"/github/orgs/xebia-france/repos"];
}

- (void)configure {
    self.defaultAvatarImage = [UIImage imageNamed:@"github-gravatar-placeholder"];
    self.xebiaAvatarImage = [UIImage imageNamed:@"xebia-avatar"];

    [self configureTableView];
    [self configureTableController];
    [self configurePullToRefreshTriggerView];
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

    [self.tableController mapObjectsWithClass:[GHRepository class] toTableCellsWithMapping:[self createCellMapping]];
}

- (void)configureTableView {
    self.tableView.backgroundColor = [UIColor colorWithPatternImageName:@"bg_home_pattern"];
//    self.tableView.backgroundColor = [UIColor colorWithHex:@"#191919" alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.tableView registerNib:[UINib nibWithNibName:@"GHRepositoryCell" bundle:nil] forCellReuseIdentifier:@"GHRepository"];
}

- (void)configurePullToRefreshTriggerView {
    NSBundle *restKitResources = [NSBundle restKitResourcesBundle];
    UIImage *arrowImage = [restKitResources imageWithContentsOfResource:@"blueArrow" withExtension:@"png"];
    [[RKRefreshTriggerView appearance] setTitleFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13]];
    [[RKRefreshTriggerView appearance] setLastUpdatedFont:[UIFont fontWithName:@"HelveticaNeue" size:11]];
    [[RKRefreshTriggerView appearance] setArrowImage:arrowImage];
}

- (RKTableViewCellMapping *)createCellMapping {
    RKTableViewCellMapping *cellMapping = [RKTableViewCellMapping cellMapping];
    cellMapping.cellClassName = @"GHRepositoryCell";
    cellMapping.reuseIdentifier = @"GHRepository";
    [cellMapping mapKeyPath:@"name" toAttribute:@"titleLabel.text"];
    [cellMapping mapKeyPath:@"description_" toAttribute:@"descriptionLabel.text"];
    [cellMapping mapKeyPath:@"identifier" toAttribute:@"identifier"];

    cellMapping.heightOfCellForObjectAtIndexPath = ^ CGFloat(GHRepository *repository, NSIndexPath* indexPath) {
        GHRepositoryCell *repositoryCell = (GHRepositoryCell *)[[self tableController] tableView:self.tableView cellForRowAtIndexPath:indexPath];
        return [repositoryCell heightForCell];
    };

    return cellMapping;
}

- (void)tableController:(RKAbstractTableController *)tableController
        willDisplayCell:(GHRepositoryCell *)repositoryCell
              forObject:(GHRepository *)repository
            atIndexPath:(NSIndexPath *)indexPath {
    repositoryCell.imageView.image = self.xebiaAvatarImage;
}

- (void)didReceiveMemoryWarning{
    NSLog(@"Did received a memory warning in controller: %@", [self class]);
    [super didReceiveMemoryWarning];
}

@end