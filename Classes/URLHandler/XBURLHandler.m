//
// Created by Alexis Kinsella on 11/11/2013.
// Copyright (c) 2013 Xebia. All rights reserved.
//


#import "XBURLHandler.h"
#import "XBToolkit.h"
#import "XBAppDelegate.h"


@implementation XBURLHandler


- (XBAppDelegate *) appDelegate {
    return (XBAppDelegate *) UIApplication.sharedApplication.delegate;
}

- (BOOL)handleURL:(NSURL *)url {
    mustOverride();
}

- (void)processURL:(NSURL *)url {
    mustOverride();
}

@end