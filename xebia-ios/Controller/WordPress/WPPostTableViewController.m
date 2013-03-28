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
#import "XBMainViewController.h"
#import "WPCategory.h"
#import "XBMapper.h"
#import "JSONKit.h"
#import "AFHTTPClient.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "XBHttpArrayDataSourceConfiguration.h"
#import "NSDateFormatter+XBAdditions.h"
#import "XBConfigurationProvider.h"
#import "XBWordpressArrayDataSource.h"

@interface WPPostTableViewController ()
@property (nonatomic, strong) NSMutableDictionary *postTypes;
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

-(void)initialize {
    _dataSource = [XBWordpressArrayDataSource dataSourceWithConfiguration:[self.delegate configuration]
                                                               httpClient:self.appDelegate.configurationProvider.httpClient];
}

- (void)viewDidLoad {

    self.delegate = self;
    self.title = @"Posts";
    self.tableView.rowHeight = 102;

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

- (NSString *)storageFileName {
    if (_identifier) {
        return [NSString stringWithFormat: @"wp-posts-%@-%@.json", [self currentPostType], self.identifier];
    }
    else {
        return [NSString stringWithFormat: @"wp-posts-%@.json", [self currentPostType]];
    }
}

- (NSString *)resourcePath {

    NSString *resourcePath = [[self currentPostType] isEqualToString:@"recent"] ?
            @"/api/wordpress/posts/recent?count=25" :
            [NSString stringWithFormat:@"/api/wordpress/%@/%@/posts", [self currentPostType], self.identifier];

    return resourcePath;
}

- (XBHttpArrayDataSourceConfiguration *)configuration {

    XBHttpArrayDataSourceConfiguration* configuration = [XBHttpArrayDataSourceConfiguration configuration];
    configuration.resourcePath = [self resourcePath];
    configuration.storageFileName = [self storageFileName];
    configuration.maxDataAgeInSecondsBeforeServerFetch = 600;
    configuration.typeClass = [WPSPost class];
    configuration.dateFormat = [NSDateFormatter initWithDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZ"];

    return configuration;
}

- (NSString *)cellNibName {
    return @"WPSPostCell";
}

//- (NSDictionary *)fetchDataFromDB {
////    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
////
////    if ([[self currentPostType] isEqualToString:@"recent"]) {
////        return [[self dataClass] MR_findAllSortedBy:@"date" ascending:NO inContext:localContext];
////    }
////    else if ([[self currentPostType] isEqualToString:@"author"]) {
////        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"author.identifier == %@", self.identifier];
////        return [[self dataClass] MR_findAllSortedBy:@"date" ascending:NO withPredicate:predicate inContext:localContext];
////    }
////    else if ([[self currentPostType] isEqualToString:@"tag"]) {
////        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY tags.identifier == %@", self.identifier];
////        return [[self dataClass] MR_findAllSortedBy:@"date" ascending:NO withPredicate:predicate inContext:localContext];
////    }
////    else if ([[self currentPostType] isEqualToString:@"category"]) {
////        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY categories.identifier == %@", self.identifier];
////        return [[self dataClass] MR_findAllSortedBy:@"date" ascending:NO withPredicate:predicate inContext:localContext];
////    }
//
//    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"wp-posts.json"];
//    NSLog(@"WPPosts Json path: %@", filePath);
//
//    NSString *fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//    NSDictionary *json = [fileContent objectFromJSONString];
//
//    return json;
//}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {

    WPSPostCell *postCell = (WPSPostCell *) cell;

    WPPost *post = self.dataSource[indexPath.row];
    postCell.titleLabel.text = post.title;
    postCell.commentLabel.text = post.description_;
    postCell.dateLabel.text = post.dateFormatted;
    postCell.tagsLabel.text = post.tagsFormatted;
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

    WPSPost *post = self.dataSource[indexPath.row];
    NSLog(@"Post selected: %@", post);

    NSString *postUrl = [NSString stringWithFormat:@"/api/wordpress/post/%@", post.identifier];

    [self fetchDataFromServerWithResourcePath:postUrl
        success:^(id fetchedJson) {
            WPPost *fetchedPost = [XBMapper parseObject:fetchedJson intoObjectsOfType:[WPPost class]];
            NSString * json = [XBMapper objectToSerializedJson:fetchedPost withDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZ"];

            XBShareInfo* shareInfo = [XBShareInfo shareInfoWithUrl:post.url title:post.title];

            WPCategory *postCategory = (WPCategory *)[post.categories objectAtIndex:0];
            [self.appDelegate.mainViewController openLocalURL:@"index"
                                                    withTitle:postCategory.title
                                                         json:json
                                                    shareInfo: shareInfo];
        }
        failure:^(NSError *error) {
            NSLog(@"Fetch post with id: '%@' failure: %@", post.identifier, error);
        }
    ];
}


- (void)fetchDataFromServerWithResourcePath:(NSString *)path success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure {
    [SVProgressHUD showWithStatus:@"Fetching data" maskType:SVProgressHUDMaskTypeBlack];

    [self.configurationProvider.httpClient executeGetJsonRequestWithPath:path
                                                              parameters:nil
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [SVProgressHUD showSuccessWithStatus:@"Done!"];

            if (success) {
                success(JSON);
            }
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [SVProgressHUD showErrorWithStatus:@"Got some issue!"];

            if (failure) {
                failure(error);
            }
        }
    ];
}


@end
