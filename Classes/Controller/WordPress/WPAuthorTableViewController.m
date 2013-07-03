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
#import "NSDateFormatter+XBAdditions.h"
#import "XBPListConfigurationProvider.h"
#import "XBBasicHttpQueryParamBuilder.h"
#import "XBHttpJsonDataLoader.h"
#import "XBJsonToArrayDataMapper.h"
#import "GAITracker.h"

@interface WPAuthorTableViewController ()
@property (nonatomic, strong) UIImage* defaultAvatarImage;
@end

@implementation WPAuthorTableViewController

- (void)viewDidLoad {

    [self.appDelegate.tracker sendView:@"/wordpress/author"];

    self.delegate = self;
    self.tableView.rowHeight = 60;
    self.title = NSLocalizedString(@"Authors", nil);
    self.defaultAvatarImage = [UIImage imageNamed:@"avatar_placeholder"];

    [super viewDidLoad];
}

- (NSString *)cellReuseIdentifier {
    // Needs to be static
    static NSString *cellReuseIdentifier = @"WPAuthor";

    return cellReuseIdentifier;
}

- (NSString *)cellNibName {
    return @"WPAuthorCell";
}

- (XBArrayDataSource *)buildDataSource {

    XBHttpClient *httpClient = [[XBPListConfigurationProvider provider] httpClient];
    XBBasicHttpQueryParamBuilder *httpQueryParamBuilder = [XBBasicHttpQueryParamBuilder builderWithDictionary:@{}];
    XBHttpJsonDataLoader *dataLoader = [XBHttpJsonDataLoader dataLoaderWithHttpClient:httpClient httpQueryParamBuilder:httpQueryParamBuilder resourcePath:@"/api/wordpress/author"];
    XBJsonToArrayDataMapper *dataMapper = [XBJsonToArrayDataMapper mapperWithRootKeyPath:@"authors" typeClass:[WPAuthor class]];
    return [XBReloadableArrayDataSource dataSourceWithDataLoader:dataLoader dataMapper:dataMapper];
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {

    WPAuthorCell *authorCell = (WPAuthorCell *) cell;

    WPAuthor *author = self.dataSource[(NSUInteger) indexPath.row];
    authorCell.identifier = author.identifier;
    authorCell.titleLabel.text = author.name;

    [authorCell.imageView setImageWithURL:[author avatarImageUrl] placeholderImage:self.defaultAvatarImage];
}

-(void)onSelectCell: (UITableViewCell *)cell forObject: (id) object withIndex: (NSIndexPath *)indexPath {

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    WPAuthor *author = self.dataSource[(NSUInteger) indexPath.row];
    NSLog(@"Author selected: %@", author);

    WPPostTableViewController *postTableViewController = [[WPPostTableViewController alloc] initWithPostType:AUTHOR identifier:author.identifier];
    [self.appDelegate.mainViewController revealViewController:postTableViewController];
}

@end