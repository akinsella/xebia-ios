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
#import "SVProgressHUD.h"
#import "UITableViewCell+VariableHeight.h"


@implementation XBTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];

    if (self) {
        [self initialize];
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }

    return self;
}

-(void)initialize {
   _dataSource = [XBHttpArrayDataSource dataSourceWithConfiguration:[self.delegate configuration]
                                                         httpClient:self.configurationProvider.httpClient];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_dataSource loadDataWithForceReload:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
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
        [SVProgressHUD showWithStatus:@"Fetching data" maskType:SVProgressHUDMaskTypeBlack];
        [self.dataSource loadDataWithForceReload:YES
            callback:^(){
                if (self.dataSource.error) {
                    [SVProgressHUD showErrorWithStatus:@"Got some issue!"];
                }
                else {
                    [SVProgressHUD showSuccessWithStatus:@"Done!"];
                }
                [self.tableView.pullToRefreshView stopAnimating];
            }
        ];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([self.delegate respondsToSelector:@selector(onSelectCell:forObject:withIndex:)]) {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];

        [self.delegate onSelectCell:cell forObject:self.dataSource[(NSUInteger)indexPath.row] withIndex:indexPath];
    }
}

- (void)didReceiveMemoryWarning{
    NSLog(@"Did received a memory warning in controller: %@", [self class]);
    [super didReceiveMemoryWarning];
}

@end