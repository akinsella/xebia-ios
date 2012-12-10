//
//  XBMainViewController.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 19/08/12.
//
//

#import <UIKit/UIKit.h>
#import <RestKit/UI.h>
#import "XBRevealController.h"
#import "XBViewControllerManager.h"
#import "XBShareInfo.h"

@interface XBMainViewController : UITableViewController

-(void)revealViewControllerWithIdentifier:(NSString *)identifier;

@property (nonatomic, strong, readonly) XBRevealController *revealController;

- (id)initWithViewControllerManager:(XBViewControllerManager *)viewControllerManager;

- (void)revealViewController:(UIViewController *)controller;

-(void)openURL:(NSURL *)url withTitle:(NSString *)title;

-(void)openLocalURL:(NSString *)htmlFileRef withTitle:(NSString *)title object:(id)object shareInfo:(XBShareInfo *)shareInfo;

-(void)openLocalURL:(NSString *)htmlFileRef withTitle:(NSString *)title json:(NSString *)object shareInfo: (XBShareInfo *)shareInfo;

@end
