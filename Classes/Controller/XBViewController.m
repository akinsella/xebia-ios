//
// Created by Alexis Kinsella on 07/11/2013.
// Copyright (c) 2013 Xebia. All rights reserved.
//


#import "XBViewController.h"
#import "UIViewController+XBAdditions.h"
#import "MBProgressHUD.h"

@interface XBViewController()

@property (nonatomic, strong) MBProgressHUD *progressHUD;

@end

@implementation XBViewController

- (NSString *)trackPath {
    return @"<NO_TRACK_PATH>";
}

- (void)viewWillAppear:(BOOL)animated {

    [self.appDelegate trackView:self.trackPath];

    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initProgressHUD];
}

- (void)initProgressHUD {
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
}

- (void)showProgressHUD {
    [self showProgressHUDWithMessage:NSLocalizedString(@"Loading...", nil)
                           graceTime:0.5];
    [self.navigationController.view addSubview:self.progressHUD];
}

- (void)showProgressHUDWithMessage:(NSString *)message graceTime:(float)graceTime {
    self.progressHUD.mode = MBProgressHUDModeIndeterminate;
    self.progressHUD.labelText = NSLocalizedString(message, message);
    self.progressHUD.graceTime = graceTime;
    self.progressHUD.taskInProgress = YES;
    [self.navigationController.view addSubview:self.progressHUD];
    [self.progressHUD show:YES];
}

- (void)showErrorProgressHUD {
    [self showErrorProgressHUDWithMessage:NSLocalizedString(@"Error during loading", nil) afterDelay:1.0];
}

- (void)showErrorProgressHUDWithMessage:(NSString *)errorMessage afterDelay:(float)delay {
    self.progressHUD.mode = MBProgressHUDModeText;
    self.progressHUD.labelText = errorMessage;
    [self.progressHUD hide:YES afterDelay:delay];
    self.progressHUD.taskInProgress = NO;
    [self.navigationController.view addSubview:self.progressHUD];
}

- (void)dismissProgressHUD {
    self.progressHUD.taskInProgress = NO;
    [self.progressHUD hide:YES];
}

@end