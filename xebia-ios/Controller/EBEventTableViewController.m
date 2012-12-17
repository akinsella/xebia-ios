//
//  EBEventTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <RestKit/UI.h>
#import "EBEventTableViewController.h"
#import "EBEvent.h"
#import "XBLoadingView.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "EBEventCell.h"
#import "UIImage+XBAdditions.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+XBAdditions.h"
#import "UIColor+XBAdditions.h"
#import "UIScreen+XBAdditions.h"
#import "XBMainViewController.h"

@interface EBEventTableViewController ()
@property (nonatomic, strong) RKTableController *tableController;
@property (nonatomic, strong) UIImage* defaultAvatarImage;
@end

@implementation EBEventTableViewController

- (id)init {
    self = [super init];
    
    if (self) {
        self.title = @"Users";
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableController loadTableFromResourcePath:@"/eventbrite/events"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
}

- (void)configure {
    self.defaultAvatarImage = [UIImage imageNamed:@"avatar_placeholder.png"];

    [self addRevealGesture];
    [self addMenuButton];

    [self configureTableController];
    [self configureRefreshTriggerView];
    [self configureTableView];
}

- (void)configureTableView {
    self.tableView.backgroundColor = [UIColor colorWithPatternImageName:@"bg_home_pattern"];
//    self.tableView.backgroundColor = [UIColor colorWithHex:@"#191919" alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EBEventCell" bundle:nil] forCellReuseIdentifier:@"EBEvent"];
}

- (RKTableViewCellMapping *)getCellMapping {
    RKTableViewCellMapping *cellMapping = [RKTableViewCellMapping cellMapping];
    cellMapping.cellClassName = @"EBEventCell";
    cellMapping.reuseIdentifier = @"EBEvent";
    
    [cellMapping mapKeyPath:@"title" toAttribute:@"titleLabel.text"];
    [cellMapping mapKeyPath:@"description_plain_text" toAttribute:@"descriptionLabel.text"];
    [cellMapping mapKeyPath:@"identifier" toAttribute:@"identifier"];

    [cellMapping addPrepareCellBlock:^(UITableViewCell *eventCell) {
        [(EBEventCell *)eventCell configure];
    }];

    cellMapping.heightOfCellForObjectAtIndexPath = ^ CGFloat(EBEvent *event, NSIndexPath* indexPath) {
        EBEventCell *eventCell = (EBEventCell *)[[self tableController] tableView:self.tableView cellForRowAtIndexPath:indexPath];
        return [eventCell heightForCell];
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
    
    self.tableController.autoRefreshFromNetwork = YES;
    self.tableController.pullToRefreshEnabled = YES;
    self.tableController.variableHeightRows = YES;
    
    /**
     Setup some images for various table states
     */
    self.tableController.imageForOffline = [UIImage imageNamed:@"offline.png"];
    self.tableController.imageForError = [UIImage imageNamed:@"error.png"];
    self.tableController.imageForEmpty = [UIImage imageNamed:@"empty.png"];
    
    [self.tableController mapObjectsWithClass:[EBEvent class] toTableCellsWithMapping:[self getCellMapping]];
}

- (void)tableController:(RKAbstractTableController *)tableController
        willDisplayCell:(EBEventCell *)eventCell
              forObject:(EBEvent *)event
            atIndexPath:(NSIndexPath *)indexPath {
    [eventCell.imageView setImage:[UIImage imageNamed:@"eventbrite"]];
    eventCell.descriptionLabel.delegate = self;
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    NSLog(@"Url requested: %@", url);
    [self.appDelegate.mainViewController openURL:url withTitle:@"EventBrite"];
}

@end