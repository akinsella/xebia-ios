//
//  RKGHRepositoryTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <RestKit/UI.h>
#import "RKGHRepository.h"
#import "RKGHRepositoryTableViewController.h"
#import "RKXBLoadingView.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "RKGHRepositoryCell.h"

#define FONT_SIZE 13.0f
#define CELL_CONTENT_WIDTH 253.0f
#define CELL_CONTENT_MARGIN 10.0f

@interface RKGHRepositoryTableViewController ()
@property (nonatomic, strong) RKFetchedResultsTableController *tableController;
@end

@implementation RKGHRepositoryTableViewController

UIImage* defaultAvatarImage;

@synthesize tableController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Repositories";
   
    if ([self.navigationController.parentViewController respondsToSelector:@selector(revealGesture:)] && [self.navigationController.parentViewController respondsToSelector:@selector(revealToggle:)])
	{
		UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
		[self.navigationController.navigationBar addGestureRecognizer:navigationBarPanGestureRecognizer];
        
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self.navigationController.parentViewController action:@selector(revealToggle:)];
	}
    
    defaultAvatarImage = [UIImage imageNamed:@"github_gravatar_placeholder"];
    
    /**
     Configure the RestKit table controller to drive our view
     */
    self.tableController = [[RKObjectManager sharedManager] fetchedResultsTableControllerForTableViewController:self];
    self.tableController.delegate = self;

    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    self.tableController.fetchRequest.sortDescriptors = [NSArray arrayWithObject:descriptor];
  
    self.tableController.showsSectionIndexTitles = FALSE;
    self.tableController.autoRefreshFromNetwork = YES;
    self.tableController.pullToRefreshEnabled = YES;
    self.tableController.resourcePath = @"/github/orgs/xebia-france/repos";
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
    cellMapping.cellClassName = @"RKGHRepositoryCell";
    cellMapping.reuseIdentifier = @"RKGHRepository";
//    cellMapping.rowHeight = 100.0;
    [cellMapping mapKeyPath:@"name" toAttribute:@"titleLabel.text"];
    [cellMapping mapKeyPath:@"description_" toAttribute:@"descriptionLabel.text"];
    [cellMapping mapKeyPath:@"identifier" toAttribute:@"identifier"];
     
    cellMapping.heightOfCellForObjectAtIndexPath = ^ CGFloat(id object, NSIndexPath* indexPath) {
    
        RKGHRepository *repository = object;
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        CGSize size = [repository.description_ sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        CGFloat height = MAX(size.height, 22.0f);
        return height + (CELL_CONTENT_MARGIN * 2);
    };
    
    [tableController mapObjectsWithClass:[RKGHRepository class] toTableCellsWithMapping:cellMapping];
    
    /**
     Use a custom Nib to draw our table cells for RKGHIssue objects
     */
    [self.tableView registerNib:[UINib nibWithNibName:@"RKGHRepositoryCell" bundle:nil] forCellReuseIdentifier:@"RKGHRepository"];
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
    RKGHRepository *repository = object;
    RKGHRepositoryCell *repositoryCell = (RKGHRepositoryCell *)cell;
 
    NSString *avatarImageUrl = repository.owner.avatar_url;
    UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromKey:avatarImageUrl];
    if (cachedImage) {
        [[repositoryCell imageView] setImage: cachedImage];
    }
    else {
        [[repositoryCell imageView] setImage: defaultAvatarImage];
        NSLog(@"Download image: %@ for repository: %@", repository.owner.avatar_url, repository.name);
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadWithURL: [NSURL URLWithString:repository.owner.avatar_url]
                        delegate:self
                         options:0
                         success:^(UIImage *image) {
                             [[SDImageCache sharedImageCache] storeImage:image forKey:avatarImageUrl];
                             if ([[repositoryCell identifier] intValue] == [[repository identifier] intValue]) {
                                 [[repositoryCell imageView] setImage: image];   
                             }
                         }
                         failure:^(NSError *error) {
                             [[SDImageCache sharedImageCache] storeImage:defaultAvatarImage forKey:avatarImageUrl];
                             if ([[repository identifier] intValue] == [[repository identifier] intValue]) {
                                 [[repository imageView] setImage: defaultAvatarImage];
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