//
// Created by Simone Civetta on 02/03/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>
#import <SSToolkit/UIColor+SSToolkitAdditions.h>
#import "XBLoadableTableViewController.h"


@interface XBLoadableTableViewController()

@property (nonatomic, strong) MBProgressHUD *progressHUD;

@end

@implementation XBLoadableTableViewController

-(XBReloadableArrayDataSource *)reloadableDataSource {
    return (XBReloadableArrayDataSource *)self.dataSource;
}

- (void)viewDidLoad {
    [self initProgressHUD];
    [super viewDidLoad];
}

-(void)loadData {
    [self loadDataWithProgress:YES callback:^{
        [self.tableView reloadData];
    }];
}

-(void)loadDataWithProgress:(BOOL)showProgress callback:(void(^)())callback {
    
    if (![self.reloadableDataSource respondsToSelector:@selector(loadDataWithCallback:)]) {
        [super loadData];
        return;
    }

    if (showProgress) {
        [self showProgressHUD];
    }
    
    [self.reloadableDataSource loadDataWithCallback:^ {
        if (self.reloadableDataSource.error) {
            [self showErrorProgressHUDWithCallback:callback];
        }
        else {
            if (showProgress) {
                [self dismissProgressHUDWithCallback:callback];
            }
            else if (callback) {
                callback();
            }
        }
    }];
}

- (void)initProgressHUD {
    if (!self.progressHUD) {
        self.progressHUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        self.progressHUD.userInteractionEnabled = NO;
    }
}

- (void)showProgressHUD {
    [self showProgressHUDWithMessage:NSLocalizedString(@"Loading...", nil)
                           graceTime:0.5];
    [self.navigationController.view addSubview:self.progressHUD];
}

- (void)showProgressHUDWithMessage:(NSString *)message graceTime:(float)graceTime {
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
    [self.navigationController.view addSubview:self.progressHUD];
    self.progressHUD.removeFromSuperViewOnHide = YES;
    [self.progressHUD show:YES];
}

- (void)showProgressHUDWithTitle:(NSString *)title
                         message:(NSString *)message
                           delay:(float)delay
                         yOffset:(CGFloat)yOffset
                           color:(UIColor *) color
                        callback:(void(^)())callback {
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
    self.progressHUD.removeFromSuperViewOnHide = YES;
    [self.navigationController.view addSubview:self.progressHUD];


    [self.progressHUD show:YES];
    [self.progressHUD hide:YES afterDelay:delay];
}

- (void)showErrorProgressHUDWithCallback:(void(^)())callback {
    [self showErrorProgressHUDWithMessage:NSLocalizedString(@"Error during loading", nil)
                               afterDelay:1.0
                                 callback:callback];
}

- (void)showErrorProgressHUDWithMessage:(NSString *)errorMessage afterDelay:(float)delay callback:(void(^)())callback {
    self.progressHUD.mode = MBProgressHUDModeText;
    self.progressHUD.labelText = errorMessage;
    self.progressHUD.taskInProgress = NO;
    self.progressHUD.yOffset = 0;
    self.progressHUD.margin = 20;
    self.progressHUD.color = [UIColor colorWithHex:@"#C34E4E"];
    self.progressHUD.labelFont = [UIFont systemFontOfSize:16];
    self.progressHUD.detailsLabelFont = [UIFont systemFontOfSize:12];
    self.progressHUD.completionBlock = callback;
    self.progressHUD.removeFromSuperViewOnHide = YES;
    [self.navigationController.view addSubview:self.progressHUD];

    [self.progressHUD show:YES];
    [self.progressHUD hide:YES afterDelay:delay];

    if (callback) {
        callback();
    }
}

- (void)dismissProgressHUDWithCallback:(void(^)())callback {
    self.progressHUD.taskInProgress = NO;
    [self.progressHUD hide:YES];
    [self.progressHUD removeFromSuperview];


    if (callback) {
        callback();
    }
}

@end