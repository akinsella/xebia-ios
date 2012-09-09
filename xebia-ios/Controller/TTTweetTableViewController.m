//
//  TTTwitterTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
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

#define FONT_SIZE 13.0f
#define CELL_CONTENT_WIDTH 232.0f
#define CELL_MIN_HEIGHT 64.0f
#define CELL_BASE_HEIGHT 48.0f
#define CELL_MAX_HEIGHT 1000.0f

@interface TTTweetTableViewController ()
@property (nonatomic, strong) RKFetchedResultsTableController *tableController;
@end

@implementation TTTweetTableViewController

UIImage* defaultAvatarImage;

@synthesize tableController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Tweets";
    
    [self addRevealGesture];
    [self addMenuButton];
    
    defaultAvatarImage = [UIImage imageNamed:@"avatar_placeholder"];

    /**
     Configure the RestKit table controller to drive our view
     */
    self.tableController = [[RKObjectManager sharedManager] fetchedResultsTableControllerForTableViewController:self];
    self.tableController.delegate = self;

    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"create_at" ascending:NO];
    self.tableController.fetchRequest.sortDescriptors = [NSArray arrayWithObject:descriptor];
  
    self.tableController.showsSectionIndexTitles = FALSE;
    self.tableController.autoRefreshFromNetwork = YES;
    self.tableController.pullToRefreshEnabled = YES;
    self.tableController.resourcePath = @"/twitter/XebiaFR/";
    self.tableController.variableHeightRows = YES;
    
    /**
     Configure the Pull to Refresh View
     */
    NSBundle *restKitResources = [NSBundle restKitResourcesBundle];
    UIImage *arrowImage = [restKitResources imageWithContentsOfResource:@"blueArrow" withExtension:@"png"];
    [[RKRefreshTriggerView appearance] setTitleFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13]];
    [[RKRefreshTriggerView appearance] setLastUpdatedFont:[UIFont fontWithName:@"HelveticaNeue" size:11]];
    [[RKRefreshTriggerView appearance] setArrowImage:arrowImage];
    
    /**
     Configure a basic loading view
     */
    XBLoadingView *loadingView = [[XBLoadingView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    loadingView.center = self.tableView.center;
    self.tableController.loadingView = loadingView;
    
    /**
     Setup some images for various table states
     */
    self.tableController.imageForOffline = [UIImage imageNamed:@"offline.png"];
    self.tableController.imageForError = [UIImage imageNamed:@"error.png"];
    self.tableController.imageForEmpty = [UIImage imageNamed:@"empty.png"];

    RKTableViewCellMapping *cellMapping = [RKTableViewCellMapping cellMapping];
    cellMapping.cellClassName = @"TTTweetCell";
    cellMapping.reuseIdentifier = @"TTTweet";
//    cellMapping.rowHeight = 100.0;
    [cellMapping mapKeyPath:@"user.name" toAttribute:@"authorNameLabel.text"];
    [cellMapping mapKeyPath:@"user.screen_name" toAttribute:@"nicknameLabel.text"];
    [cellMapping mapKeyPath:@"dateFormatted" toAttribute:@"dateLabel.text"];
    [cellMapping mapKeyPath:@"text" toAttribute:@"contentLabel.text"];
    [cellMapping mapKeyPath:@"identifier" toAttribute:@"identifier"];
     
    cellMapping.heightOfCellForObjectAtIndexPath = ^ CGFloat(id object, NSIndexPath* indexPath) {
    
        TTTweet *tweet = object;
        
        //        NSLog(@"----------------------------------------------------------------------");
        //        NSLog(@"Repository name: %@", repository.name);
        
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH, CELL_MAX_HEIGHT);
        //        NSLog(@"Constraint[width: %f, height: %f]", constraint.width, constraint.height);
        
        CGSize size = [tweet.text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE]
                                          constrainedToSize:constraint
                                              lineBreakMode:UILineBreakModeWordWrap];
        
        //        NSLog(@"Size[width: %f, height: %f]", size.width, size.height);
        
        CGFloat height = MAX(CELL_BASE_HEIGHT + size.height, CELL_MIN_HEIGHT);
        //        NSLog(@"Height: %f", height);
        
        return height;
    };
    
    [tableController mapObjectsWithClass:[TTTweet class] toTableCellsWithMapping:cellMapping];
    
    /**
     Use a custom Nib to draw our table cells for GHIssue objects
     */
    [self.tableView registerNib:[UINib nibWithNibName:@"TTTweetCell" bundle:nil] forCellReuseIdentifier:@"TTTweet"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /**
     Load the table view!
     */
    [tableController loadTable];
}

- (void)tableController:(RKAbstractTableController *)tableController willDisplayCell:(UITableViewCell *)cell forObject:(id)object atIndexPath:(NSIndexPath *)indexPath;
{
    TTTweet *tweet = object;
    TTTweetCell *tweetCell = (TTTweetCell *)cell;
    [tweetCell.imageView setImageWithURL:[tweet.user avatarImageUrl] placeholderImage:defaultAvatarImage];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if ([segue.identifier isEqualToString:@"showDetail"]) {        
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        WPAuthor *author = [self.tableController objectForRowAtIndexPath:indexPath];
//        [[segue destinationViewController] setAuthor:author];
//    }
}

@end