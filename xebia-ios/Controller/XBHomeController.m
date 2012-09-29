//
//  WPCategoryTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "XBHomeController.h"
#import "UIViewController+XBAdditions.h"

@implementation XBHomeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Home";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_home_pattern"]];
    
    [self addRevealGesture];
    [self addMenuButton];
}

@end