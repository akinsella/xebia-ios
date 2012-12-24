//
//  TTTweetTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <RestKit/UI.h>
#import "TTTweet.h"
#import "TTTweetTableViewController.h"
#import "XBLoadingView.h"
#import "TTTweetCell.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "UINavigationBar+XBAdditions.h"
#import "UIViewController+XBAdditions.h"
#import "UIColor+XBAdditions.h"
#import "UIScreen+XBAdditions.h"
#import "XBWebViewController.h"
#import "XBMainViewController.h"

@interface TTTweetTableViewController ()
@property (nonatomic, strong) UIImage* defaultAvatarImage;
@property (nonatomic, strong) UIImage* xebiaAvatarImage;
@end

@implementation TTTweetTableViewController

- (void)viewDidLoad {

    self.delegate = self;
    self.title = @"Tweets";

    self.defaultAvatarImage = [UIImage imageNamed:@"avatar_placeholder"];
    self.xebiaAvatarImage = [UIImage imageNamed:@"xebia-avatar"];

    [self addRevealGesture];
    [self addMenuButton];

    [super viewDidLoad];
}

- (int)maxDataAgeInSecondsBeforeServerFetch {
    return 120;
}

- (Class)dataClass {
    return [TTTweet class];
}

- (NSString *)cellReuseIdentifier {
    // Needs to be static
    static NSString *cellReuseIdentifier = @"TTTweet";

    return cellReuseIdentifier;
}

- (NSString *)cellNibName {
    return @"TTTweetCell";
}

- (NSString *)resourcePath {
    return @"/api/twitter/timeline";
}

- (NSArray *)fetchDataFromDB {
    return [[self dataClass] MR_findAllSortedBy:@"created_at" ascending:NO];
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {

    TTTweetCell *tweetCell = (TTTweetCell *) cell;
    [tweetCell configure];

    TTTweet *tweet = [self objectAtIndex:(NSUInteger) indexPath.row];

    tweetCell.contentLabel.delegate = self;
    if ([tweet.ownerScreenName isEqualToString:@"XebiaFr"]) {
        tweetCell.imageView.image = self.xebiaAvatarImage;
    }
    else {
        [tweetCell.imageView setImageWithURL:tweet.ownerImageUrl placeholderImage:self.defaultAvatarImage];
    }

    tweetCell.identifier = tweet.identifier;
    tweetCell.dateLabel.text = tweet.dateFormatted;
    tweetCell.content = tweet.text;
    tweetCell.contentLabel.text = tweet.text;
    tweetCell.hashtags = tweet.hashtags;
    tweetCell.urls = tweet.urls;
    tweetCell.user_mentions = tweet.user_mentions;
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    NSLog(@"Url requested: %@", url);
    [self.appDelegate.mainViewController openURL:url withTitle:@"Twitter"];
}

-(void)onSelectCell: (UITableViewCell *)cell forObject: (id) object withIndex: (NSIndexPath *)indexPath {
    TTTweet *tweet = [self objectAtIndex:(NSUInteger) indexPath.row];

    NSURL *tweetStatusUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/%@/status/%@",
        tweet.retweeted_status ? tweet.retweeted_status.user.screen_name : tweet.user.screen_name,
        tweet.retweeted_status ? tweet.retweeted_status.identifier_str : tweet.identifier_str
    ]];
    NSLog(@"Url requested: %@", tweetStatusUrl);
    [self.appDelegate.mainViewController openURL:tweetStatusUrl withTitle:tweet.user.name];
}

@end