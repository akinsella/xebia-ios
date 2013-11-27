//
//  WPAuthorTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "WPAuthor.h"
#import "WPAuthorTableViewController.h"
#import "WPAuthorCell.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "WPPost.h"
#import "WPPostTableViewController.h"
#import "UIViewController+XBAdditions.h"
#import "XBMainViewController.h"
#import "NSDateFormatter+XBAdditions.h"
#import "XBPListConfigurationProvider.h"
#import "XBBasicHttpQueryParamBuilder.h"
#import "XBHttpJsonDataLoader.h"
#import "XBJsonToArrayDataMapper.h"
#import "GAITracker.h"

@implementation WPAuthorTableViewController

- (NSString *)trackPath {
    return [NSString stringWithFormat:@"/blog/authors"];
}

- (void)viewDidLoad {

    self.delegate = self;
    self.tableView.rowHeight = 60;
    self.title = NSLocalizedString(@"Authors", nil);

    [super viewDidLoad];

    [self customizeNavigationBarAppearance];
    [self addMenuButton];
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
    static NSString *cellReuseIdentifier = @"WPAuthor";

    return cellReuseIdentifier;
}

- (NSString *)tableView:(UITableView *)tableView cellNibNameAtIndexPath:(NSIndexPath *)indexPath {
    return @"WPAuthorCell";
}

- (XBArrayDataSource *)buildDataSource {

    XBHttpClient *httpClient = [[XBPListConfigurationProvider provider] httpClient];
    XBBasicHttpQueryParamBuilder *httpQueryParamBuilder = [XBBasicHttpQueryParamBuilder builderWithDictionary:@{}];
    XBHttpJsonDataLoader *dataLoader = [XBHttpJsonDataLoader dataLoaderWithHttpClient:httpClient httpQueryParamBuilder:httpQueryParamBuilder resourcePath:@"/wordpress/authors"];
    XBJsonToArrayDataMapper *dataMapper = [XBJsonToArrayDataMapper mapperWithRootKeyPath:@"authors" typeClass:[WPAuthor class]];
    return [XBReloadableArrayDataSource dataSourceWithDataLoader:dataLoader dataMapper:dataMapper];
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {

    WPAuthorCell *authorCell = (WPAuthorCell *) cell;

    WPAuthor *author = self.dataSource[(NSUInteger) indexPath.row];

    [authorCell updateWithAuthor: author];
}

-(void)onSelectCell: (UITableViewCell *)cell forObject: (id) object withIndex: (NSIndexPath *)indexPath {

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    WPAuthor *author = self.dataSource[(NSUInteger) indexPath.row];
    NSLog(@"Author selected: %@", author);

    WPPostTableViewController *postTableViewController = [[WPPostTableViewController alloc] initWithPostType:AUTHOR identifier:author.identifier];
    [self.navigationController pushViewController:postTableViewController animated:YES];
}

@end