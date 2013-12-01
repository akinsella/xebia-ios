//
// Created by Alexis Kinsella on 21/11/2013.
// Copyright (c) 2013 Xebia. All rights reserved.
//


#import "VMURLHandler.h"
#import "NSString+XBAdditions.h"
#import "XBMapper.h"
#import "VMVideo.h"
#import "VMVideoDetailsViewController.h"
#import "XBAppDelegate.h"
#import "XBAbstractURLHandler+protected.h"


@implementation VMURLHandler

- (BOOL)handleURL:(NSURL *)url {
    return [url.host isEqualToString:@"videos"];
}

- (void)processURL:(NSURL *)url {
    XBLog(@"Navigate to path: %@", url);

    NSString * identifier = url.pathComponents.lastObject;
    NSString *videoUrl = [[NSString stringWithFormat:@"/videos/%@", identifier] stripLeadingSlash];

    [self fetchDataFromSourceWithResourcePath:videoUrl
                                      success:^(id json) {
                                          VMVideo *video = [XBMapper parseObject:json intoObjectsOfType:VMVideo.class];

                                          VMVideoDetailsViewController *videoDetailsViewController = (VMVideoDetailsViewController *) [self.appDelegate.viewControllerManager getOrCreateControllerWithIdentifier:@"videoDetails"];
                                          [videoDetailsViewController updateWithVideo:video];
                                          [self.appDelegate.mainViewController revealViewController:videoDetailsViewController];
                                      }
                                      failure:^(NSError *error) {
                                          NSLog(@"Fetched video with id: '%@' failure: %@", identifier, error);
                                      }
    ];
}

@end