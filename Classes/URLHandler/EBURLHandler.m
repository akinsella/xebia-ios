//
// Created by Alexis Kinsella on 21/11/2013.
// Copyright (c) 2013 Xebia. All rights reserved.
//


#import "EBURLHandler.h"
#import "NSString+XBAdditions.h"
#import "EBEvent.h"
#import "XBMapper.h"
#import "EBEventDetailsViewController.h"
#import "XBAppDelegate.h"
#import "XBAbstractURLHandler+protected.h"

@implementation EBURLHandler

- (BOOL)handleURL:(NSURL *)url {
    return [url.host isEqualToString:@"event"];
}

- (void)processURL:(NSURL *)url {
    XBLog(@"Navigate to path: %@", url);

    NSString * identifier = url.pathComponents.lastObject;
    NSString *eventUrl = [[NSString stringWithFormat:@"/eventbrite/events/%@", identifier] stripLeadingSlash];

    [self fetchDataFromSourceWithResourcePath:eventUrl
                                      success:^(id json) {
                                          EBEvent *event = [XBMapper parseObject:json intoObjectsOfType:EBEvent.class];

                                          EBEventDetailsViewController *eventDetailsViewController = [[EBEventDetailsViewController alloc] initWithEvent:event];
                                          [self.appDelegate.mainViewController revealViewController:eventDetailsViewController];
                                      }
                                      failure:^(NSError *error) {
                                          NSLog(@"Fetch event with id: '%@' failure: %@", identifier, error);
                                      }
    ];
}

@end