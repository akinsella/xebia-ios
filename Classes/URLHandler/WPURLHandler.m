//
// Created by Alexis Kinsella on 11/11/2013.
// Copyright (c) 2013 Xebia. All rights reserved.
//


#import "WPURLHandler.h"
#import "NSString+XBAdditions.h"
#import "XBMapper.h"
#import "WPPost.h"
#import "WPPostDetailsViewController.h"
#import "XBAppDelegate.h"
#import "XBNavigationController.h"

@implementation WPURLHandler

- (BOOL)handleURL:(NSURL *)url {
    return [url.host isEqualToString:@"blog"];
}

- (void)processURL:(NSURL *)url {
    XBLog(@"Navigate to path: %@", url);

    NSString * identifier = url.pathComponents.lastObject;
    NSString *postUrl = [[NSString stringWithFormat:@"/wordpress/posts/%@", identifier] stripLeadingSlash];

    [self fetchDataFromSourceWithResourcePath:postUrl
                                      success:^(id fetchedJson) {
                                          WPPost *fetchedPost = [XBMapper parseObject:fetchedJson[@"post"] intoObjectsOfType:WPPost.class];

                                          WPPostDetailsViewController *postDetailsViewController = [[WPPostDetailsViewController alloc] initWithPost:fetchedPost];
                                          [self.appDelegate.mainViewController revealViewController:postDetailsViewController];
                                      }
                                      failure:^(NSError *error) {
                                          NSLog(@"Fetch post with id: '%@' failure: %@", identifier, error);
                                      }
    ];
}

- (void)fetchDataFromSourceWithResourcePath:(NSString *)path success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure {

    XBNavigationController *navigationController = (XBNavigationController *)self.appDelegate.mainViewController.frontViewController.navigationController;
    [navigationController showProgressHUD];

    [self.appDelegate.configurationProvider.httpClient executeGetJsonRequestWithPath:path parameters:nil
                                                                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                 [navigationController dismissProgressHUD];

                                                                                 if (success) {
                                                                                     success(JSON);
                                                                                 }
                                                                             }
                                                                             failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                 [navigationController showErrorProgressHUD];

                                                                                 if (failure) {
                                                                                     failure(error);
                                                                                 }
                                                                             }
    ];
}


@end