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

#define FONT_SIZE 13.0f
#define CELL_CONTENT_WIDTH 232.0f
#define CELL_MIN_HEIGHT 64.0f
#define CELL_BASE_HEIGHT 48.0f
#define CELL_MAX_HEIGHT 1000.0f

@interface GHRepositoryTableViewController ()
@property (nonatomic, strong) RKTableController *tableController;
@end

@implementation GHRepositoryTableViewController{
    UIImage* _defaultAvatarImage;
}

@synthesize tableController;

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
    [tableController loadTableFromResourcePath:@"/github/orgs/xebia-france/repos"];
}

- (void)configure {
    _defaultAvatarImage = [UIImage imageNamed:@"github-gravatar-placeholder"];

    [self configureTableView];
    [self configureTableController];
    [self configurePullToRefreshTriggerView];
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

    [tableController mapObjectsWithClass:[GHRepository class] toTableCellsWithMapping:[self createCellMapping]];
}

- (void)configureTableView {
    self.tableView.backgroundColor = [UIColor colorWithPatternImageName:@"bg_home_pattern"];
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
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH, CELL_MAX_HEIGHT);
        CGSize size = [repository.description_ sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE]
                                          constrainedToSize:constraint
                                              lineBreakMode:UILineBreakModeWordWrap];
        CGFloat height = MAX(CELL_BASE_HEIGHT + size.height, CELL_MIN_HEIGHT);

        return height;
    };
    return cellMapping;
}

- (void)tableController:(RKAbstractTableController *)tableController willDisplayCell:(UITableViewCell *)cell forObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    GHRepository *repository = object;
    GHRepositoryCell *repositoryCell = (GHRepositoryCell *)cell;
    [repositoryCell.imageView setImageWithURL:[repository.owner avatarImageUrl] placeholderImage:_defaultAvatarImage];
}

@end