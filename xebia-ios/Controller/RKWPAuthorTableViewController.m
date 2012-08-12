//
//  RKWPAuthorTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <RestKit/UI.h>
#import "RKWPAuthor.h"
#import "RKWPAuthorTableViewController.h"
#import "RKWPLoadingView.h"
#import "SDWebImageManager.h"
#import "GravatarHelper.h"
#import "SDImageCache.h"

@interface RKWPAuthorTableViewController ()
@property (nonatomic, strong) RKFetchedResultsTableController *tableController;
@end

@implementation RKWPAuthorTableViewController

UIImage* defaultAvatarImage;
SDWebImageManager *manager;

@synthesize tableController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    manager = [SDWebImageManager sharedManager];

    defaultAvatarImage = [UIImage imageNamed:@"avatar_placeholder.png"];
    /**
     Configure the RestKit table controller to drive our view
     */
    self.tableController = [[RKObjectManager sharedManager] fetchedResultsTableControllerForTableViewController:self];
    self.tableController.delegate = self;
    self.tableController.autoRefreshFromNetwork = YES;
    self.tableController.pullToRefreshEnabled = YES;
    self.tableController.resourcePath = @"/get_author_index/";
    self.tableController.variableHeightRows = YES;
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    self.tableController.sortDescriptors = [NSArray arrayWithObject:descriptor];
    
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
    RKWPLoadingView *loadingView = [[RKWPLoadingView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    loadingView.center = self.tableView.center;
    self.tableController.loadingView = loadingView;
    
    /**
     Setup some images for various table states
     */
    self.tableController.imageForOffline = [UIImage imageNamed:@"offline.png"];
    self.tableController.imageForError = [UIImage imageNamed:@"error.png"];
    self.tableController.imageForEmpty = [UIImage imageNamed:@"empty.png"];

    RKTableViewCellMapping *cellMapping = [RKTableViewCellMapping cellMapping];
    cellMapping.cellClassName = @"RKWPAuthorCell";
    cellMapping.reuseIdentifier = @"RKWPAuthor";
//    cellMapping.rowHeight = 100.0;
    [cellMapping mapKeyPath:@"name" toAttribute:@"titleLabel.text"];
//    [cellMapping mapKeyPath:@"description_" toAttribute:@"descriptionLabel.text"];
//    [cellMapping mapKeyPath:@"image" toAttribute:@"imageView.image"];
     
    [tableController mapObjectsWithClass:[RKWPAuthor class] toTableCellsWithMapping:cellMapping];
    
    /**
     Use a custom Nib to draw our table cells for RKGHIssue objects
     */
    [self.tableView registerNib:[UINib nibWithNibName:@"RKWPAuthorCell" bundle:nil] forCellReuseIdentifier:@"RKWPAuthor"];
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
    RKWPAuthor *author = object;
    NSString *avatarImageUrl = [[author avatarImageUrl] absoluteString];
    UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromKey:avatarImageUrl];
    if (!cachedImage) {
        cell.imageView.image = defaultAvatarImage;
        NSLog(@"Download image: %@", [author avatarImageUrl]);
        [manager downloadWithURL:author.avatarImageUrl
                        delegate:self
                         options:0
                         success:^(UIImage *image) {
                             [[SDImageCache sharedImageCache] storeImage:image forKey:avatarImageUrl];
                             cell.imageView.image = image;
                         }
                         failure:^(NSError *error) {
                             [[SDImageCache sharedImageCache] storeImage:defaultAvatarImage forKey:avatarImageUrl];
                             cell.imageView.image = defaultAvatarImage;
                         }];
    }
    else {
        cell.imageView.image = cachedImage;
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