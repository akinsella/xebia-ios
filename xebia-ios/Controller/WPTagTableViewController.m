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
#import "JSONKit.h"

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

- (NSString *)storageFileName {
    return @"wp-tags.json";
}

- (NSString *)cellNibName {
    return @"WPTagCell";
}

- (NSString *)resourcePath {
    return @"/api/wordpress/tags";
}

//- (NSDictionary *)fetchDataFromDB {
////    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
////    return [[self dataClass] MR_findAllSortedBy:@"title" ascending:YES inContext:localContext];
//
//    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"wp-tags.json"];
//    NSLog(@"WPTags Json path: %@", filePath);
//
//    NSString *fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//    NSDictionary *json = [fileContent objectFromJSONString];
//
//    return json;
//
//}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {

    WPTagCell *tagCell = (WPTagCell *) cell;

    WPTag *tag = [self objectAtIndex:(NSUInteger) indexPath.row];
    tagCell.titleLabel.text = [tag capitalizedTitle];
    tagCell.itemCount = tag.postCount.intValue;
}

-(void)onSelectCell: (UITableViewCell *)cell forObject: (id) object withIndex: (NSIndexPath *)indexPath {

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    WPTag *tag = [self objectAtIndex:(NSUInteger) indexPath.row];
    NSLog(@"Tag selected: %@", tag);

    WPPostTableViewController *postTableViewController = [[WPPostTableViewController alloc] initWithPostType:TAG identifier:tag.identifier];
    [self.appDelegate.mainViewController revealViewController:postTableViewController];
}

@end