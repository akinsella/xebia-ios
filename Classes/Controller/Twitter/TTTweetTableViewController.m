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

@interface TTTweetTableViewController ()
@property (nonatomic, strong) UIImage* defaultAvatarImage;
@property (nonatomic, strong) UIImage* xebiaAvatarImage;
@end

@implementation TTTweetTableViewController

- (void)viewDidLoad {

    [self.appDelegate.tracker sendView:@"/twitter/timeline"];

    self.delegate = self;
    self.title = NSLocalizedString(@"Tweets", nil);

    self.defaultAvatarImage = [UIImage imageNamed:@"avatar_placeholder"];
    self.xebiaAvatarImage = [UIImage imageNamed:@"xebia-avatar"];

    [self addMenuButton];

    [super viewDidLoad];
}

- (NSString *)cellReuseIdentifier {
    // Needs to be static
    static NSString *cellReuseIdentifier = @"TTTweet";

    return cellReuseIdentifier;
}

- (NSString *)cellNibName {
    return @"TTTweetCell";
}

- (XBArrayDataSource *)buildDataSource {
    XBHttpClient *httpClient = [[XBPListConfigurationProvider provider] httpClient];
    XBBasicHttpQueryParamBuilder *httpQueryParamBuilder = [XBBasicHttpQueryParamBuilder builderWithDictionary:@{}];
    XBHttpJsonDataLoader *dataLoader = [XBHttpJsonDataLoader dataLoaderWithHttpClient:httpClient httpQueryParamBuilder:httpQueryParamBuilder resourcePath:@"/api/twitter/timeline"];
    XBJsonToArrayDataMapper *dataMapper = [XBJsonToArrayDataMapper mapperWithRootKeyPath:nil typeClass:[TTTweet class]];
    return [XBReloadableArrayDataSource dataSourceWithDataLoader:dataLoader dataMapper:dataMapper];
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {

    TTTweetCell *tweetCell = (TTTweetCell *) cell;
    [tweetCell configure];

    TTTweet *tweet = self.dataSource[(NSUInteger) indexPath.row];

    tweetCell.contentLabel.delegate = self;
    if ([tweet.ownerScreenName isEqualToString:@"XebiaFr"]) {
        tweetCell.imageView.image = self.xebiaAvatarImage;
    }
    else {
        [tweetCell.imageView setImageWithURL:tweet.ownerImageUrl placeholderImage:self.defaultAvatarImage];
    }

    tweetCell.authorNameLabel.text = tweet.ownerScreenName;
    tweetCell.identifier = tweet.identifier;
    tweetCell.dateLabel.text = tweet.dateFormatted;
    tweetCell.content = tweet.text;
    tweetCell.contentLabel.text = tweet.text;
    tweetCell.hashtags = tweet.entities.hashtags;
    tweetCell.urls = tweet.entities.urls;
    tweetCell.user_mentions = tweet.entities.user_mentions;
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    NSLog(@"Url requested: %@", url);
    [self.appDelegate.mainViewController openURL:url withTitle:@"Twitter"];
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