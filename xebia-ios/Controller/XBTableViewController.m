//
//  GHRepositoryTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "GHRepositoryTableViewController.h"
#import "UIColor+XBAdditions.h"
#import "SVPullToRefresh.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "UITableViewCell+VariableHeight.h"
#import "XBArrayDataSource.h"

@interface XBTableViewController ()
@property (nonatomic, strong) XBArrayDataSource *dataSource;
@property (nonatomic, strong) NSDateFormatter *df;
@end

@implementation XBTableViewController

- (id)init {
    self = [super init];

    if (self) {
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

    self.dataSource = [self fetchDataFromDB];

    NSTimeInterval repositoryDataAge = [self dataAgeFromFetchInfo];
    BOOL needUpdateFromServer = repositoryDataAge > [self.delegate maxDataAgeInSecondsBeforeServerFetch];

    NSLog(@"Data age: %f seconds", repositoryDataAge);

    if (needUpdateFromServer) {
        NSLog(@"Data last update from server was %f seconds ago, forcing update from server", repositoryDataAge);
    }

    if (!needUpdateFromServer && !force && (self.dataSource && self.dataSource.array.count > 0) ) {
        [self.tableView reloadData];
        if (callback) {
            callback();
        }
    }
    else {
        [self fetchDataFromServer:callback];
    }
}

- (NSTimeInterval)dataAgeFromFetchInfo {
    NSDate *lastUpdate = self.dataSource.lastUpdate;
    return self.dataSource.lastUpdate ? [lastUpdate timeIntervalSinceNow] : DBL_MAX;
}

- (void)fetchDataFromServer:(void (^)())callback {
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:[AppDelegate baseUrl]]];
    NSURLRequest *urlRequest = [client requestWithMethod:@"GET" path:[self.delegate resourcePath] parameters:nil];

    [SVProgressHUD showWithStatus:@"Fetching data" maskType:SVProgressHUDMaskTypeBlack];

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id jsonFetched) {
            NSLog(@"jsonFetched: %@", jsonFetched);

            NSDictionary *json = @{
                    @"lastUpdate": [self.df stringFromDate:[NSDate date]],
                    @"data": jsonFetched
            };

            NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:[self.delegate storageFileName]];
            [json writeToFile:filePath atomically:YES];

            self.dataSource = [[XBArrayDataSource alloc] initWithJson:json ForType:[self.delegate dataClass]];

            [self.tableView reloadData];
            if (callback) {
                callback();
            }
            [SVProgressHUD dismiss];
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id jsonFetched) {
            [SVProgressHUD showErrorWithStatus:@"Got some issue!"];
            NSLog(@"Error: %@, jsonFetched: %@", error, jsonFetched);
            if (callback) {
                callback();
            }
        }
    ];

    [operation start];
}

- (id)objectAtIndex:(NSUInteger)index {
    return self.dataSource.array[index];
}


- (XBArrayDataSource *)fetchDataFromDB {
//    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
//    return [[self dataClass] MR_findAllSortedBy:@"start_date" ascending:YES inContext:localContext];

    return [XBArrayDataSource initFromFileWithStorageFileName:[self.delegate storageFileName] forType:self.delegate.dataClass];
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
    return self.dataSource.array.count;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([self.delegate respondsToSelector:@selector(onSelectCell:forObject:withIndex:)]) {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];

        [self.delegate onSelectCell:cell forObject:self.dataSource.array[(NSUInteger)indexPath.row] withIndex:indexPath];
    }
}

- (void)didReceiveMemoryWarning{
    NSLog(@"Did received a memory warning in controller: %@", [self class]);
    [super didReceiveMemoryWarning];
}

@end