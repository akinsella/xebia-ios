//
// Created by Alexis Kinsella on 07/11/2013.
// Copyright (c) 2013 Xebia. All rights reserved.
//


#import "XBViewController.h"
#import "UIViewController+XBAdditions.h"
#import "MBProgressHUD.h"
#import "UIColor+XBAdditions.h"

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

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return NO;
}

- (void)initProgressHUD {
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
}

- (void)showProgressHUD {
    if (!self.progressHUD) {
        [self initProgressHUD];
    }
    [self showProgressHUDWithMessage:NSLocalizedString(@"Loading...", nil)
                           graceTime:0.5];
    [self.view addSubview:self.progressHUD];
}

- (void)showProgressHUDWithMessage:(NSString *)message graceTime:(float)graceTime {
    if (!self.progressHUD) {
        [self initProgressHUD];
    }
    self.progressHUD.mode = MBProgressHUDModeIndeterminate;
    self.progressHUD.labelText = NSLocalizedString(message, nil);
    self.progressHUD.graceTime = graceTime;
    self.progressHUD.taskInProgress = YES;
    self.progressHUD.yOffset = 0;
    self.progressHUD.margin = 20;
    self.progressHUD.color = nil;
    self.progressHUD.labelFont = [UIFont systemFontOfSize:16];
    self.progressHUD.detailsLabelFont = [UIFont systemFontOfSize:12];
    self.progressHUD.completionBlock = nil;
    [self.view addSubview:self.progressHUD];
    [self.progressHUD show:YES];
}

- (void)showProgressHUDWithTitle:(NSString *)title
                         message:(NSString *)message
                           delay:(float)delay
                         yOffset:(CGFloat)yOffset
                           color:(UIColor *) color
                        callback:(void(^)())callback {
    if (!self.progressHUD) {
        [self initProgressHUD];
    }
    self.progressHUD.mode = MBProgressHUDModeText;
    self.progressHUD.labelText = NSLocalizedString(title, nil);
    self.progressHUD.detailsLabelText = NSLocalizedString(message, nil);
    self.progressHUD.yOffset = yOffset;
    self.progressHUD.taskInProgress = YES;
    self.progressHUD.color = color;
    self.progressHUD.margin = 12;
    self.progressHUD.labelFont = [UIFont boldSystemFontOfSize:13];
    self.progressHUD.detailsLabelFont = [UIFont systemFontOfSize:11];
    self.progressHUD.completionBlock = callback;
    [self.view addSubview:self.progressHUD];


    [self.progressHUD show:YES];
    [self.progressHUD hide:YES afterDelay:delay];
}

- (void)showErrorProgressHUDWithCallback:(void(^)())callback {
    if (!self.progressHUD) {
        [self initProgressHUD];
    }
    [self showErrorProgressHUDWithMessage:NSLocalizedString(@"Error during loading", nil)
                               afterDelay:1.0
                                 callback:callback];
}

- (void)showErrorProgressHUDWithMessage:(NSString *)errorMessage afterDelay:(float)delay callback:(void(^)())callback {
    if (!self.progressHUD) {
        [self initProgressHUD];
    }
    self.progressHUD.mode = MBProgressHUDModeText;
    self.progressHUD.labelText = errorMessage;
    [self.progressHUD hide:YES afterDelay:delay];
    self.progressHUD.taskInProgress = NO;
    self.progressHUD.yOffset = 0;
    self.progressHUD.margin = 20;
    self.progressHUD.color = [UIColor colorWithHex:@"#C34E4E"];
    self.progressHUD.labelFont = [UIFont systemFontOfSize:16];
    self.progressHUD.detailsLabelFont = [UIFont systemFontOfSize:12];
    self.progressHUD.completionBlock = callback;
    [self.view addSubview:self.progressHUD];

    if (callback) {
        callback();
    }
}

- (void)dismissProgressHUDWithCallback:(void(^)())callback {
    if (!self.progressHUD) {
        [self initProgressHUD];
    }
    self.progressHUD.taskInProgress = NO;
    [self.progressHUD hide:YES];


    if (callback) {
        callback();
    }
}

@end