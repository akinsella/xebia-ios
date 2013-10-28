//
//  WPCategoryTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "XBHomeController.h"
#import "UIViewController+XBAdditions.h"
#import "GAITracker.h"
#import "XBPListConfigurationProvider.h"
#import "XBBasicHttpQueryParamBuilder.h"
#import "XBHttpJsonDataLoader.h"
#import "XBJsonToArrayDataMapper.h"
#import "XBNewsWordpressCell.h"

static NSString *kWordpressCellReuseIdentifier = @"XBNewsWordpress";
static NSString *kVimeoCellReuseIdentifier = @"XBNewsVimeo";
static NSString *kOtherCellReuseIdentifier = @"XBNewsOther";
static NSString *kTwitterCellReuseIdentifier = @"XBNewsTwitter";
static NSString *kEventBriteCellReuseIdentifier = @"XBNewsEventBrite";

NSString *kWordpressType = @"wordpress";
NSString *kTwitterType = @"twitter";
NSString *kEventBriteType = @"eventbrite";
NSString *kVimeoType = @"vimeo";
NSString *kOtherType = @"other";


@interface XBHomeController()

@property(nonatomic, strong)NSDictionary *cellNibNames;
@property(nonatomic, strong)NSDictionary *cellReuseIdentifiers;

@end

@implementation XBHomeController

- (void)viewDidLoad {

    [self.appDelegate.tracker sendView:@"/home"];

    self.title = NSLocalizedString(@"Home", nil);
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_home_pattern-light"]];

    [self customizeNavigationBarAppearance];
    [self addMenuButton];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.cellNibNames = @{
            kWordpressType: @"XBNewsWordpressElementCell",
            kEventBriteType: @"XBNewsEventBriteElementCell",
            kVimeoType: @"XBNewsVimeoElementCell",
            kTwitterType: @"XBNewsTwitterElementCell",
            kOtherType: @"XBNewsOtherElementCell",
    };

    self.cellReuseIdentifiers = @{
            kWordpressType: kWordpressCellReuseIdentifier,
            kEventBriteType: kTwitterCellReuseIdentifier,
            kVimeoType: kVimeoCellReuseIdentifier,
            kTwitterType: kTwitterCellReuseIdentifier,
            kOtherType: kOtherCellReuseIdentifier,
    };

    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (XBArrayDataSource *)buildDataSource {
    XBHttpClient *httpClient = [[XBPListConfigurationProvider provider] httpClient];
    XBBasicHttpQueryParamBuilder *httpQueryParamBuilder = [XBBasicHttpQueryParamBuilder builderWithDictionary:@{}];
    XBHttpJsonDataLoader *dataLoader = [XBHttpJsonDataLoader dataLoaderWithHttpClient:httpClient httpQueryParamBuilder:httpQueryParamBuilder resourcePath:@"/api/news"];
    XBJsonToArrayDataMapper *dataMapper = [XBJsonToArrayDataMapper mapperWithRootKeyPath:nil typeClass:[XBNews class]];
    return [XBReloadableArrayDataSource dataSourceWithDataLoader:dataLoader dataMapper:dataMapper];
}

- (NSString *)cellReuseIdentifierAtIndexPath:(NSIndexPath *)indexPath {

    XBNews *news = self.dataSource[(NSUInteger) indexPath.row];

    return self.cellNibNames[news.type];
}

- (NSString *)cellNibNameAtIndexPath:(NSIndexPath *)indexPath {

    XBNews *news = self.dataSource[(NSUInteger) indexPath.row];

    return self.cellReuseIdentifiers[news.type];
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {

    XBAbstractNewsCell *newsCell = (XBAbstractNewsCell *) cell;

    XBNews *news = self.dataSource[(NSUInteger) indexPath.row];

    [newsCell updateWithNews: news];
}

-(void)onSelectCell: (UITableViewCell *)cell forObject: (id) object withIndex: (NSIndexPath *)indexPath {

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    XBNews *news = self.dataSource[(NSUInteger) indexPath.row];
    NSLog(@"News selected: %@", news);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    XBNews *news = self.dataSource[(NSUInteger) indexPath.row];

    XBAbstractNewsCell *newsCell;
    if ([news.type isEqualToString: kWordpressType]) {
        newsCell = [self.tableView dequeueReusableCellWithIdentifier: kWordpressCellReuseIdentifier];
    }
    else if ([news.type isEqualToString: kTwitterType]) {
        newsCell = [self.tableView dequeueReusableCellWithIdentifier: kTwitterCellReuseIdentifier];
    }
    else if ([news.type isEqualToString: kEventBriteType]) {
        newsCell = [self.tableView dequeueReusableCellWithIdentifier: kEventBriteCellReuseIdentifier];
    }
    else if ([news.type isEqualToString: kVimeoType]) {
        news = [self.tableView dequeueReusableCellWithIdentifier: kVimeoCellReuseIdentifier];
    }
    else {
        news = [self.tableView dequeueReusableCellWithIdentifier: kOtherCellReuseIdentifier];
    }

    [newsCell updateWithNews: news];

    return newsCell;
}

@end