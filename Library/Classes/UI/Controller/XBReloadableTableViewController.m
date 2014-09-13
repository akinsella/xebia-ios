//
// Created by akinsella on 05/04/13.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <AFNetworking/AFNetworkReachabilityManager.h>
#import "XBReloadableTableViewController.h"
#import "SVPullToRefresh.h"
#import "MBProgressHUD.h"
#import "UIViewController+XBAdditions.h"
#import "UIColor+XBAdditions.h"

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable) {
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

@end