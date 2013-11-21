//
// Created by akinsella on 05/04/13.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "XBReloadableTableViewController.h"
#import "SVPullToRefresh.h"
#import "MBProgressHUD.h"
#import "UIViewController+XBAdditions.h"
#import "UIColor+SSToolkitAdditions.h"

@interface XBReloadableTableViewController()

@property (nonatomic, strong) MBProgressHUD *progressHUD;

@end


@implementation XBReloadableTableViewController

-(XBReloadableArrayDataSource *)reloadableDataSource {
    return (XBReloadableArrayDataSource *)self.dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initProgressHUD];
}

- (void)configureTableView {
    [super configureTableView];

    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf loadDataWithProgress:NO callback:^{
            [weakSelf.tableView.pullToRefreshView stopAnimating];
            [weakSelf.tableView reloadData];
        }];
    }];

    self.tableView.pullToRefreshView.arrowColor = [UIColor darkGrayColor];
    self.tableView.pullToRefreshView.textColor = [UIColor darkGrayColor];
    self.tableView.pullToRefreshView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
}

-(void)loadData {
    [self loadDataWithProgress:YES callback:^{
        [self.tableView reloadData];
    }];
}

-(void)loadDataWithProgress:(BOOL)showProgress callback:(void(^)())callback {
    if (!self.appDelegate.configurationProvider.reachability.isReachable) {
        [self showProgressHUDWithTitle: NSLocalizedString(@"Erreur", nil)
                               message: NSLocalizedString(@"Vous n'avez pas de connection internet.", nil)
                                 delay:1.0
                               yOffset: 200
                                   color:[UIColor colorWithHex:@"#C34E4E"]
                         callback:callback
        ];
    }
    else {
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
}

- (void)initProgressHUD {
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
}

- (void)showProgressHUD {
    [self showProgressHUDWithMessage:NSLocalizedString(@"Chargement...", nil)
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
    [self.navigationController.view addSubview:self.progressHUD];


    [self.progressHUD show:YES];
    [self.progressHUD hide:YES afterDelay:delay];
}

- (void)showErrorProgressHUDWithCallback:(void(^)())callback {
    [self showErrorProgressHUDWithMessage:NSLocalizedString(@"Erreur pendant le chargement", nil)
                               afterDelay:1.0
                                 callback:callback];
}

- (void)showErrorProgressHUDWithMessage:(NSString *)errorMessage afterDelay:(float)delay callback:(void(^)())callback {
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
    [self.navigationController.view addSubview:self.progressHUD];

    if (callback) {
        callback();
    }
}

- (void)dismissProgressHUDWithCallback:(void(^)())callback {
    self.progressHUD.taskInProgress = NO;
    [self.progressHUD hide:YES];


    if (callback) {
        callback();
    }
}

@end