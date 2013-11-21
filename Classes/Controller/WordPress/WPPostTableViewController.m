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
#import "NSNumber+XBAdditions.h"
#import "UIViewController+XBAdditions.h"
#import "XBMapper.h"
#import "XBWordpressArrayDataSource.h"
#import "XBPListConfigurationProvider.h"
#import "GAITracker.h"
#import "WPPostDetailsViewController.h"
#import "NSString+XBAdditions.h"

@interface WPPostTableViewController ()
@property (nonatomic, strong) NSMutableDictionary *postTypes;
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
    self.title = NSLocalizedString(@"Posts", nil);

    self.postType = pPostType;
    self.identifier = pIdentifier;

    self.postTypes = [@{
        [NSNumber asString:RECENT]: @"recent",
        [NSNumber asString:AUTHOR]: @"authors",
        [NSNumber asString:TAG]: @"tags",
        [NSNumber asString:CATEGORY]: @"categories"
    } mutableCopy];
}

- (void)viewDidLoad {

    [self.appDelegate.tracker sendView:[NSString stringWithFormat:@"/wordpress/%@", [self.currentPostType isEqualToString:@"recent"] ? @"posts/recent" : self.currentPostType]];

    self.delegate = self;
    self.title = @"Posts";
    self.tableView.rowHeight = 64;

    [super viewDidLoad];

    [self customizeNavigationBarAppearance];
    [self addMenuButton];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (XBWordpressArrayDataSource *)buildDataSource {
    XBHttpClient *httpClient = [[XBPListConfigurationProvider provider] httpClient];

    XBWordpressArrayDataSource *dataSource = [XBWordpressArrayDataSource dataSourceWithResourcePath:[self resourcePath]
                                                                                        rootKeyPath:@"posts"
                                                                                          classType:[WPSPost class]
                                                                                         httpClient:httpClient];
    return dataSource;
}

- (NSString *)currentPostType {
    return [self.postTypes valueForKey:[[NSNumber numberWithInt:self.postType] description]];
}

- (NSString *)tableView:(UITableView *)tableView cellReuseIdentifierAtIndexPath:(NSIndexPath *)indexPath {
    // Needs to be static
    static NSString *cellReuseIdentifier = @"WPSPost";

    return cellReuseIdentifier;
}

- (NSString *)resourcePath {

    NSString *resourcePath = [self.currentPostType isEqualToString:@"recent"] ?
            @"/wordpress/posts/recent" :
            [NSString stringWithFormat:@"/wordpress/%@/%@", self.currentPostType, self.identifier];

    return resourcePath;
}

- (NSString *)tableView:(UITableView *)tableView cellNibNameAtIndexPath:(NSIndexPath *)indexPath {
    return @"WPSPostCell";
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {

    WPSPostCell *postCell = (WPSPostCell *) cell;

    WPPost *post = self.dataSource[(NSUInteger) indexPath.row];

    [postCell updateWithPost: post];
}

-(void)onSelectCell: (UITableViewCell *)cell forObject: (id) object withIndex: (NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    WPSPost *post = self.dataSource[(NSUInteger) indexPath.row];
    NSLog(@"Post selected: %@", post);

    NSString *postUrl = [[NSString stringWithFormat:@"/wordpress/posts/%@", post.identifier] stripLeadingSlash];

    [self fetchDataFromSourceWithResourcePath:postUrl success:^(id fetchedJson) {
        WPPost *fetchedPost = [XBMapper parseObject:fetchedJson[@"post"] intoObjectsOfType:[WPPost class]];

        WPPostDetailsViewController *postDetailsViewController = [[WPPostDetailsViewController alloc] initWithPost:fetchedPost];
        [self.navigationController pushViewController:postDetailsViewController animated:true];
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
            [self dismissProgressHUDWithCallback:^{
                if (success) {
                    success(JSON);
                }
            }];
         }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [self showErrorProgressHUDWithCallback:^{
                if (failure) {
                    failure(error);
                }
            }];
        }
    ];
}

@end
