//
// Created by Alexis Kinsella on 07/11/2013.
// Copyright (c) 2013 Xebia. All rights reserved.
//


#import "XBNavigationController.h"
#import "MBProgressHUD.h"

@interface XBNavigationController()

@property (nonatomic, strong) MBProgressHUD *progressHUD;

@end

@implementation XBNavigationController

- (NSUInteger)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotate
{
    return [self.topViewController shouldAutorotate];
}

- (void)initProgressHUD {
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
}

- (void)showProgressHUD {
    [self showProgressHUDWithMessage:NSLocalizedString(@"Chargement...", @"Chargement...")
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
    [self showErrorProgressHUDWithMessage:NSLocalizedString(@"Erreur pendant le chargement", @"Erreur pendant le chargement")
                               afterDelay:1.0];
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