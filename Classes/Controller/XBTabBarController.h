//
// Created by Alexis Kinsella on 07/11/2013.
// Copyright (c) 2013 Xebia. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface XBTabBarController : UITabBarController

- (void)initProgressHUD;

- (void)showProgressHUD;

- (void)showProgressHUDWithMessage:(NSString *)message
                         graceTime:(float)graceTime;

- (void)showProgressHUDWithTitle:(NSString *)title
                         message:(NSString *)message
                           delay:(float)delay
                         yOffset:(CGFloat)yOffset
                           color:(UIColor *)color
                        callback:(void(^)())callback;

- (void)showErrorProgressHUDWithCallback:(void(^)())callback;

- (void)showErrorProgressHUDWithMessage:(NSString *)errorMessage
                             afterDelay:(float)delay
                               callback:(void(^)())callback;

- (void)dismissProgressHUDWithCallback:(void(^)())callback;

@end