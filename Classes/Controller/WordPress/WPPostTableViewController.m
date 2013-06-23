//
//  WPPostTableViewController.m
//  Xebia Application
//
//  Created by Alexis Kinsella on 14/06/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//


#import "WPPost.h"
#import "WPSPost.h"
#import "WPPostTableViewController.h"
#import "WPSPostCell.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "NSNumber+XBAdditions.h"
#import "UIViewController+XBAdditions.h"
#import "WPCategory.h"
#import "XBMapper.h"
#import "XBReloadableTableViewController.h"
#import "XBWordpressArrayDataSource.h"
#import "XBPListConfigurationProvider.h"
#import "XBLogging.h"
#import "GAITracker.h"

@interface WPPostTableViewController ()
@property (nonatomic, strong) NSMutableDictionary *postTypes;
@property (nonatomic, strong) UIImage *defaultPostImage;
@property (nonatomic, strong) UIImage *xebiaPostImage;
@property(nonatomic, assign) POST_TYPE postType;
@property(nonatomic, copy) NSNumber *identifier;
@end

@implementation WPPostTableViewController

-(id)initWithPostType:(POST_TYPE)pPostType identifier:(NSNumber *)pIdentifier {
    self = [super initWithStyle:UITableViewStylePlain];

    if (self) {
        [self initInternalWithPostType:pPostType identifier:pIdentifier];
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)coder withPostType:(POST_TYPE)pPostType identifier:(NSNumber *)pIdentifier {
    self = [super initWithCoder:coder];
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

- (XBWordpressArrayDataSource *)buildDataSource {
    XBHttpClient *httpClient = [[XBPListConfigurationProvider provider] httpClient];

    XBWordpressArrayDataSource *dataSource = [XBWordpressArrayDataSource dataSourceWithResourcePath:[self resourcePath]
                                                                                        rootKeyPath:@"posts"
                                                                                          classType:[WPSPost class]
                                                                                         httpClient:httpClient];
    return dataSource;
}

- (void)viewDidLoad {

    [self.appDelegate.tracker sendView:[NSString stringWithFormat:@"/wordpress/posts/%@", self.currentPostType]];

    self.delegate = self;
    self.title = @"Posts";
    self.tableView.rowHeight = 64;

    [super viewDidLoad];
}

- (NSString *)currentPostType {
    return [self.postTypes valueForKey:[[NSNumber numberWithInt:self.postType] description]];
}

- (NSString *)cellReuseIdentifier {
    // Needs to be static
    static NSString *cellReuseIdentifier = @"WPSPost";

    return cellReuseIdentifier;
}

- (NSString *)resourcePath {

    NSString *resourcePath = [[self currentPostType] isEqualToString:@"recent"] ?
            @"/api/wordpress/post/recent" :
            [NSString stringWithFormat:@"/api/wordpress/post/%@/%@", [self currentPostType], self.identifier];

    return resourcePath;
}

- (NSString *)cellNibName {
    return @"WPSPostCell";
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {

    WPSPostCell *postCell = (WPSPostCell *) cell;

    WPPost *post = self.dataSource[(NSUInteger) indexPath.row];
    
    postCell.titleLabel.text = post.title;
    postCell.dateLabel.text = post.dateFormatted;
    postCell.categoriesLabel.text = post.categoriesFormatted;
    postCell.authorLabel.text = post.authorFormatted;
    postCell.identifier = post.identifier;

    if (![post.author.slug isEqualToString:@"xebiafrance"]) {
        [postCell.imageView setImageWithURL: [post imageUrl] placeholderImage:self.defaultPostImage];
    }
    else {
        postCell.imageView.image = self.xebiaPostImage;
    }
}

-(void)onSelectCell: (UITableViewCell *)cell forObject: (id) object withIndex: (NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    WPSPost *post = self.dataSource[(NSUInteger) indexPath.row];
    NSLog(@"Post selected: %@", post);

    NSString *postUrl = [NSString stringWithFormat:@"/api/wordpress/post/%@", post.identifier];

    [self fetchDataFromSourceWithResourcePath:postUrl success:^(id fetchedJson) {
        WPPost *fetchedPost = [XBMapper parseObject:fetchedJson intoObjectsOfType:[WPPost class]];
        NSString *json = [XBMapper objectToSerializedJson:fetchedPost withDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZ"];

        NSLog(@"Json post: %@", json);

        XBShareInfo *shareInfo = [XBShareInfo shareInfoWithUrl:post.url title:post.title];

          WPCategory *postCategory = (WPCategory *) [post.categories objectAtIndex:0];
          [self.appDelegate.mainViewController openLocalURL:@"index"
                                                  withTitle:postCategory.title
                                                       json:json
                                                  shareInfo:shareInfo];
      }
      failure:^(NSError *error) {
          NSLog(@"Fetch post with id: '%@' failure: %@", post.identifier, error);
      }
    ];
}

- (void)fetchDataFromSourceWithResourcePath:(NSString *)path success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure {
    [self showProgressHUD];

    [self.appDelegate.configurationProvider.httpClient executeGetJsonRequestWithPath:path
                                                              parameters:nil
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [self dismissProgressHUD];

            if (success) {
                success(JSON);
            }
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [self showErrorProgressHUD];

            if (failure) {
                failure(error);
            }
        }
    ];
}

@end
