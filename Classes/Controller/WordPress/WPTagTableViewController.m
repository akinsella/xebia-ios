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

@implementation WPTagTableViewController

- (void)viewDidLoad {

    [self.appDelegate.tracker sendView:@"/wordpress/tag"];

    self.delegate = self;
    self.title = NSLocalizedString(@"Tags", nil);

    [super viewDidLoad];
}

- (NSString *)cellReuseIdentifier {
    // Needs to be static
    static NSString *cellReuseIdentifier = @"WPTag" ;

    return cellReuseIdentifier;
}

- (NSString *)cellNibName {
    return @"WPTagCell";
}


- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {

    WPTagCell *tagCell = (WPTagCell *) cell;

    WPTag *tag = self.dataSource[(NSUInteger) indexPath.row];
    tagCell.titleLabel.text = [tag capitalizedTitle];
    tagCell.itemCount = tag.postCount.intValue;
}

- (XBArrayDataSource *)buildDataSource {
    XBHttpClient *httpClient = [[XBPListConfigurationProvider provider] httpClient];
    XBBasicHttpQueryParamBuilder *httpQueryParamBuilder = [XBBasicHttpQueryParamBuilder builderWithDictionary:@{}];
    XBHttpJsonDataLoader *dataLoader = [XBHttpJsonDataLoader dataLoaderWithHttpClient:httpClient httpQueryParamBuilder:httpQueryParamBuilder resourcePath:@"/api/wordpress/tag"];
    XBJsonToArrayDataMapper *dataMapper = [XBJsonToArrayDataMapper mapperWithRootKeyPath:@"tags" typeClass:[WPTag class]];
    return [XBReloadableArrayDataSource dataSourceWithDataLoader:dataLoader dataMapper:dataMapper];
}

-(void)onSelectCell: (UITableViewCell *)cell forObject: (id) object withIndex: (NSIndexPath *)indexPath {

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    WPTag *tag = self.dataSource[(NSUInteger) indexPath.row];
    NSLog(@"Tag selected: %@", tag);

    WPPostTableViewController *postTableViewController = [[WPPostTableViewController alloc] initWithPostType:TAG identifier:tag.identifier];
    [self.appDelegate.mainViewController revealViewController:postTableViewController];
}

@end