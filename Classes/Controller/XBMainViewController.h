//
//  XBMainViewController.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 19/08/12.
//
//

#import <UIKit/UIKit.h>
#import <MMDrawerController/MMDrawerController.h>
#import "XBViewControllerManager.h"
#import "XBShareInfo.h"

@class XBArrayDataSource;

@interface XBMainViewController : MMDrawerController

+ (id)controllerWithCentralViewControllerIdentifier:(NSString *)centralViewControllerIdentifier
                       leftViewControllerIdentifier:(NSString *)leftViewControllerIdentifier
                              viewControllerManager:(XBViewControllerManager *)viewControllerManager;

- (id)initWithCentralViewControllerIdentifier:(NSString *)centralViewControllerIdentifier
                 leftViewControllerIdentifier:(NSString *)leftViewControllerIdentifier
                        viewControllerManager:(XBViewControllerManager *)viewControllerManager;

- (void)revealViewController:(UIViewController *)controller;


- (void)revealViewControllerWithIdentifier:(NSString *)identifier;

- (void)openURL:(NSURL *)url withTitle:(NSString *)title;

- (void)openLocalURL:(NSString *)htmlFileRef withTitle:(NSString *)title object:(id)object shareInfo:(XBShareInfo *)shareInfo;

- (void)openLocalURL:(NSString *)htmlFileRef withTitle:(NSString *)title json:(NSString *)object shareInfo: (XBShareInfo *)shareInfo;

- (void)revealViewControllerWithURL:(NSURL *)url;

@end
