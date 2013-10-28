//
//  WPTagTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "WPTag.h"
#import "WPTagTableViewController.h"
#import "WPPostTableViewController.h"
#import "UIViewController+XBAdditions.h"
#import "WPTagCell.h"
#import "XBPListConfigurationProvider.h"
#import "XBBasicHttpQueryParamBuilder.h"
#import "XBHttpJsonDataLoader.h"
#import "XBJsonToArrayDataMapper.h"
#import "GAITracker.h"
#import "XBArrayDataSource+protected.h"

@implementation WPTagTableViewController

- (void)viewDidLoad {

    [self.appDelegate.tracker sendView:@"/wordpress/tag"];

    self.delegate = self;
    self.title = NSLocalizedString(@"Tags", nil);

    [super viewDidLoad];

    [self addMenuButton];


    CGRect newBounds = self.tableView.bounds;
    newBounds.origin.y = newBounds.origin.y + self.searchBar.bounds.size.height;
    self.tableView.bounds = newBounds;
}

-(void)configureTableView {
    [super configureTableView];
    self.searchBar.delegate = self;
}

- (NSString *)cellReuseIdentifierAtIndexPath:(NSIndexPath *)indexPath {
    // Needs to be static
    static NSString *cellReuseIdentifier = @"WPTag";

    return cellReuseIdentifier;
}

- (NSString *)cellNibNameAtIndexPath:(NSIndexPath *)indexPath {
    return @"WPTagCell";
}


- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {

    WPTagCell *tagCell = (WPTagCell *) cell;

    WPTag *tag = self.dataSource[(NSUInteger) indexPath.row];

    [tagCell updateWithTag: tag];
}

- (XBArrayDataSource *)buildDataSource {
    XBHttpClient *httpClient = [[XBPListConfigurationProvider provider] httpClient];
    XBBasicHttpQueryParamBuilder *httpQueryParamBuilder = [XBBasicHttpQueryParamBuilder builderWithDictionary:@{}];
    XBHttpJsonDataLoader *dataLoader = [XBHttpJsonDataLoader dataLoaderWithHttpClient:httpClient httpQueryParamBuilder:httpQueryParamBuilder resourcePath:@"/api/wordpress/tag"];
    XBJsonToArrayDataMapper *dataMapper = [XBJsonToArrayDataMapper mapperWithRootKeyPath:@"tags" typeClass:[WPTag class]];
    XBReloadableArrayDataSource *dataSource = [XBReloadableArrayDataSource dataSourceWithDataLoader:dataLoader dataMapper:dataMapper];

    return dataSource;
}

-(void)onSelectCell: (UITableViewCell *)cell forObject: (id) object withIndex: (NSIndexPath *)indexPath {

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    WPTag *tag = self.dataSource[(NSUInteger) indexPath.row];
    NSLog(@"Tag selected: %@", tag);

    WPPostTableViewController *postTableViewController = [[WPPostTableViewController alloc] initWithPostType:TAG identifier:tag.identifier];
    [self.navigationController pushViewController:postTableViewController animated:YES];
}

#pragma mark - UISearchBarDelegate methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length > 0) {
        [self.dataSource filter:^BOOL(WPTag *tag) {
            return [tag.title rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound;
        }];
    }
    else {
        [self.dataSource clearFilter];
    }

    [self.tableView reloadData];

    if (searchText.length) {
        [self resignFirstResponder];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.dataSource clearFilter];
}

-(IBAction)goToSearch:(id)sender {
    // If you're worried that your users might not catch on to the fact that a search bar is available if they scroll to reveal it, a search icon will help them
    // If you don't hide your search bar in your app, don’t include this, as it would be redundant
    [self.searchBar becomeFirstResponder];
}

@end