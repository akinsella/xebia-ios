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
#import "XBConstants.h"

@implementation WPTabBarController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Blog", nil);

    [self customizeNavigationBarAppearance];
    [self addMenuButton];

    [self.tabBar setSelectedImageTintColor:[UIColor colorWithHex:@"#888888"]];

    NSArray *tabBarImageNames = @[@"34-coffee", @"44-shoebox", @"15-tags"];
    NSArray *tabBarItemName = @[
        NSLocalizedString(@"Posts", nil),
        NSLocalizedString(@"Categories", nil),
        NSLocalizedString(@"Tags", nil)
    ];

    if (!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        NSUInteger index = 0;
        for (UITabBarItem *tabBarItem in self.tabBar.items) {
            NSString *selectedImage = [NSString stringWithFormat:@"%@-selected", tabBarImageNames[index]];
//            NSString *unselectedImage = [[NSString stringWithFormat:@"%@-unselected", tabBarImageNames[index]] suffixIfIOS6];
//            NSString *selectedImage = tabBarImageNames[index];
            NSString *unselectedImage = tabBarImageNames[index];

            [tabBarItem setFinishedSelectedImage:[UIImage imageNamed:selectedImage]
                     withFinishedUnselectedImage:[UIImage imageNamed:unselectedImage]];
            index++;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

@end