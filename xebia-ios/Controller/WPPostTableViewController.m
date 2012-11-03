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
@property (nonatomic, strong) NSMutableDictionary *postTypes;
@property (nonatomic, strong) RKTableController *tableController;
@property (nonatomic, strong) UIImage *defaultPostImage;
@property (nonatomic, strong) UIImage *xebiaPostImage;
@property(nonatomic, assign) POST_TYPE postType;
@property(nonatomic, copy) NSNumber *identifier;
@end

@implementation WPPostTableViewController

-(id)initWithPostType:(POST_TYPE)pPostType identifier:(NSNumber *)pIdentifier
{
    self = [super initWithStyle:UITableViewStylePlain];

    if (self) {
        [self initInternalWithPostType:pPostType identifier:pIdentifier];
    }

    return self;
}

- (void)initInternalWithPostType:(POST_TYPE)pPostType identifier:(NSNumber *)pIdentifier {
    self.title = @"Posts";
    self.defaultPostImage = [UIImage imageNamed:@"avatar_placeholder"];
    self.xebiaPostImage = [UIImage imageNamed:@"xebia-avatar"];

    self.postType = pPostType;
    self.identifier = pIdentifier;

    self.postTypes = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                @"recent",  [NSNumber asString:RECENT],
                @"author", [NSNumber asString: AUTHOR],
                @"tag", [NSNumber asString: TAG],
                @"category", [NSNumber asString: CATEGORY],
                nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configure];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSString *resourcePath = self.identifier ?
            [NSString stringWithFormat: @"/wordpress/get_%@_posts/?id=%@", [self getCurrentPostType], self.identifier] :
            [NSString stringWithFormat: @"/wordpress/get_%@_posts/?count=25", [self getCurrentPostType]];

    [self.tableController loadTableFromResourcePath:resourcePath];
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
    
//    XBLoadingView *loadingView = [[XBLoadingView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
//    loadingView.center = self.tableView.center;
//    self.tableController.loadingView = loadingView;

    [self.tableController mapObjectsWithClass:[WPPost class] toTableCellsWithMapping:[self getCellMapping]];
}

- (RKTableViewCellMapping *)getCellMapping {
    RKTableViewCellMapping *cellMapping = [RKTableViewCellMapping cellMapping];
    cellMapping.cellClassName = @"WPPostCell";
    cellMapping.reuseIdentifier = @"WPPost";
    cellMapping.rowHeight = 102.0;
    [cellMapping mapKeyPath:@"title_plain" toAttribute:@"titleLabel.text"];
    [cellMapping mapKeyPath:@"description_" toAttribute:@"excerptLabel.text"];
    [cellMapping mapKeyPath:@"dateFormatted" toAttribute:@"dateLabel.text"];
    [cellMapping mapKeyPath:@"tagsFormatted" toAttribute:@"tagsLabel.text"];
    [cellMapping mapKeyPath:@"categoriesFormatted" toAttribute:@"categoriesLabel.text"];
    [cellMapping mapKeyPath:@"authorFormatted" toAttribute:@"authorLabel.text"];
    [cellMapping mapKeyPath:@"identifier" toAttribute:@"identifier"];
    return cellMapping;
}

- (void)configureTableView {
    self.tableView.backgroundColor = [UIColor colorWithPatternImageName:@"bg_home_pattern"];
//    self.tableView.backgroundColor = [UIColor colorWithHex:@"#191919" alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WPPostCell" bundle:nil] forCellReuseIdentifier:@"WPPost"];
}

- (NSString *)getCurrentPostType {
    return [self.postTypes valueForKey:[[NSNumber numberWithInt:self.postType] description]];
}

- (void)configureRefreshTriggerView {
    NSBundle *restKitResources = [NSBundle restKitResourcesBundle];
    UIImage *arrowImage = [restKitResources imageWithContentsOfResource:@"blueArrow" withExtension:@"png"];
    [[RKRefreshTriggerView appearance] setTitleFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13]];
    [[RKRefreshTriggerView appearance] setLastUpdatedFont:[UIFont fontWithName:@"HelveticaNeue" size:11]];
    [[RKRefreshTriggerView appearance] setArrowImage:arrowImage];
}

- (void)tableController:(RKAbstractTableController *)tableController
        willDisplayCell:(WPPostCell *)postCell
              forObject:(WPPost *)post
            atIndexPath:(NSIndexPath *)indexPath;
{
    if (![post.author.slug isEqualToString:@"xebiafrance" ]) {
        [postCell.imageView setImageWithURL: [post imageUrl] placeholderImage:self.defaultPostImage];
    }
    else {
        postCell.imageView.image = self.xebiaPostImage;
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    NSLog(@"Did received a memory warning in controller: %@", [self class]);
}

@end
