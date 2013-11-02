//
//  TTTweetTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "TTTweet.h"
#import "TTTweetTableViewController.h"
#import "TTTweetCell.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+XBAdditions.h"
#import "XBMainViewController.h"
#import "NSDateFormatter+XBAdditions.h"
#import "XBPListConfigurationProvider.h"
#import "XBBasicHttpQueryParamBuilder.h"
#import "XBHttpJsonDataLoader.h"
#import "XBJsonToArrayDataMapper.h"
#import "GAITracker.h"

@implementation TTTweetTableViewController

- (void)viewDidLoad {

    [self.appDelegate.tracker sendView:@"/twitter/timeline"];

    self.delegate = self;
    self.title = NSLocalizedString(@"Tweets", nil);

    [self customizeNavigationBarAppearance];
    [self addMenuButton];

    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (NSString *)tableView:(UITableView *)tableView cellReuseIdentifierAtIndexPath:(NSIndexPath *)indexPath {
    // Needs to be static
    static NSString *cellReuseIdentifier = @"TTTweet";

    return cellReuseIdentifier;
}

- (NSString *)tableView:(UITableView *)tableView cellNibNameAtIndexPath:(NSIndexPath *)indexPath {
    return @"TTTweetCell";
}

- (XBArrayDataSource *)buildDataSource {
    XBHttpClient *httpClient = [[XBPListConfigurationProvider provider] httpClient];
    XBBasicHttpQueryParamBuilder *httpQueryParamBuilder = [XBBasicHttpQueryParamBuilder builderWithDictionary:@{}];
    XBHttpJsonDataLoader *dataLoader = [XBHttpJsonDataLoader dataLoaderWithHttpClient:httpClient httpQueryParamBuilder:httpQueryParamBuilder resourcePath:@"/twitter/timeline"];
    XBJsonToArrayDataMapper *dataMapper = [XBJsonToArrayDataMapper mapperWithRootKeyPath:nil typeClass:[TTTweet class]];
    return [XBReloadableArrayDataSource dataSourceWithDataLoader:dataLoader dataMapper:dataMapper];
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {

    TTTweetCell *tweetCell = (TTTweetCell *) cell;

    TTTweet *tweet = self.dataSource[(NSUInteger) indexPath.row];

    [tweetCell updateWithTweet: tweet];
}

-(void)onSelectCell: (UITableViewCell *)cell forObject: (id) object withIndex: (NSIndexPath *)indexPath {
    TTTweet *tweet = self.dataSource[(NSUInteger) indexPath.row];

    NSURL *tweetStatusUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/%@/status/%@",
        tweet.retweeted_status ? tweet.retweeted_status.user.screen_name : tweet.user.screen_name,
        tweet.retweeted_status ? tweet.retweeted_status.identifier_str : tweet.identifier_str
    ]];
    NSLog(@"Url requested: %@", tweetStatusUrl);
    [self.appDelegate.mainViewController openURL:tweetStatusUrl withTitle:tweet.user.name];
}

@end