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
#import "UITableViewCell+XBAdditions.h"

@interface TTTweetTableViewController ()
@property (nonatomic, strong) RKTableController *tableController;
@property (nonatomic, strong) UIImage* defaultAvatarImage;
@property (nonatomic, strong) UIImage* xebiaAvatarImage;
@end

@implementation TTTweetTableViewController

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"Tweets";
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.tableController loadTableFromResourcePath:@"/twitter/user/XebiaFR"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
}

- (void)configure {
    self.defaultAvatarImage = [UIImage imageNamed:@"avatar_placeholder"];
    self.xebiaAvatarImage = [UIImage imageNamed:@"xebia-avatar"];

    [self addRevealGesture];
    [self addMenuButton];

    [self configureTableController];
    [self configureRefreshTriggerView];

    [self configureTableView];
}

- (void)configureTableView {
    self.tableView.backgroundColor = [UIColor colorWithPatternImageName:@"bg_home_pattern"];
//    self.tableView.backgroundColor = [UIColor colorWithHex:@"#191919" alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.tableView registerNib:[UINib nibWithNibName:@"TTTweetCell" bundle:nil] forCellReuseIdentifier:@"TTTweet"];
}

- (void)configureTableController {
    self.tableController = [[RKObjectManager sharedManager] tableControllerForTableViewController:self];

    self.tableController.delegate = self;

    self.tableController.autoRefreshFromNetwork = YES;
    self.tableController.pullToRefreshEnabled = YES;
    self.tableController.variableHeightRows = YES;

    self.tableController.imageForOffline = [UIImage imageNamed:@"offline.png"];
    self.tableController.imageForError = [UIImage imageNamed:@"error.png"];
    self.tableController.imageForEmpty = [UIImage imageNamed:@"empty.png"];

    [self.tableController mapObjectsWithClass:[TTTweet class] toTableCellsWithMapping: [self getCellMapping]];
}

- (void)configureRefreshTriggerView {
    NSBundle *restKitResources = [NSBundle restKitResourcesBundle];
    UIImage *arrowImage = [restKitResources imageWithContentsOfResource:@"blueArrow" withExtension:@"png"];
    [[RKRefreshTriggerView appearance] setTitleFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13]];
    [[RKRefreshTriggerView appearance] setLastUpdatedFont:[UIFont fontWithName:@"HelveticaNeue" size:11]];
    [[RKRefreshTriggerView appearance] setArrowImage:arrowImage];
}

- (RKTableViewCellMapping *)getCellMapping {
    RKTableViewCellMapping *cellMapping = [RKTableViewCellMapping cellMapping];
    cellMapping.cellClassName = @"TTTweetCell";
    cellMapping.reuseIdentifier = @"TTTweet";

    [cellMapping mapKeyPath:@"user.name" toAttribute:@"authorNameLabel.text"];
    [cellMapping mapKeyPath:@"dateFormatted" toAttribute:@"dateLabel.text"];
    [cellMapping mapKeyPath:@"text" toAttribute:@"content"];
    [cellMapping mapKeyPath:@"entities" toAttribute:@"entities"];
    [cellMapping mapKeyPath:@"identifier" toAttribute:@"identifier"];

    cellMapping.heightOfCellForObjectAtIndexPath = ^ CGFloat(TTTweet *tweet, NSIndexPath* indexPath) {
        CGFloat heightForCellWithText = [TTTweetCell heightForCellWithText:tweet.text];
        NSLog(@"Height: %f for cell with text: %@", heightForCellWithText, tweet.text);
        return heightForCellWithText;
    };

    cellMapping.onSelectCellForObjectAtIndexPath = ^(UITableViewCell *cell, id object, NSIndexPath* indexPath) {
        TTTweet *tweet = [self.tableController objectForRowAtIndexPath:indexPath];

        NSURL *tweetStatusUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/%@/status/%@",
                        tweet.retweeted_status ? tweet.retweeted_status.user.screen_name : tweet.user.screen_name,
                        tweet.retweeted_status ? tweet.retweeted_status.identifier_str : tweet.identifier_str
        ]];
        NSLog(@"Url requested: %@", tweetStatusUrl);
        [self.appDelegate.mainViewController openURL:tweetStatusUrl withTitle:tweet.user.name];
    };


    return cellMapping;
}

- (void)tableController:(RKAbstractTableController *)tableController
        willDisplayCell:(TTTweetCell *)tweetCell
              forObject:(TTTweet *)tweet
            atIndexPath:(NSIndexPath *)indexPath {
    tweetCell.contentLabel.delegate = self;
    if ([tweet.ownerScreenName isEqualToString:@"XebiaFr"]) {
        tweetCell.imageView.image = self.xebiaAvatarImage;
    }
    else {
        [tweetCell.imageView setImageWithURL:tweet.ownerImageUrl placeholderImage:self.defaultAvatarImage];
    }
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    NSLog(@"Url requested: %@", url);
    [self.appDelegate.mainViewController openURL:url withTitle:@"Twitter"];
}

- (void)didReceiveMemoryWarning{
    NSLog(@"Did received a memory warning in controller: %@", [self class]);
    [super didReceiveMemoryWarning];
}

@end