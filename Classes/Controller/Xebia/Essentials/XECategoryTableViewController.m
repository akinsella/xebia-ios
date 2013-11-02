//
// Created by Alexis Kinsella on 11/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "XECategoryTableViewController.h"
#import "GAITracker.h"
#import "UIViewController+XBAdditions.h"
#import "XECategoryCell.h"
#import "XECategory.h"
#import "XBPListConfigurationProvider.h"
#import "XBBasicHttpQueryParamBuilder.h"
#import "XBHttpJsonDataLoader.h"
#import "XBJsonToArrayDataMapper.h"
#import "XECardTableViewController.h"

@implementation XECategoryTableViewController

- (void)viewDidLoad {

    [self.appDelegate.tracker sendView:@"/essentials/category"];

    self.delegate = self;
    self.title = NSLocalizedString(@"Categories", nil);

    [self addMenuButton];

    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (NSString *)tableView:(UITableView *)tableView cellReuseIdentifierAtIndexPath:(NSIndexPath *)indexPath {
    // Needs to be static
    static NSString *cellReuseIdentifier = @"XECategory" ;

    return cellReuseIdentifier;
}

- (NSString *)tableView:(UITableView *)tableView cellNibNameAtIndexPath:(NSIndexPath *)indexPath {
    return @"XECategoryCell";
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {

    XECategoryCell *categoryCell = (XECategoryCell *) cell;

    XECategory *category = self.dataSource[(NSUInteger) indexPath.row];
    [categoryCell updateWithCategory:category];
}

- (XBArrayDataSource *)buildDataSource {
    XBHttpClient *httpClient = [[XBPListConfigurationProvider provider] httpClient];
    XBBasicHttpQueryParamBuilder *httpQueryParamBuilder = [XBBasicHttpQueryParamBuilder builderWithDictionary:@{}];
    XBHttpJsonDataLoader *dataLoader = [XBHttpJsonDataLoader dataLoaderWithHttpClient:httpClient httpQueryParamBuilder:httpQueryParamBuilder resourcePath:@"/essentials/categories"];
    XBJsonToArrayDataMapper *dataMapper = [XBJsonToArrayDataMapper mapperWithRootKeyPath:@"categories" typeClass:[XECategory class]];
    return [XBReloadableArrayDataSource dataSourceWithDataLoader:dataLoader dataMapper:dataMapper];
}

-(void)onSelectCell: (UITableViewCell *)cell forObject: (id) object withIndex: (NSIndexPath *)indexPath {

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    XECategory *category = self.dataSource[(NSUInteger) indexPath.row];
    NSLog(@"Category selected: %@", category);

    XECardTableViewController *cardCategoryViewController = (XECardTableViewController *) [self.appDelegate.viewControllerManager getOrCreateControllerWithIdentifier:@"cards"];
    [cardCategoryViewController updateWithCategory: category];
    [self.navigationController pushViewController:cardCategoryViewController animated:YES];
}

@end