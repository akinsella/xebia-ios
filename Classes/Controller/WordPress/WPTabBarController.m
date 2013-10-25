//
//  WPTabBarController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "WPTabBarController.h"
#import "UIViewController+XBAdditions.h"
#import "UIColor+XBAdditions.h"

@implementation WPTabBarController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Blog", nil);

    [self customizeNavigationBarAppearance];
    [self addMenuButton];

    [self.tabBar setSelectedImageTintColor:[UIColor colorWithHex:@"#888888"]];
//
//    for (UITabBarItem *tabBarItem in self.tabBar.items) {
//        [tabBarItem setFinishedSelectedImage: tabBarItem.image
//                 withFinishedUnselectedImage: tabBarItem.image];
//    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

@end