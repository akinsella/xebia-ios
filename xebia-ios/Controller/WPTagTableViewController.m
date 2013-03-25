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
#import "XBMainViewController.h"
#import "WPTagCell.h"
#import "XBHttpArrayDataSourceConfiguration.h"
#import "NSDateFormatter+XBAdditions.h"

@implementation WPTagTableViewController

- (void)viewDidLoad {

    self.delegate = self;
    self.title = @"Tags";

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

    WPTag *tag = self.dataSource[indexPath.row];
    tagCell.titleLabel.text = [tag capitalizedTitle];
    tagCell.itemCount = tag.postCount.intValue;
}

- (XBHttpArrayDataSourceConfiguration *)configuration {

    XBHttpArrayDataSourceConfiguration* configuration = [XBHttpArrayDataSourceConfiguration configuration];
    configuration.resourcePath = @"/api/wordpress/tags";
    configuration.storageFileName = @"wp-tags.json";
    configuration.maxDataAgeInSecondsBeforeServerFetch = 120;
    configuration.typeClass = [WPTag class];
    configuration.dateFormat = [NSDateFormatter initWithDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZ"];

    return configuration;
}

-(void)onSelectCell: (UITableViewCell *)cell forObject: (id) object withIndex: (NSIndexPath *)indexPath {

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    WPTag *tag = self.dataSource[indexPath.row];
    NSLog(@"Tag selected: %@", tag);

    WPPostTableViewController *postTableViewController = [[WPPostTableViewController alloc] initWithPostType:TAG identifier:tag.identifier];
    [self.appDelegate.mainViewController revealViewController:postTableViewController];
}

@end