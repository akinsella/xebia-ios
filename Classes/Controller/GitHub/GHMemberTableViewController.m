//
//  GHMemberTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "GHMember.h"
#import "GHMemberTableViewController.h"
#import "GHMemberCell.h"
#import "XBPListConfigurationProvider.h"
#import "XBBasicHttpQueryParamBuilder.h"
#import "XBHttpJsonDataLoader.h"
#import "XBJsonToArrayDataMapper.h"
#import "GAITracker.h"
#import "UIViewController+XBAdditions.h"

@implementation GHMemberTableViewController

- (void)viewDidLoad {

    [self.appDelegate.tracker sendView:@"/github/member"];

    self.delegate = self;
    self.title = NSLocalizedString(@"Members", nil);

    [super viewDidLoad];
}

- (NSString *)cellReuseIdentifierAtIndexPath:(NSIndexPath *)indexPath {
    // Needs to be static
    static NSString *cellReuseIdentifier = @"GHMember";

    return cellReuseIdentifier;
}

- (NSString *)cellNibNameAtIndexPath:(NSIndexPath *)indexPath {
    return @"GHMemberCell";
}

- (XBArrayDataSource *)buildDataSource {
    XBHttpClient *httpClient = [[XBPListConfigurationProvider provider] httpClient];
    XBBasicHttpQueryParamBuilder *httpQueryParamBuilder = [XBBasicHttpQueryParamBuilder builderWithDictionary:@{}];
    XBHttpJsonDataLoader *dataLoader = [XBHttpJsonDataLoader dataLoaderWithHttpClient:httpClient httpQueryParamBuilder:httpQueryParamBuilder resourcePath:@"/api/github/member"];
    XBJsonToArrayDataMapper *dataMapper = [XBJsonToArrayDataMapper mapperWithRootKeyPath:nil typeClass:[GHMember class]];
    return [XBReloadableArrayDataSource dataSourceWithDataLoader:dataLoader dataMapper:dataMapper];
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {

    GHMemberCell *memberCell = (GHMemberCell *) cell;

    GHMember *owner = self.dataSource[indexPath.row];

    [memberCell updateWithMember: owner];
}

@end