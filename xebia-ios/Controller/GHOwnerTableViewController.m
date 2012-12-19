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
#import "CoreData+MagicalRecord.h"
#import "NSManagedObject+MagicalDataImport.h"

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

    [self loadTableDataForce: false UsingBlock:^{ }];
}

- (void)loadTableDataForce:(bool)force UsingBlock:(void (^)(void))block {

    self.dataSource = [[GHOwner MR_findAll] mutableCopy];
    if (!force && self.dataSource && self.dataSource.count > 0) {
        [self.tableView reloadData];
        if (block) {
            block();
        }
    }
    else {
        AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://xebia-mobile-backend.cloudfoundry.com"]];
        NSURLRequest *urlRequest = [client requestWithMethod:@"GET" path:@"/api/github/owners" parameters:nil];

        [SVProgressHUD showWithStatus:@"Fetching owners" maskType:SVProgressHUDMaskTypeBlack];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest
                success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                    [SVProgressHUD showSuccessWithStatus:@"Done!"];
                    [GHOwner MR_importFromArray:JSON];
                    self.dataSource = [[GHOwner MR_findAll] mutableCopy];
                    [self.tableView reloadData];
                    if (block) {
                        block();
                    }
                }
                failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                    [SVProgressHUD showErrorWithStatus:@"Got some issue!"];
                    if (block) {
                        block();
                    }
                }
        ];

        [operation start];
    }

/*
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
*/
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

    [self.tableView addPullToRefreshWithActionHandler:^{
        [self loadTableDataForce: true UsingBlock:^{
            [self.tableView.pullToRefreshView stopAnimating];
        }];
    }];
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