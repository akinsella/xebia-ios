//
//  XBMainViewController.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 19/08/12.
//
//

#import <UIKit/UIKit.h>
#import "PKRevealController.h"
#import "XBViewControllerManager.h"
#import "XBShareInfo.h"

@class XBArrayDataSource;

@interface XBMainViewController : PKRevealController

+ (id)controllerWithCentralViewControllerIdentifier:(NSString *)centralViewControllerIdentifier
                       leftViewControllerIdentifier:(NSString *)leftViewControllerIdentifier
                              viewControllerManager:(XBViewControllerManager *)viewControllerManager
                            revealControllerOptions:(NSDictionary *)revealControllerOptions;

- (id)initWithCentralViewControllerIdentifier:(NSString *)centralViewControllerIdentifier
                 leftViewControllerIdentifier:(NSString *)leftViewControllerIdentifier
                        viewControllerManager:(XBViewControllerManager *)viewControllerManager
                      revealControllerOptions:(NSDictionary *)revealControllerOptions;

- (void)revealViewController:(UIViewController *)controller;

-(void)openURL:(NSURL *)url withTitle:(NSString *)title;

-(void)openLocalURL:(NSString *)htmlFileRef withTitle:(NSString *)title object:(id)object shareInfo:(XBShareInfo *)shareInfo;

-(void)openLocalURL:(NSString *)htmlFileRef withTitle:(NSString *)title json:(NSString *)object shareInfo: (XBShareInfo *)shareInfo;

@end
