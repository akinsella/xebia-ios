//
//  WPRecentPostTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 01/10/12.
//
//

#import "WPRecentPostTableViewController.h"

@interface WPRecentPostTableViewController ()
- (void)initInternalWithPostType:(POST_TYPE)postType identifier:(NSNumber *)identifier;
@end

@implementation WPRecentPostTableViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initInternalWithPostType:RECENT identifier:nil];
    }

    return self;
}


@end
