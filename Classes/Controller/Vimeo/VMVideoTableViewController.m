//
// Created by Alexis Kinsella on 23/06/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "VMVideoTableViewController.h"
#import "VMVideo.h"
#import "XBBasicHttpQueryParamBuilder.h"
#import "XBConfigurationProvider.h"
#import "XBPListConfigurationProvider.h"
#import "XBHttpJsonDataLoader.h"
#import "XBJsonToArrayDataMapper.h"
#import "GAITracker.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+XBAdditions.h"
#import "VMVideoCell.h"
#import "VMThumbnail.h"
#import "VMVideoDetailsViewController.h"
#import "NSString+XBAdditions.h"

@implementation VMVideoTableViewController

- (NSString *)trackPath {
    return [NSString stringWithFormat:@"/videos"];
}

- (void)viewDidLoad {

    self.delegate = self;
    self.tableView.rowHeight = 75;
    self.title = NSLocalizedString(@"Videos", nil);

    [self customizeNavigationBarAppearance];
    [self addMenuButton];

    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView cellReuseIdentifierAtIndexPath:(NSIndexPath *)indexPath {
    // Needs to be static
    static NSString *cellReuseIdentifier = @"VMVideo";

    return cellReuseIdentifier;
}

- (NSString *)tableView:(UITableView *)tableView cellNibNameAtIndexPath:(NSIndexPath *)indexPath {
    return [@"VMVideoCell" suffixIfIPad];
}

- (XBArrayDataSource *)buildDataSource {
    XBHttpClient *httpClient = [[XBPListConfigurationProvider provider] httpClient];
    XBBasicHttpQueryParamBuilder *httpQueryParamBuilder = [XBBasicHttpQueryParamBuilder builderWithDictionary:@{}];
    XBHttpJsonDataLoader *dataLoader = [XBHttpJsonDataLoader dataLoaderWithHttpClient:httpClient httpQueryParamBuilder:httpQueryParamBuilder resourcePath:@"/videos"];
    XBJsonToArrayDataMapper *dataMapper = [XBJsonToArrayDataMapper mapperWithRootKeyPath:nil typeClass:[VMVideo class]];
    return [XBReloadableArrayDataSource dataSourceWithDataLoader:dataLoader dataMapper:dataMapper];
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {
    VMVideoCell *videoCell = (VMVideoCell *) cell;

    VMVideo *video = self.dataSource[(NSUInteger) indexPath.row];

    [videoCell updateWithVideo:video];
}

-(void)onSelectCell: (UITableViewCell *)cell forObject: (id) object withIndex: (NSIndexPath *)indexPath {
    VMVideo *video = self.dataSource[(NSUInteger) indexPath.row];
    VMVideoDetailsViewController *videoDetailsViewController = (VMVideoDetailsViewController *) [[self appDelegate].viewControllerManager getOrCreateControllerWithIdentifier:@"videoDetails"];
    [videoDetailsViewController updateWithVideo: video];
    [self.navigationController pushViewController:videoDetailsViewController animated:YES];
}

@end