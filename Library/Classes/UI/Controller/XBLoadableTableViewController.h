//
// Created by Simone Civetta on 02/03/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBTableViewController.h"


@interface XBLoadableTableViewController : XBTableViewController

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