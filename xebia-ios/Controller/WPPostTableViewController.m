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
#import "WPPostCell.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "NSNumber+XBAdditions.h"
#import "UIViewController+XBAdditions.h"
#import "XBMainViewController.h"
#import "WPCategory.h"
#import "NSManagedObject+XBAdditions.h"
#import "JSONKit.h"

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


- (void)viewDidLoad {

    self.delegate = self;
    self.title = @"Posts";
    self.tableView.rowHeight = 102;

    [super viewDidLoad];
}

- (NSString *)getCurrentPostType {
    return [self.postTypes valueForKey:[[NSNumber numberWithInt:self.postType] description]];
}

- (int)maxDataAgeInSecondsBeforeServerFetch {
    return 120;
}

- (Class)dataClass {
    return [WPPost class];
}

- (NSString *)cellReuseIdentifier {
    // Needs to be static
    static NSString *cellReuseIdentifier = @"WPPost";

    return cellReuseIdentifier;
}

- (NSString *)cellNibName {
    return @"WPPostCell";
}

- (NSString *)resourcePath {

    NSString *resourcePath = [[self getCurrentPostType] isEqualToString:@"recent"] ?
            @"/api/wordpress/posts/recent?count=25" :
            [NSString stringWithFormat:@"/api/wordpress/%@/posts?id=%@", [self getCurrentPostType], self.identifier];


    return resourcePath;
}

- (NSArray *)fetchDataFromDB {
    return [[self dataClass] MR_findAllSortedBy:@"date" ascending:FALSE];
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {

    WPPostCell *postCell = (WPPostCell *) cell;

    WPPost *post = [self objectAtIndex:(NSUInteger) indexPath.row];
    postCell.titleLabel.text = post.title;
    postCell.excerptLabel.text = post.description_;
    postCell.dateLabel.text = post.dateFormatted;
    postCell.tagsLabel.text = post.tagsFormatted;
    postCell.categoriesLabel.text = post.categoriesFormatted;
    postCell.authorLabel.text = post.authorFormatted;
    postCell.identifier = post.identifier;


    if (![post.author.slug isEqualToString:@"xebiafrance" ]) {
        [postCell.imageView setImageWithURL: [post imageUrl] placeholderImage:self.defaultPostImage];
    }
    else {
        postCell.imageView.image = self.xebiaPostImage;
    }
}

-(void)onSelectCell: (UITableViewCell *)cell forObject: (id) object withIndex: (NSIndexPath *)indexPath {

    WPPost *post = [self objectAtIndex:(NSUInteger) indexPath.row];
    NSLog(@"Post selected: %@", post);

    WPCategory *postCategory = [post.categories objectAtIndex:0];

    NSString *postUrl = [NSString stringWithFormat:@"/wordpress/post/%@", post.identifier];

    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:postUrl usingBlock:^(RKObjectLoader *loader) {

        loader.onDidLoadObject = ^(id mappedObject) {
            NSDictionary *dict = [NSManagedObject dictionaryWithPropertiesOfObject: post];

            NSString *json = [dict JSONString];

            XBShareInfo* shareInfo = [XBShareInfo shareInfoWithUrl:post.url title:post.title];
            [self.appDelegate.mainViewController openLocalURL:@"index"
                                                    withTitle:postCategory.title
                                                         json:json
                                                    shareInfo: shareInfo];
        };

        loader.onDidFailWithError = ^(NSError *error) {
//                self.tableController.loadingView = nil;
            NSLog(@"Fetch post with id: '%@' failure: %@", post.identifier, error);
        };

    }];

}

@end
