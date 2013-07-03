//
//  WPCategoryTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "XBHomeController.h"
#import "UIViewController+XBAdditions.h"
#import "GAITracker.h"

@implementation XBHomeController

- (void)viewDidLoad {

    [self.appDelegate.tracker sendView:@"/home"];

    self.title = NSLocalizedString(@"Home", nil);
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_home_pattern-light"]];

    [self addMenuButton];

    [super viewDidLoad];
}

@end