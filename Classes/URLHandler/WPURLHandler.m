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
#import "XBAbstractURLHandler+protected.h"

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

@end