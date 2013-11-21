//
//  WPCategoryTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "XBTimelineController.h"
#import "UIViewController+XBAdditions.h"
#import "GAITracker.h"
#import "XBPListConfigurationProvider.h"
#import "XBBasicHttpQueryParamBuilder.h"
#import "XBHttpJsonDataLoader.h"
#import "XBJsonToArrayDataMapper.h"
#import "XBNewsWordpressCell.h"
#import "UIColor+XBAdditions.h"
#import "SVPullToRefresh.h"

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


@interface XBTimelineController ()

@property(nonatomic, strong)NSDictionary *cellNibNames;
@property(nonatomic, strong)NSDictionary *cellReuseIdentifiers;

@end

@implementation XBTimelineController

- (void)viewDidLoad {

    [self.appDelegate.tracker sendView:@"/timeline"];

    self.title = NSLocalizedString(@"Timeline", nil);
    self.view.backgroundColor = [UIColor colorWithHex:@"#F0F0F0"];

    self.delegate = self;
    [self customizeNavigationBarAppearance];
    [self addMenuButton];

    self.cellNibNames = @{
            kWordpressType: @"XBNewsWordpressCell",
            kEventBriteType: @"XBNewsEventBriteCell",
            kVimeoType: @"XBNewsVimeoCell",
            kTwitterType: @"XBNewsTwitterCell",
            kOtherType: @"XBNewsOtherCell",
    };

    self.cellReuseIdentifiers = @{
            kWordpressType: kWordpressCellReuseIdentifier,
            kEventBriteType: kEventBriteCellReuseIdentifier,
            kVimeoType: kVimeoCellReuseIdentifier,
            kTwitterType: kTwitterCellReuseIdentifier,
            kOtherType: kOtherCellReuseIdentifier,
    };

    [super viewDidLoad];
}

- (void)configureTableView {
    [super configureTableView];

    self.tableView.backgroundColor = [UIColor colorWithHex:@"#E0E0E0"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (XBArrayDataSource *)buildDataSource {
    XBHttpClient *httpClient = [[XBPListConfigurationProvider provider] httpClient];
    XBBasicHttpQueryParamBuilder *httpQueryParamBuilder = [XBBasicHttpQueryParamBuilder builderWithDictionary:@{}];
    XBHttpJsonDataLoader *dataLoader = [XBHttpJsonDataLoader dataLoaderWithHttpClient:httpClient httpQueryParamBuilder:httpQueryParamBuilder resourcePath:@"/timeline"];
    XBJsonToArrayDataMapper *dataMapper = [XBJsonToArrayDataMapper mapperWithRootKeyPath:nil typeClass:[XBNews class]];
    return [XBReloadableArrayDataSource dataSourceWithDataLoader:dataLoader dataMapper:dataMapper];
}

- (NSString *)tableView:(UITableView *)tableView cellReuseIdentifierAtIndexPath:(NSIndexPath *)indexPath {

    XBNews *news = self.dataSource[(NSUInteger) indexPath.row];

    return self.cellReuseIdentifiers[news.type];
}

- (NSString *)tableView:(UITableView *)tableView cellNibNameAtIndexPath:(NSIndexPath *)indexPath {

    XBNews *news = self.dataSource[(NSUInteger) indexPath.row];

    return self.cellNibNames[news.type];
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {

    XBAbstractNewsCell *newsCell = (XBAbstractNewsCell *) cell;

    XBNews *news = self.dataSource[(NSUInteger) indexPath.row];

    [newsCell updateWithNews: news];
}

-(void)onSelectCell: (UITableViewCell *)cell forObject: (id) object withIndex: (NSIndexPath *)indexPath {

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    [(XBAbstractNewsCell *)cell onSelection];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return YES;
}

@end