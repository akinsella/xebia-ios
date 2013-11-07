//
//  WPCategoryTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "WPCategory.h"
#import "WPCategoryTableViewController.h"
#import "WPPost.h"
#import "WPPostTableViewController.h"
#import "UIViewController+XBAdditions.h"
#import "XBMainViewController.h"
#import "WPCategoryCell.h"
#import "NSDateFormatter+XBAdditions.h"
#import "XBBasicHttpQueryParamBuilder.h"
#import "XBPListConfigurationProvider.h"
#import "XBHttpJsonDataLoader.h"
#import "XBJsonToArrayDataMapper.h"
#import "GAITracker.h"

@implementation WPCategoryTableViewController

- (void)viewDidLoad {

    [self.appDelegate.tracker sendView:@"/wordpress/category"];

    self.delegate = self;
    self.title = NSLocalizedString(@"Categories", nil);

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
    static NSString *cellReuseIdentifier = @"WPCategory";

    return cellReuseIdentifier;
}

- (NSString *)tableView:(UITableView *)tableView cellNibNameAtIndexPath:(NSIndexPath *)indexPath {
    return @"WPCategoryCell";
}

- (XBArrayDataSource *)buildDataSource {
    XBHttpClient *httpClient = [[XBPListConfigurationProvider provider] httpClient];
    XBBasicHttpQueryParamBuilder *httpQueryParamBuilder = [XBBasicHttpQueryParamBuilder builderWithDictionary:@{}];
    XBHttpJsonDataLoader *dataLoader = [XBHttpJsonDataLoader dataLoaderWithHttpClient:httpClient httpQueryParamBuilder:httpQueryParamBuilder resourcePath:@"/wordpress/categories"];
    XBJsonToArrayDataMapper *dataMapper = [XBJsonToArrayDataMapper mapperWithRootKeyPath:@"categories" typeClass:[WPCategory class]];
    return [XBReloadableArrayDataSource dataSourceWithDataLoader:dataLoader dataMapper:dataMapper];
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {

    WPCategoryCell *categoryCell = (WPCategoryCell *) cell;

    WPCategory *category = self.dataSource[(NSUInteger) indexPath.row];

    [categoryCell updateWithCategory: category];
}

-(void)onSelectCell: (UITableViewCell *)cell forObject: (id) object withIndex: (NSIndexPath *)indexPath {

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    WPCategory *category = self.dataSource[(NSUInteger) indexPath.row];
    NSLog(@"Category selected: %@", category);

    WPPostTableViewController *postTableViewController = [[WPPostTableViewController alloc] initWithPostType:CATEGORY identifier:category.identifier];
    [self.navigationController pushViewController:postTableViewController animated:YES];
}

@end