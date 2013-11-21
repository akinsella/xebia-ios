//
// Created by akinsella on 05/04/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "XBTableViewController.h"
#import "MBProgressHUD.h"


@interface XBReloadableTableViewController : XBTableViewController

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