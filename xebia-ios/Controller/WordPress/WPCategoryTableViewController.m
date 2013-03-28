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
#import "XBHttpArrayDataSourceConfiguration.h"
#import "NSDateFormatter+XBAdditions.h"

@implementation WPCategoryTableViewController

- (void)viewDidLoad {

    self.delegate = self;
    self.title = @"Categories";

    [super viewDidLoad];
}

- (NSString *)cellReuseIdentifier {
    // Needs to be static
    static NSString *cellReuseIdentifier = @"WPCategory";

    return cellReuseIdentifier;
}

- (NSString *)cellNibName {
    return @"WPCategoryCell";
}

- (XBHttpArrayDataSourceConfiguration *)configuration {

    XBHttpArrayDataSourceConfiguration* configuration = [XBHttpArrayDataSourceConfiguration configuration];
    configuration.resourcePath = @"/api/wordpress/categories";
    configuration.storageFileName = @"wp-categories.json";
    configuration.maxDataAgeInSecondsBeforeServerFetch = 120;
    configuration.typeClass = [WPCategory class];
    configuration.dateFormat = [NSDateFormatter initWithDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZ"];

    return configuration;
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {

    WPCategoryCell *categoryCell = (WPCategoryCell *) cell;

    WPCategory *category = self.dataSource[indexPath.row];
    categoryCell.titleLabel.text = category.title;
    [categoryCell setItemCount:[category.postCount intValue]];
}

-(void)onSelectCell: (UITableViewCell *)cell forObject: (id) object withIndex: (NSIndexPath *)indexPath {

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    WPCategory *category = self.dataSource[indexPath.row];
    NSLog(@"Category selected: %@", category);

    WPPostTableViewController *postTableViewController = [[WPPostTableViewController alloc] initWithPostType:CATEGORY identifier:category.identifier];
    [self.appDelegate.mainViewController revealViewController:postTableViewController];
}

@end