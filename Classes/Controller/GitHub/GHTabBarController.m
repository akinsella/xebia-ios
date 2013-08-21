//
//  GHTabBarController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "GHTabBarController.h"
#import "UIViewController+XBAdditions.h"

@implementation GHTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Github";

    [self addMenuButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

@end