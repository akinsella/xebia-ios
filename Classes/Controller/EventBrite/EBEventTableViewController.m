//
//  EBEventTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "XBHttpJsonDataLoader.h"
#import "XBJsonToArrayDataMapper.h"
#import "XBBasicHttpQueryParamBuilder.h"
#import "EBEventTableViewController.h"
#import "EBEvent.h"
#import "EBEventCell.h"
#import "UIViewController+XBAdditions.h"
#import "XBPListConfigurationProvider.h"
#import "EBEventDetailsViewController.h"
#import "NSString+XBAdditions.h"

@implementation EBEventTableViewController

- (NSString *)trackPath {
    return [NSString stringWithFormat:@"/events"];
}

- (void)viewDidLoad {

   self.delegate = self;
    self.title = NSLocalizedString(@"Events", nil);

    [self customizeNavigationBarAppearance];
    [self addMenuButton];

    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView cellReuseIdentifierAtIndexPath:(NSIndexPath *)indexPath {
    // Needs to be static
    static NSString *cellReuseIdentifier = @"EBEvent";

    return cellReuseIdentifier;
}

- (NSString *)tableView:(UITableView *)tableView cellNibNameAtIndexPath:(NSIndexPath *)indexPath {
    return [@"EBEventCell" suffixIfIPad];
}

- (XBArrayDataSource *)buildDataSource {
    XBHttpClient *httpClient = [[XBPListConfigurationProvider provider] httpClient];
    XBBasicHttpQueryParamBuilder *httpQueryParamBuilder = [XBBasicHttpQueryParamBuilder builderWithDictionary:@{}];
    XBHttpJsonDataLoader *dataLoader = [XBHttpJsonDataLoader dataLoaderWithHttpClient:httpClient httpQueryParamBuilder:httpQueryParamBuilder resourcePath:@"/events"];
    XBJsonToArrayDataMapper *dataMapper = [XBJsonToArrayDataMapper mapperWithRootKeyPath:nil typeClass:[EBEvent class]];
    return [XBReloadableArrayDataSource dataSourceWithDataLoader:dataLoader dataMapper:dataMapper];
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {

    EBEventCell *eventCell = (EBEventCell *) cell;

    EBEvent *event = self.dataSource[(NSUInteger) indexPath.row];

    [eventCell updateWithEvent: event];
}

-(void)onSelectCell: (UITableViewCell *)cell forObject: (id) object withIndex: (NSIndexPath *)indexPath {
    EBEvent *event = self.dataSource[(NSUInteger) indexPath.row];
    EBEventDetailsViewController *eventDetailsViewController = (EBEventDetailsViewController *) [[self appDelegate].viewControllerManager getOrCreateControllerWithIdentifier:@"eventDetails"];
    [eventDetailsViewController updateWithEvent:event];
    [self.navigationController pushViewController:eventDetailsViewController animated:YES];
}

@end