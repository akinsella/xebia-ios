//
//  WPPostTableViewController.m
//  Xebia Application
//
//  Created by Alexis Kinsella on 14/06/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//


#import <RestKit/RestKit.h>
#import <RestKit/UI.h>
#import "WPPost.h"
#import "WPPostTableViewController.h"
#import "XBLoadingView.h"
#import "WPPostCell.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "WPPost.h"
#import "UIColor+XBAdditions.h"
#import "NSNumber+XBAdditions.h"

@interface WPPostTableViewController ()
@property (nonatomic, strong) RKTableController *tableController;
@end

@implementation WPPostTableViewController {
    UIImage*_defaultPostImage;
}

NSMutableDictionary *postTypes;

@synthesize tableController;
@synthesize identifier, postType;

-(id)initWithPostType:(POST_TYPE)postType identifier:(NSNumber *)identifier
{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {

        self.title = @"Posts";
        _defaultPostImage = [UIImage imageNamed:@"avatar_placeholder"];

        self.postType = postType;
        self.identifier = identifier;
        
        postTypes = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                           @"recent",  [NSNumber asString:RECENT],
                           @"author", [NSNumber asString: AUTHOR],
                           @"tag", [NSNumber asString: TAG],
                           @"category", [NSNumber asString: CATEGORY],
                           nil];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configure];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSString *resourcePath = [NSString stringWithFormat: @"/wordpress/get_%@_posts/?id=%@&count=100", [self getCurrentPostType], identifier];
    [tableController loadTableFromResourcePath:resourcePath];
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

    [tableController mapObjectsWithClass:[WPPost class] toTableCellsWithMapping:[self getCellMapping]];
}

- (RKTableViewCellMapping *)getCellMapping {
    RKTableViewCellMapping *cellMapping = [RKTableViewCellMapping cellMapping];
    cellMapping.cellClassName = @"WPPostCell";
    cellMapping.reuseIdentifier = @"WPPost";
    cellMapping.rowHeight = 204.0;
    [cellMapping mapKeyPath:@"title" toAttribute:@"titleLabel.text"];
    [cellMapping mapKeyPath:@"excerptTrim" toAttribute:@"excerptLabel.text"];
    [cellMapping mapKeyPath:@"dateFormatted" toAttribute:@"dateLabel.text"];
    [cellMapping mapKeyPath:@"tagsFormatted" toAttribute:@"tagsLabel.text"];
    [cellMapping mapKeyPath:@"categoriesFormatted" toAttribute:@"categoriesLabel.text"];
    [cellMapping mapKeyPath:@"authorFormatted" toAttribute:@"authorLabel.text"];
    [cellMapping mapKeyPath:@"identifier" toAttribute:@"identifier"];
    return cellMapping;
}

- (void)configureTableView {
    self.tableView.backgroundColor = [UIColor colorWithPatternImageName:@"bg_home_pattern"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WPPostCell" bundle:nil] forCellReuseIdentifier:@"WPPost"];
}

- (NSString *)getCurrentPostType {
    return [postTypes valueForKey:[[NSNumber numberWithInt:postType] description]];
}

- (void)configureRefreshTriggerView {
    NSBundle *restKitResources = [NSBundle restKitResourcesBundle];
    UIImage *arrowImage = [restKitResources imageWithContentsOfResource:@"blueArrow" withExtension:@"png"];
    [[RKRefreshTriggerView appearance] setTitleFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13]];
    [[RKRefreshTriggerView appearance] setLastUpdatedFont:[UIFont fontWithName:@"HelveticaNeue" size:11]];
    [[RKRefreshTriggerView appearance] setArrowImage:arrowImage];
}

- (void)tableController:(RKAbstractTableController *)tableController willDisplayCell:(UITableViewCell *)cell forObject:(id)object atIndexPath:(NSIndexPath *)indexPath;
{
    WPPost *post = object;
    WPPostCell *postCell = (WPPostCell *)cell;
    [postCell.imageView setImageWithURL:[post imageUrl] placeholderImage:_defaultPostImage];
}


@end
