//
// Created by Alexis Kinsella on 07/11/2013.
// Copyright (c) 2013 Xebia. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface XBNavigationController : UINavigationController

- (void)initProgressHUD;

- (void)showProgressHUD;

- (void)showProgressHUDWithMessage:(NSString *)message graceTime:(float)graceTime;

- (void)showErrorProgressHUD;

- (void)showErrorProgressHUDWithMessage:(NSString *)errorMessage afterDelay:(float)delay;

- (void)dismissProgressHUD;

@end