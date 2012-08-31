//
//  RKTTTwitterTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <RestKit/UI.h>
#import "RKTTTweet.h"
#import "RKTTTwitterTableViewController.h"
#import "RKXBLoadingView.h"
#import "RKTTTweetCell.h"
#import "SDImageCache.h"

#define FONT_SIZE 13.0f
#define CELL_CONTENT_WIDTH 253.0f
#define CELL_CONTENT_MARGIN 10.0f

@interface RKTTTwitterTableViewController ()
@property (nonatomic, strong) RKFetchedResultsTableController *tableController;
@end

@implementation RKTTTwitterTableViewController

UIImage* defaultAvatarImage;

@synthesize tableController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Tweets";
   
    if ([self.navigationController.parentViewController respondsToSelector:@selector(revealGesture:)] && [self.navigationController.parentViewController respondsToSelector:@selector(revealToggle:)])
	{
		UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
		[self.navigationController.navigationBar addGestureRecognizer:navigationBarPanGestureRecognizer];
        
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self.navigationController.parentViewController action:@selector(revealToggle:)];
	}
    
    defaultAvatarImage = [UIImage imageNamed:@"avatar_placeholder"];
    /**
     Configure the RestKit table controller to drive our view
     */
    self.tableController = [[RKObjectManager sharedManager] fetchedResultsTableControllerForTableViewController:self];
    self.tableController.delegate = self;

//    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"dateFormatted" ascending:YES];
//    self.tableController.fetchRequest.sortDescriptors = [NSArray arrayWithObject:descriptor];
  
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
    RKXBLoadingView *loadingView = [[RKXBLoadingView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    loadingView.center = self.tableView.center;
    self.tableController.loadingView = loadingView;
    
    /**
     Setup some images for various table states
     */
    self.tableController.imageForOffline = [UIImage imageNamed:@"offline.png"];
    self.tableController.imageForError = [UIImage imageNamed:@"error.png"];
    self.tableController.imageForEmpty = [UIImage imageNamed:@"empty.png"];

    RKTableViewCellMapping *cellMapping = [RKTableViewCellMapping cellMapping];
    cellMapping.cellClassName = @"RKTTTweetCell";
    cellMapping.reuseIdentifier = @"RKTTTweet";
//    cellMapping.rowHeight = 100.0;
    [cellMapping mapKeyPath:@"user.name" toAttribute:@"authorNameLabel.text"];
    [cellMapping mapKeyPath:@"user.screen_name" toAttribute:@"nicknameLabel.text"];
    [cellMapping mapKeyPath:@"dateFormatted" toAttribute:@"dateLabel.text"];
    [cellMapping mapKeyPath:@"text" toAttribute:@"contentLabel.text"];
    [cellMapping mapKeyPath:@"identifier" toAttribute:@"identifier"];
     
    cellMapping.heightOfCellForObjectAtIndexPath = ^ CGFloat(id object, NSIndexPath* indexPath) {
    
        RKTTTweet *tweet = object;
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        CGSize size = [tweet.text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        CGFloat height = MAX(size.height, 44.0f);
        return height + (CELL_CONTENT_MARGIN * 2);
    };
    
    [tableController mapObjectsWithClass:[RKTTTweet class] toTableCellsWithMapping:cellMapping];
    
    /**
     Use a custom Nib to draw our table cells for RKGHIssue objects
     */
    [self.tableView registerNib:[UINib nibWithNibName:@"RKTTTweetCell" bundle:nil] forCellReuseIdentifier:@"RKTTTweet"];
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
    RKTTTweet *tweet = object;
    RKTTTweetCell *tweetCell = (RKTTTweetCell *)cell;
 
    NSString *avatarImageUrl = [[tweet.user avatarImageUrl] absoluteString];
    UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromKey:avatarImageUrl];
    if (cachedImage) {
        [[tweetCell imageView] setImage: cachedImage];
    }
    else {
        [[tweetCell imageView] setImage: defaultAvatarImage];
        NSLog(@"Download image: %@ for tweet author: %@", [tweet.user avatarImageUrl], tweet.user.screen_name);
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadWithURL:tweet.user.avatarImageUrl
                        delegate:self
                         options:0
                         success:^(UIImage *image) {
                             [[SDImageCache sharedImageCache] storeImage:image forKey:avatarImageUrl];
                             if ([[tweetCell identifier] intValue] == [[tweet identifier] intValue]) {
                                 [[tweetCell imageView] setImage: image];   
                             }
                         }
                         failure:^(NSError *error) {
                             [[SDImageCache sharedImageCache] storeImage:defaultAvatarImage forKey:avatarImageUrl];
                             if ([[tweetCell identifier] intValue] == [[tweet identifier] intValue]) {
                                 [[tweetCell imageView] setImage: defaultAvatarImage];
                             }
                         }];
    }

    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if ([segue.identifier isEqualToString:@"showDetail"]) {        
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        RKWPAuthor *author = [self.tableController objectForRowAtIndexPath:indexPath];
//        [[segue destinationViewController] setAuthor:author];
//    }
}

@end