//
// Created by Alexis Kinsella on 11/11/2013.
// Copyright (c) 2013 Xebia. All rights reserved.
//


#import <Foundation/Foundation.h>

@class XBAppDelegate;


@interface XBAbstractURLHandler : NSObject

- (XBAppDelegate *)appDelegate;

-(BOOL)handleURL:(NSURL *)url;

-(void)processURL:(NSURL *)url;

@end