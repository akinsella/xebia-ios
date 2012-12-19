//
//  GHRepositoryTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "GHRepository.h"
#import "GHRepositoryTableViewController.h"
#import "UIColor+XBAdditions.h"
#import "SVPullToRefresh.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "XBFetchInfo.h"
#import "UITableViewCell+VariableHeight.h"

@interface XBTableViewController ()
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation XBTableViewController

- (id)init {
    self = [super init];

    if (self) {
        // Init code
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadDataWithForceReload:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
}


- (void)loadDataWithForceReload:(bool)force {
    [self loadDataWithForceReload:force UsingBlock: nil];
}


- (void)loadDataWithForceReload:(bool)force UsingBlock:(void(^)(void))callback {

    self.dataSource = [[self.delegate fetchDataFromDB] mutableCopy];

    XBFetchInfo *fetchInfo = [self fetchInfos];

    NSTimeInterval repositoryDataAge = [self dataAgeFromFetchInfo:fetchInfo];
    BOOL needUpdateFromServer = repositoryDataAge > [self.delegate maxDataAgeInSecondsBeforeServerFetch];

    NSLog(@"Data age: %f seconds", repositoryDataAge);

    if (needUpdateFromServer) {
        NSLog(@"Data last update from server was %f seconds ago, forcing update from server", repositoryDataAge);
    }

    if (!needUpdateFromServer && !force && (self.dataSource && self.dataSource.count > 0) ) {
        [self.tableView reloadData];
        if (callback) {
            callback();
        }
    }
    else {
        [self fetchDataFromServer:callback];
    }

}

- (NSTimeInterval)dataAgeFromFetchInfo:(XBFetchInfo *)fetchInfo {
    return fetchInfo ? [[NSDate date] timeIntervalSinceDate:fetchInfo.lastUpdate] : DBL_MAX;
}

- (void)fetchDataFromServer:(void (^)())callback {
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:[AppDelegate baseUrl]]];
    NSURLRequest *urlRequest = [client requestWithMethod:@"GET" path:[self.delegate urlPath] parameters:nil];

    [SVProgressHUD showWithStatus:@"Fetching data" maskType:SVProgressHUDMaskTypeBlack];

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSLog(@"JSON: %@", JSON);
            NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];

            [[self.delegate dataClass] MR_importFromArray: JSON];
            self.dataSource = [[self.delegate fetchDataFromDB] mutableCopy];
            [self.tableView reloadData];
            if (callback) {
                callback();
            }
            [self updateFetchInfos:localContext];

            [SVProgressHUD showSuccessWithStatus:@"Done!"];
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [SVProgressHUD showErrorWithStatus:@"Got some issue!"];
            NSLog(@"Error: %@, JSON: %@", error, JSON);
            if (callback) {
                callback();
            }
        }
    ];

    [operation start];
}

- (void)updateFetchInfos:(NSManagedObjectContext *)localContext {
    XBFetchInfo *fetchInfo = [self fetchInfos];
    if (!fetchInfo) {
        fetchInfo = [XBFetchInfo MR_createEntity];
        fetchInfo.key = [[self.delegate dataClass] description];
    }
    fetchInfo.lastUpdate = [NSDate date];
    [localContext MR_saveNestedContexts];
}

- (XBFetchInfo *)fetchInfos {
    return [XBFetchInfo MR_findFirstByAttribute:@"key" withValue:[[_delegate dataClass] description]];
}


- (id)objectAtIndex:(NSUInteger)index {
    return [self.dataSource objectAtIndex:index];
}


- (void)configureTableView {
    self.tableView.backgroundColor = [UIColor colorWithPatternImageName:@"bg_home_pattern"];
//    self.tableView.backgroundColor = [UIColor colorWithHex:@"#191919" alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.tableView registerNib:[UINib nibWithNibName:[self.delegate cellNibName] bundle:nil] forCellReuseIdentifier:[self.delegate cellReuseIdentifier]];

    self.tableView.pullToRefreshView.arrowColor = [UIColor whiteColor];
    self.tableView.pullToRefreshView.textColor = [UIColor whiteColor];
    self.tableView.pullToRefreshView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;

    [self.tableView addPullToRefreshWithActionHandler:^{
        [self loadDataWithForceReload:YES UsingBlock:^{
            [self.tableView.pullToRefreshView stopAnimating];
        }];
    }];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[self.delegate cellReuseIdentifier]];

    if (!cell) {
        // fix for rdar://11549999 (registerNib… fails on iOS 5 if VoiceOver is enabled)
        cell = [[[NSBundle mainBundle] loadNibNamed:[self.delegate cellReuseIdentifier] owner:self options:nil] objectAtIndex:0];
    }

    [self.delegate configureCell:cell atIndex:indexPath];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];

    return [cell respondsToSelector:@selector(heightForCell)] ? [cell heightForCell] : self.tableView.rowHeight;
}

- (void)didReceiveMemoryWarning{
    NSLog(@"Did received a memory warning in controller: %@", [self class]);
    [super didReceiveMemoryWarning];
}

@end