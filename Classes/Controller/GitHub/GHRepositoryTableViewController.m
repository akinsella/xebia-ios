//
//  GHRepositoryTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "GHRepository.h"
#import "GHRepositoryTableViewController.h"
#import "GHRepositoryCell.h"
#import "XBBasicHttpQueryParamBuilder.h"
#import "XBPListConfigurationProvider.h"
#import "XBHttpJsonDataLoader.h"
#import "XBJsonToArrayDataMapper.h"
#import "GAITracker.h"
#import "UIViewController+XBAdditions.h"

@implementation GHRepositoryTableViewController

- (void)viewDidLoad {

    [self.appDelegate.tracker sendView:@"/github/repository"];

    self.delegate = self;
    self.title = NSLocalizedString(@"Repositories", nil);

    [super viewDidLoad];
}

- (NSString *)tableView:(UITableView *)tableView cellReuseIdentifierAtIndexPath:(NSIndexPath *)indexPath {
    // Needs to be static
    static NSString *const cellReuseIdentifier = @"GHRepository";

    return cellReuseIdentifier;
}

- (NSString *)tableView:(UITableView *)tableView cellNibNameAtIndexPath:(NSIndexPath *)indexPath {
    return @"GHRepositoryCell";
}

- (UIImage *)defaultImage {
    return [UIImage imageNamed:@"xebia-avatar"];
}

- (XBArrayDataSource *)buildDataSource {
    XBHttpClient *httpClient = [[XBPListConfigurationProvider provider] httpClient];
    XBBasicHttpQueryParamBuilder *httpQueryParamBuilder = [XBBasicHttpQueryParamBuilder builderWithDictionary:@{}];
    XBHttpJsonDataLoader *dataLoader = [XBHttpJsonDataLoader dataLoaderWithHttpClient:httpClient httpQueryParamBuilder:httpQueryParamBuilder resourcePath:@"/api/github/repositories"];
    XBJsonToArrayDataMapper *dataMapper = [XBJsonToArrayDataMapper mapperWithRootKeyPath:nil typeClass:[GHRepository class]];
    return [XBReloadableArrayDataSource dataSourceWithDataLoader:dataLoader dataMapper:dataMapper];
}

- (void)configureCell: (UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {
    GHRepositoryCell *repositoryCell = (GHRepositoryCell *)cell;
    GHRepository *repository = self.dataSource[indexPath.row];

    [repositoryCell updateWithRepository: repository defaultImage: self.defaultImage];
 }

@end