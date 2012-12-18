//
//  GHOwnerTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <RestKit/UI.h>
#import "GHOwner.h"
#import "GHOwnerTableViewController.h"
#import "XBLoadingView.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "UIImage+XBAdditions.h"
#import "UIColor+XBAdditions.h"
#import "UIScreen+XBAdditions.h"
#import "GHOwnerCell.h"
#import "SVPullToRefresh.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
//#import "UIImageView+AFNetworking.h"
#import "UIImageView+WebCache.h"

@interface GHOwnerTableViewController ()
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIImage* defaultAvatarImage;
@end

@implementation GHOwnerTableViewController

- (id)init {
    self = [super init];

    if (self) {
        self.title = @"Owners";
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self loadTableData];

}

- (void)loadTableData {

/*
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://xebia-mobile-backend.cloudfoundry.com/api"]];
    NSURLRequest *request = [client requestWithMethod:@"GET" path:@"/github/owners" parameters:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

    [SVProgressHUD showWithStatus:@"Fetching users" maskType:SVProgressHUDMaskTypeBlack];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"Done!"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"Got some issue!"];
    }];
*/

    [SVProgressHUD showWithStatus:@"Fetching users" maskType:SVProgressHUDMaskTypeBlack];

    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/github/owners" usingBlock:^(RKObjectLoader *loader) {

        loader.onDidLoadObjects = ^(NSArray *objects) {
            [SVProgressHUD showSuccessWithStatus:@"Done!"];
            self.dataSource = [objects mutableCopy];
            [self.tableView reloadData];
        };

        loader.onDidFailWithError = ^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"Got some issue!"];
        };

    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
}

- (void)configure {
    self.defaultAvatarImage = [UIImage imageNamed:@"github-gravatar-placeholder"];

    [self configureTableView];
}

- (void)configureTableView {
    self.tableView.backgroundColor = [UIColor colorWithPatternImageName:@"bg_home_pattern"];
//    self.tableView.backgroundColor = [UIColor colorWithHex:@"#191919" alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.tableView registerNib:[UINib nibWithNibName:@"GHOwnerCell" bundle:nil] forCellReuseIdentifier:@"GHOwner"];

    self.tableView.pullToRefreshView.arrowColor = [UIColor whiteColor];
    self.tableView.pullToRefreshView.textColor = [UIColor whiteColor];
    self.tableView.pullToRefreshView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
}

- (void)didReceiveMemoryWarning{
    NSLog(@"Did received a memory warning in controller: %@", [self class]);
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *identifier = @"GHOwner";
    GHOwnerCell *ownerCell = [self.tableView dequeueReusableCellWithIdentifier:identifier];

    if (!ownerCell) {
        // fix for rdar://11549999 (registerNib… fails on iOS 5 if VoiceOver is enabled)
        ownerCell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil] objectAtIndex:0];
    }

    GHOwner *owner = [self.dataSource objectAtIndex:indexPath.row];
    ownerCell.titleLabel.text = owner.login;
    ownerCell.identifier = owner.identifier;


    [ownerCell.imageView setImageWithURL:[owner avatarImageUrl] placeholderImage:self.defaultAvatarImage];

    return ownerCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    GHOwnerCell *ownerCell =  (GHOwnerCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];

    return [ownerCell heightForCell];
}

@end