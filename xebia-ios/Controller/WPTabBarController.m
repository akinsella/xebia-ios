//
//  WPCategoryTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WPTabBarController.h"
#import "UIViewController+XBAdditions.h"

@implementation WPTabBarController

- (void)viewDidLoad
{

    [super viewDidLoad];
    
    self.title = @"Blog";
    
    [self addRevealGesture];
    [self addMenuButton];
}

@end