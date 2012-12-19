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
#import "UIColor+XBAdditions.h"
#import "NSNumber+XBAdditions.h"
#import "SHK.h"
#import "UIViewController+XBAdditions.h"
#import "XBMainViewController.h"
#import "XBShareInfo.h"
#import "WPCategory.h"

@interface WPPostTableViewController ()
@property (nonatomic, strong) NSMutableDictionary *postTypes;
@property (nonatomic, strong) RKTableController *tableController;
@property (nonatomic, strong) UIImage *defaultPostImage;
@property (nonatomic, strong) UIImage *xebiaPostImage;
@property(nonatomic, assign) POST_TYPE postType;
@property(nonatomic, copy) NSNumber *identifier;
@end

@implementation WPPostTableViewController

-(id)initWithPostType:(POST_TYPE)pPostType identifier:(NSNumber *)pIdentifier
{
    self = [super initWithStyle:UITableViewStylePlain];

    if (self) {
        [self initInternalWithPostType:pPostType identifier:pIdentifier];
    }

    return self;
}

- (void)initInternalWithPostType:(POST_TYPE)pPostType identifier:(NSNumber *)pIdentifier {
    self.title = @"Posts";
    self.defaultPostImage = [UIImage imageNamed:@"avatar_placeholder"];
    self.xebiaPostImage = [UIImage imageNamed:@"xebia-avatar"];

    self.postType = pPostType;
    self.identifier = pIdentifier;

    self.postTypes = [@{
        [NSNumber asString:RECENT]: @"recent",
        [NSNumber asString:AUTHOR]: @"author",
        [NSNumber asString:TAG]: @"tag",
        [NSNumber asString:CATEGORY]: @"category"
    } mutableCopy];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configure];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSString *resourcePath = [[self getCurrentPostType] isEqualToString:@"recent"] ?
        @"/api/wordpress/posts/recent?count=25" :
        [NSString stringWithFormat:@"/api/wordpress/%@/posts?id=%@", [self getCurrentPostType], self.identifier];

    [self.tableController loadTableFromResourcePath:resourcePath];
}

- (void)configure {
    [self configureTableController];
    [self configureRefreshTriggerView];
    [self configureTableView];
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
    

    [self.tableController mapObjectsWithClass:[WPPost class] toTableCellsWithMapping:[self getCellMapping]];
}

- (RKTableViewCellMapping *)getCellMapping {
    RKTableViewCellMapping *cellMapping = [RKTableViewCellMapping cellMapping];
    cellMapping.cellClassName = @"WPPostCell";
    cellMapping.reuseIdentifier = @"WPPost";
    cellMapping.rowHeight = 102.0;
    [cellMapping mapKeyPath:@"titlePlain" toAttribute:@"titleLabel.text"];
    [cellMapping mapKeyPath:@"description_" toAttribute:@"excerptLabel.text"];
    [cellMapping mapKeyPath:@"dateFormatted" toAttribute:@"dateLabel.text"];
    [cellMapping mapKeyPath:@"tagsFormatted" toAttribute:@"tagsLabel.text"];
    [cellMapping mapKeyPath:@"categoriesFormatted" toAttribute:@"categoriesLabel.text"];
    [cellMapping mapKeyPath:@"authorFormatted" toAttribute:@"authorLabel.text"];
    [cellMapping mapKeyPath:@"identifier" toAttribute:@"identifier"];
    
    cellMapping.onSelectCellForObjectAtIndexPath = ^(UITableViewCell *cell, id object, NSIndexPath* indexPath) {
        WPPost *post = [self.tableController objectForRowAtIndexPath:indexPath];
        NSLog(@"Post selected: %@", post);

        WPCategory *postCategory = [post.categories objectAtIndex:0];

        NSString *postUrl = [NSString stringWithFormat:@"/wordpress/post/%@", post.identifier];

//        XBLoadingView *loadingView = [[XBLoadingView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
//        loadingView.center = self.tableView.center;
//        self.tableController.loadingView = loadingView;


        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:postUrl usingBlock:^(RKObjectLoader *loader) {

            loader.onDidLoadObject = ^(id mappedObject) {
                NSError* error = nil;

                RKObjectMapping *serializationMapping = [[[RKObjectManager sharedManager] mappingProvider] serializationMappingForClass:[mappedObject class]];
                RKObjectSerializer* serializer = [RKObjectSerializer serializerWithObject:mappedObject mapping:serializationMapping];
                NSString *json = [serializer serializedObjectForMIMEType:RKMIMETypeJSON error:&error];

                if (error) {
                    RKLogError(@"Serializing failed for source object %@ to MIME Type %@: %@", object, RKMIMETypeJSON, [error localizedDescription]);
                }
                else {
                    XBShareInfo* shareInfo = [XBShareInfo shareInfoWithUrl:post.url title:post.title];
                    [self.appDelegate.mainViewController openLocalURL:@"index"
                                                            withTitle:postCategory.title
                                                                 json:json
                                                            shareInfo: shareInfo];
                }
            };

            loader.onDidFailWithError = ^(NSError *error) {
//                self.tableController.loadingView = nil;
                NSLog(@"Fetch post with id: '%@' failure: %@", post.identifier, error);
            };

        }];

    };
    
    return cellMapping;
}

- (void)configureTableView {
    self.tableView.backgroundColor = [UIColor colorWithPatternImageName:@"bg_home_pattern"];
//    self.tableView.backgroundColor = [UIColor colorWithHex:@"#191919" alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WPPostCell" bundle:nil] forCellReuseIdentifier:@"WPPost"];
}

- (NSString *)getCurrentPostType {
    return [self.postTypes valueForKey:[[NSNumber numberWithInt:self.postType] description]];
}

- (void)configureRefreshTriggerView {
    NSBundle *restKitResources = [NSBundle restKitResourcesBundle];
    UIImage *arrowImage = [restKitResources imageWithContentsOfResource:@"blueArrow" withExtension:@"png"];
    [[RKRefreshTriggerView appearance] setTitleFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13]];
    [[RKRefreshTriggerView appearance] setLastUpdatedFont:[UIFont fontWithName:@"HelveticaNeue" size:11]];
    [[RKRefreshTriggerView appearance] setArrowImage:arrowImage];
}

- (void)tableController:(RKAbstractTableController *)tableController
        willDisplayCell:(WPPostCell *)postCell
              forObject:(WPPost *)post
            atIndexPath:(NSIndexPath *)indexPath;
{
    if (![post.author.slug isEqualToString:@"xebiafrance" ]) {
        [postCell.imageView setImageWithURL: [post imageUrl] placeholderImage:self.defaultPostImage];
    }
    else {
        postCell.imageView.image = self.xebiaPostImage;
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    NSLog(@"Did received a memory warning in controller: %@", [self class]);
}

@end
