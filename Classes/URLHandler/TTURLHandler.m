//
// Created by Alexis Kinsella on 11/11/2013.
// Copyright (c) 2013 Xebia. All rights reserved.
//


#import "TTURLHandler.h"
#import "XBAppDelegate.h"


@implementation TTURLHandler

- (BOOL)handleURL:(NSURL *)url {
    return [url.host isEqualToString:@"tweets"];
}

- (void)processURL:(NSURL *)url {
    XBLog(@"Navigate to path: %@", url);

    NSString *identifier = url.pathComponents.lastObject;
    NSString *author = @"XebiaFr"; // FixMe

    NSURL *tweetStatusUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/%@/status/%@", author, identifier]];

    [self.appDelegate.mainViewController openURL:tweetStatusUrl withTitle:@"Twitter"];
}

@end