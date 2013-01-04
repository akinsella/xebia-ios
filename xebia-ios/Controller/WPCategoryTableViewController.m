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

@implementation WPCategoryTableViewController

- (void)viewDidLoad {

    self.delegate = self;
    self.title = @"Categories";

    [super viewDidLoad];
}

- (int)maxDataAgeInSecondsBeforeServerFetch {
    return 120;
}

- (Class)dataClass {
    return [WPCategory class];
}

- (NSString *)cellReuseIdentifier {
    // Needs to be static
    static NSString *cellReuseIdentifier = @"WPCategory";

    return cellReuseIdentifier;
}

- (NSString *)cellNibName {
    return @"WPCategoryCell";
}

- (NSString *)resourcePath {
    return @"/api/wordpress/categories";
}

- (NSArray *)fetchDataFromDB {
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    return [[self dataClass] MR_findAllSortedBy:@"title" ascending:YES inContext:localContext];
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {

    WPCategoryCell *categoryCell = (WPCategoryCell *) cell;

    WPCategory *category = [self objectAtIndex:(NSUInteger) indexPath.row];
    categoryCell.titleLabel.text = category.title;
    [categoryCell setItemCount:[category.post_count intValue]];
}

-(void)onSelectCell: (UITableViewCell *)cell forObject: (id) object withIndex: (NSIndexPath *)indexPath {

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    WPCategory *category = [self objectAtIndex:(NSUInteger) indexPath.row];
    NSLog(@"Category selected: %@", category);

    WPPostTableViewController *postTableViewController = [[WPPostTableViewController alloc] initWithPostType:CATEGORY identifier:category.identifier];
    [self.appDelegate.mainViewController revealViewController:postTableViewController];
}

@end