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

@interface GHRepositoryTableViewController()
@property (nonatomic, strong) UIImage* xebiaAvatarImage;
@end

@implementation GHRepositoryTableViewController

- (void)viewDidLoad {

    [self.appDelegate.tracker sendView:@"/github/repository"];

    self.delegate = self;
    self.title = NSLocalizedString(@"Repositories", nil);
    self.xebiaAvatarImage = [UIImage imageNamed:@"xebia-avatar"];

    [super viewDidLoad];
}

- (NSString *)cellReuseIdentifier {
    // Needs to be static
    static NSString *const cellReuseIdentifier = @"GHRepository";

    return cellReuseIdentifier;
}

- (NSString *)cellNibName {
    return @"GHRepositoryCell";
}

- (UIImage *)defaultImage {
    return [UIImage imageNamed:@"xebia-avatar"];
}

- (XBArrayDataSource *)buildDataSource {
    XBHttpClient *httpClient = [[XBPListConfigurationProvider provider] httpClient];
    XBBasicHttpQueryParamBuilder *httpQueryParamBuilder = [XBBasicHttpQueryParamBuilder builderWithDictionary:@{}];
    XBHttpJsonDataLoader *dataLoader = [XBHttpJsonDataLoader dataLoaderWithHttpClient:httpClient httpQueryParamBuilder:httpQueryParamBuilder resourcePath:@"/api/github/repository"];
    XBJsonToArrayDataMapper *dataMapper = [XBJsonToArrayDataMapper mapperWithRootKeyPath:nil typeClass:[GHRepository class]];
    return [XBReloadableArrayDataSource dataSourceWithDataLoader:dataLoader dataMapper:dataMapper];
}

- (void)configureCell: (UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {
    GHRepositoryCell *repositoryCell = (GHRepositoryCell *)cell;
    GHRepository *repository = self.dataSource[indexPath.row];
    repositoryCell.titleLabel.text = repository.name;
    repositoryCell.descriptionLabel.text = repository.description_;
    repositoryCell.identifier = repository.identifier;
    [repositoryCell.imageView setImage:self.defaultImage];
}

@end