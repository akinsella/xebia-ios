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

@implementation WPTagTableViewController

- (void)viewDidLoad {

    self.delegate = self;
    self.title = @"Tags";

    [super viewDidLoad];
}

- (int)maxDataAgeInSecondsBeforeServerFetch {
    return 120;
}

- (Class)dataClass {
    return [WPTag class];
}

- (NSString *)cellReuseIdentifier {
    // Needs to be static
    static NSString *cellReuseIdentifier = @"WPTag" ;

    return cellReuseIdentifier;
}

- (NSString *)cellNibName {
    return @"WPTagCell";
}

- (NSString *)resourcePath {
    return @"/api/wordpress/tags";
}

- (NSArray *)fetchDataFromDB {
    return [[self dataClass] MR_findAllSortedBy:@"title" ascending:YES];
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {

    WPTagCell *tagCell = (WPTagCell *) cell;

    WPTag *tag = [self objectAtIndex:(NSUInteger) indexPath.row];
    tagCell.titleLabel.text = [tag capitalizedTitle];
    tagCell.itemCount = tag.postCount.intValue;
}



-(void)onSelectCell: (UITableViewCell *)cell forObject: (id) object withIndex: (NSIndexPath *)indexPath {

    WPTag *tag = [self objectAtIndex:(NSUInteger) indexPath.row];
    NSLog(@"Tag selected: %@", tag);

    WPPostTableViewController *postTableViewController = [[WPPostTableViewController alloc] initWithPostType:TAG identifier:tag.identifier];
    [self.appDelegate.mainViewController revealViewController:postTableViewController];
}

@end