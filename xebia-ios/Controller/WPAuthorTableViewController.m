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

@interface WPAuthorTableViewController ()
@property (nonatomic, strong) UIImage* defaultAvatarImage;
@end

@implementation WPAuthorTableViewController

- (void)viewDidLoad {

    self.delegate = self;
    self.tableView.rowHeight = 64;
    self.title = @"Authors";
    self.defaultAvatarImage = [UIImage imageNamed:@"avatar_placeholder"];

    [super viewDidLoad];
}

- (int)maxDataAgeInSecondsBeforeServerFetch {
    return 120;
}

- (Class)dataClass {
    return [WPAuthor class];
}

- (NSString *)cellReuseIdentifier {
    // Needs to be static
    static NSString *cellReuseIdentifier = @"WPAuthor";

    return cellReuseIdentifier;
}

- (NSString *)cellNibName {
    return @"WPAuthorCell";
}

- (NSString *)resourcePath {
    return @"/api/wordpress/authors";
}

- (NSArray *)fetchDataFromDB {
    return [[self dataClass] MR_findAllSortedBy:@"name" ascending:YES];
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {

    WPAuthorCell *authorCell = (WPAuthorCell *) cell;

    WPAuthor *author = [self objectAtIndex:(NSUInteger) indexPath.row];
    authorCell.identifier = author.identifier;
    authorCell.titleLabel.text = author.name;

    [authorCell.imageView setImageWithURL:[author avatarImageUrl] placeholderImage:self.defaultAvatarImage];
}

-(void)onSelectCell: (UITableViewCell *)cell forObject: (id) object withIndex: (NSIndexPath *)indexPath {

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    WPAuthor *author = [self objectAtIndex:(NSUInteger) indexPath.row];
    NSLog(@"Author selected: %@", author);

    WPPostTableViewController *postTableViewController = [[WPPostTableViewController alloc] initWithPostType:AUTHOR identifier:author.identifier];
    [self.appDelegate.mainViewController revealViewController:postTableViewController];
}

@end