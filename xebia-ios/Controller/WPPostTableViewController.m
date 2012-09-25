//
//  WPPostTableViewController.m
//  Xebia Application
//
//  Created by Alexis Kinsella on 14/06/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//


#import <RestKit/RestKit.h>
#import <RestKit/UI.h>
#import "WPPost.h"
#import "WPPostTableViewController.h"
#import "XBLoadingView.h"
#import "WPPostCell.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "WPPost.h"

#define FONT_SIZE 13.0f
#define CELL_CONTENT_WIDTH 232.0f
#define CELL_MIN_HEIGHT 64.0f
#define CELL_BASE_HEIGHT 48.0f
#define CELL_MAX_HEIGHT 1000.0f

@interface WPPostTableViewController ()
@property (nonatomic, strong) RKFetchedResultsTableController *tableController;
@end

@implementation WPPostTableViewController

UIImage* defaultPostImage;
NSMutableDictionary *postTypes;

@synthesize tableController;
@synthesize identifier, postType;

-(id)initWithPostType:(POST_TYPE)postType identifier:(NSNumber *)identifier
{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self != nil) {
        self.postType = postType;
        self.identifier = identifier;
        
        postTypes = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                           @"recent",  [[NSNumber numberWithInt: RECENT] description],
                           @"author", [[NSNumber numberWithInt: AUTHOR] description],
                           @"tag", [[NSNumber numberWithInt: TAG] description],
                           @"category", [[NSNumber numberWithInt: CATEGORY] description],
                           nil];

        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Posts";
    
    defaultPostImage = [UIImage imageNamed:@"avatar_placeholder"];
    
    /**
     Configure the RestKit table controller to drive our view
     */
    self.tableController = [[RKObjectManager sharedManager] fetchedResultsTableControllerForTableViewController:self];
    self.tableController.delegate = self;
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    self.tableController.fetchRequest.sortDescriptors = [NSArray arrayWithObject:descriptor];
    
    self.tableController.showsSectionIndexTitles = FALSE;
    self.tableController.autoRefreshFromNetwork = YES;
    self.tableController.pullToRefreshEnabled = YES;

    NSString *currentPostType = [postTypes valueForKey:[[NSNumber numberWithInt: postType] description]];

    self.tableController.resourcePath = [NSString stringWithFormat: @"/wordpress/get_%@_posts/?id=%@&count=100", currentPostType, identifier];
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
    cellMapping.cellClassName = @"WPPostCell";
    cellMapping.reuseIdentifier = @"WPPost";
    //    cellMapping.rowHeight = 100.0;
    [cellMapping mapKeyPath:@"title" toAttribute:@"titleLabel.text"];
    [cellMapping mapKeyPath:@"excerptTrim" toAttribute:@"excerptLabel.text"];
    [cellMapping mapKeyPath:@"dateFormatted" toAttribute:@"dateLabel.text"];
    [cellMapping mapKeyPath:@"identifier" toAttribute:@"identifier"];
    
    cellMapping.heightOfCellForObjectAtIndexPath = ^ CGFloat(id object, NSIndexPath* indexPath) {
        
        WPPost *post = object;
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH, CELL_MAX_HEIGHT);
        
        CGSize size = [post.excerptTrim sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE]
                             constrainedToSize:constraint
                                 lineBreakMode:UILineBreakModeWordWrap];
        
        CGFloat height = MAX(CELL_BASE_HEIGHT + size.height, CELL_MIN_HEIGHT);
        
        return height;
    };

    
    [tableController mapObjectsWithClass:[WPPost class] toTableCellsWithMapping:cellMapping];
    
    /**
     Use a custom Nib to draw our table cells for GHIssue objects
     */
    [self.tableView registerNib:[UINib nibWithNibName:@"WPPostCell" bundle:nil] forCellReuseIdentifier:@"WPPost"];
    [loadingView release];
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
    WPPost *post = object;
    WPPostCell *postCell = (WPPostCell *)cell;
    [postCell.imageView setImageWithURL:[post imageUrl] placeholderImage:defaultPostImage];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if ([segue.identifier isEqualToString:@"showDetail"]) {
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        WPAuthor *author = [self.tableController objectForRowAtIndexPath:indexPath];
//        [[segue destinationViewController] loadWithPostType:AUTHOR identifier:author.identifier];
//    }
}

@end
