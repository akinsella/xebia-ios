//
// Created by Alexis Kinsella on 07/12/2013.
// Copyright (c) 2013 Xebia. All rights reserved.
//

#import "XBAppUpgradeViewController.h"


@implementation XBAppUpgradeViewController

- (NSString *)trackPath {
    return [NSString stringWithFormat:@"/api/retired"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(IBAction)onClose {
    [self dismissViewControllerAnimated:YES completion:^{ }];
}

@end